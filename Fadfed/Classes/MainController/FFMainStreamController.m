//
//  FFMainStreamController.m
//  Fadfed
//
//  Created by Hani Abu Shaer on 10/22/13.
//  Copyright (c) 2013 AlphaApps. All rights reserved.
//

#import "FFMainStreamController.h"

@implementation FFMainStreamController

@synthesize streamTableView;
@synthesize feedData;
@synthesize actionType;
@synthesize addButton;

#pragma mark -
#pragma mark View Controller
// View did load
- (void)viewDidLoad
{
    // set header view
    UIView *titleHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIImageView *titleHeaderImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"titleHeader.png"]];
    CGRect frame = titleHeaderImage.frame;
    frame.origin = CGPointMake(4, 12);
    titleHeaderImage.frame = frame;
    [titleHeaderView addSubview:titleHeaderImage];
    self.navigationItem.titleView = titleHeaderView;
    // right button item
    UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    negativeSeperator.width = -16;
    // for ios6
    if (![[FFManager sharedManager] checkUIKitIsFlatMode])
        negativeSeperator.width = -8;
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 44)];
    rightButtonView.backgroundColor = [[FFManager sharedManager] colorRightNavButton];
    addButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 44)];
    [addButton setImage:[UIImage imageNamed:@"plusButton"] forState:UIControlStateNormal];
    [addButton setImage:[UIImage imageNamed:@"plusButton"] forState:UIControlStateDisabled];
    // click the button fire toggleMenu from navigation controller
    [addButton addTarget:self action:@selector(openMenuPressed) forControlEvents:UIControlEventTouchUpInside];
    [rightButtonView addSubview:addButton];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    NSArray *actionButtonItems = @[negativeSeperator, addItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    menuClicked = NO;
    // add refresh table control
    tableRefreshControl = [[UIRefreshControl alloc] init];
    [tableRefreshControl addTarget:self action:@selector(refreshTable) forControlEvents:UIControlEventValueChanged];
    [streamTableView addSubview:tableRefreshControl];
    [streamTableView setHidden:NO];
    // Load from cache
    FFManager *cacheManager = [FFManager sharedManager];
    NSMutableArray *savedFeed = [cacheManager cachedFeedData];
    // feed data exist
    if (savedFeed != nil)
    {
        feedData = [[NSMutableArray alloc] initWithArray:savedFeed];
        streamTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        [streamTableView setScrollEnabled:YES];
    }
    else // new data
    {
        feedData = [[NSMutableArray alloc] init];
        streamTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [streamTableView setScrollEnabled:NO];
    }
    // download feed
    batchNumber = 0;
    activeFeedObject = [[NSMutableDictionary alloc] init];
    actionType = FFActionImageUse;
    // set loading flag
    loadingInProgress = NO;
    [self downloadFeed];
    [super viewDidLoad];
}

// View will layout the other subviews
- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    FFNavigationController *navigationController = (FFNavigationController*)self.navigationController;
    [navigationController.menu setNeedsLayout];
}

// Receive memory warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Change navigation bar color
- (void)viewWillAppear:(BOOL)animated
{
    // flat mode iOS7
    if ([[FFManager sharedManager] checkUIKitIsFlatMode])
    {
        [self.navigationController.navigationBar performSelector:@selector(setBarTintColor:) withObject:[[FFManager sharedManager] colorNavigationBar]];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.translucent = NO;        
    }
    else// iOS6
    {
        self.navigationController.navigationBar.tintColor = [[FFManager sharedManager] colorNavigationBar];
    }
}

// Add button pressed
- (void)openMenuPressed
{
    FFNavigationController *navController = (FFNavigationController*)self.navigationController;
    [navController toggleMenu];
    addButton.enabled = NO;
    // menu opened
    if (menuClicked)
    {
        [UIView animateWithDuration:0.3f
                                delay:0.0f
                                options: UIViewAnimationOptionCurveLinear
                                animations:^{
                                    addButton.transform=CGAffineTransformMakeRotation(0);
                                }
                                completion:^(BOOL finished) {
                                    addButton.enabled = YES;
                                }];
                                menuClicked = NO;
    }
    else// menu closed
    {
        [UIView animateWithDuration:0.3f
                                delay:0.0f
                                options: UIViewAnimationOptionCurveLinear
                                animations:^{
                                    addButton.transform=CGAffineTransformMakeRotation(0.785398);// rotate 45 degrees
                                }
                                completion:^(BOOL finished) {
                                    addButton.enabled = YES;
                                }];
                                menuClicked = YES;
    }
}

// Reset menu button
- (void)resetMenuButton
{
    [UIView animateWithDuration:0.3f
                          delay:0.0f
                        options: UIViewAnimationOptionCurveLinear
                     animations:^{
                         addButton.transform=CGAffineTransformMakeRotation(0);
                     }
                     completion:^(BOOL finished) {
                         addButton.enabled = YES;
                         menuClicked = NO;
                     }];
}

#pragma mark -
#pragma mark Feed Control
// Download list of feed
- (void)downloadFeed
{
    FFManager *cacheManager = [FFManager sharedManager];
    PFQuery *query = [PFQuery queryWithClassName:PARSE_FEED_TABLE];
    [query setLimit:BATCH_FEED_SIZE];
    [query setSkip:batchNumber];
    loadingInProgress = YES;
    // load data in background
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
    {
        // result exists
        if (!error)
        {
            if (batchNumber == 0) // We're refreshing,
            {
                [feedData removeAllObjects]; // So clear this out.
            }
            // add all feed objects to the array
            for (PFObject *feedObject in objects)
            {
                // PFObject is not serializable, meaning it can't be saved to a text file. We need to make a dictionary copy of it and then use that everywhere else.
                NSArray *keys = [[NSArray alloc] initWithObjects:PARSE_FEED_COL_ID, PARSE_FEED_COL_TITLE, PARSE_FEED_COL_IMAGE, PARSE_FEED_COL_SHARE, PARSE_FEED_COL_DATE, nil];
                NSArray *objects = [[NSArray alloc] initWithObjects:[feedObject objectId], [feedObject objectForKey:PARSE_FEED_COL_TITLE], [feedObject objectForKey:PARSE_FEED_COL_IMAGE], [feedObject objectForKey:PARSE_FEED_COL_SHARE], [feedObject createdAt], nil];
                NSMutableDictionary *object = [[NSMutableDictionary alloc] initWithObjects:objects forKeys:keys];
                // add the object
                [feedData addObject:object];
                batchNumber = (int)[feedData count];
            }
            // We've reached the end. Nothing more to load.
            if (objects.count < BATCH_FEED_SIZE)
                endOfFeed = YES;
            else
                endOfFeed = NO;
            // Saving an offline copy of the feed
            [cacheManager saveFeedData:feedData];
        }
        else // error
        {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
            // No internet connection
            if (error.code == 100)
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"الاتصال بالانترنت"
                                                             message:@"تعذر الاتصال بالإنترنت، الرجاء التأكد من الإعدادات."
                                                            delegate:self
                                                   cancelButtonTitle:@"موافق"
                                                   otherButtonTitles:nil];
                [alert show];
            }
            // check the feed data
            if ([feedData count] == 0)
            {
                NSMutableArray *savedFeed = [cacheManager cachedFeedData];
                if (savedFeed != nil)
                    feedData = [[NSMutableArray alloc] initWithArray:savedFeed];
            }
            batchNumber = (int)[feedData count];
            endOfFeed = YES;
        }
        if ([feedData count] > 0)
        {
            streamTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            [streamTableView setScrollEnabled:YES];            
        }
        // end loading
        [tableRefreshControl endRefreshing];
        // reload data
        [streamTableView reloadData];
        loadingInProgress = NO;
    }];
}

// Refresh table
- (void)refreshTable
{
    batchNumber = 0;
    // download the feed again
    if (!loadingInProgress)
        [self downloadFeed];
}

// Load more feed
- (void)loadMoreData
{
    batchNumber = (int)[feedData count];
    if (!loadingInProgress)
        [self downloadFeed];
}

#pragma mark -
#pragma mark - Table view data source
// Number of sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

// Height for row at index path
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Cell for loading more.
    if (indexPath.row == feedData.count)
        return LOADIN_MORE_CELL_HEIGHT;
    else // normal cell
        return NORMAL_CELL_HEIGHT;
}

// Number of rows
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (endOfFeed)
        return [feedData count];
    return [feedData count] + 1;
}

// Cell for row at index path
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Cell for loading more.
    if ((indexPath.row == [feedData count]) && !endOfFeed)
    {
        static NSString *loadMoreCellIdentifier = @"LoadingCell";
        UITableViewCell *loadMoreCell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:loadMoreCellIdentifier];
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        activityIndicator.frame = CGRectMake(140, 0, 44, 44);
        [activityIndicator startAnimating];
        if (loadMoreCell == nil)
        {
            loadMoreCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:loadMoreCellIdentifier];
            loadMoreCell.frame = CGRectZero;
        }
        [loadMoreCell.contentView addSubview:activityIndicator];
        return loadMoreCell;
    }
    else// normal feed cell
    {
        static NSString *CellIdentifier = @"streamTableCell";
        FFMainStreamCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        cell.rowNumber = indexPath.row;
        // Configure the cell...
        NSMutableDictionary *feedObject = [feedData objectAtIndex:indexPath.row];
        [cell populateCellWithContent:feedObject];
        [cell.streamShareBtn addTarget:self action:@selector(shareButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        [cell.streamUseBtn addTarget:self action:@selector(useButtonPressed:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }
}

// Scroll view did end decelerating
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float offset = (scrollView.contentOffset.y - (scrollView.contentSize.height - scrollView.frame.size.height));
    if (offset >= 0 && offset <= 5)
    {
        [self loadMoreData];
    }
}

#pragma mark -
#pragma mark Image Actions
// share button pressed
- (IBAction)shareButtonPressed:(UIButton*)sender
{
    int feedIndex = sender.tag;
    activeFeedObject = [feedData objectAtIndex:feedIndex];
    NSString *facebookString = @"فيسبوك";
    NSString *twitterString = @"تويتر";
    IBActionSheet *sharingOptions = [[IBActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"إلغاء الأمر" destructiveButtonTitle:nil otherButtonTitlesArray:@[facebookString, twitterString]];
    [sharingOptions setFont:[UIFont systemFontOfSize:20]];
    [sharingOptions setButtonTextColor:[[FFManager sharedManager] colorRightNavButton] forButtonAtIndex:2];
    // add images
    NSArray *buttonsArray = [sharingOptions buttons];
    UIButton *btnFace = [buttonsArray objectAtIndex:0];
    [btnFace setImage:[UIImage imageNamed:@"actionFacebookIcon.png"] forState:UIControlStateNormal];
    [btnFace setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 16)];
    UIButton *btnTwitter = [buttonsArray objectAtIndex:1];
    [btnTwitter setImage:[UIImage imageNamed:@"actionTwitterIcon.png"] forState:UIControlStateNormal];
    [btnTwitter setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 16)];
    // view the action sheet
    [sharingOptions showInView:self.navigationController.view];
}

// Action sheet pressed button
- (void)actionSheet:(IBActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *feedPhoto = [activeFeedObject objectForKey:PARSE_FEED_COL_IMAGE];
    NSString *feedTitle = [activeFeedObject objectForKey:PARSE_FEED_COL_TITLE];
    UIImageView* streamImage = [[UIImageView alloc]init];
    [streamImage setImageWithURL:[NSURL URLWithString:feedPhoto]
                placeholderImage:nil
                       completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
     {
     }];
    // Facebook share
    if (buttonIndex == 0)
    {
        [[FFManager sharedManager] facebookPostStandard:feedTitle andPhoto:streamImage.image link:nil controller:self];
    }
    // Twitter Share
    else if (buttonIndex == 1)
    {
        
        
        [[FFManager sharedManager] twitterShareStandrad:feedTitle photo:streamImage.image link:nil controller:self];
    }
}

// Use image button pressed
- (IBAction)useButtonPressed:(UIButton*)sender
{
    int feedIndex = sender.tag;
    activeFeedObject = [feedData objectAtIndex:feedIndex];
    actionType = FFActionImageUse;
    [self performSegueWithIdentifier:@"StreamDetailsSegue" sender:self];
}

#pragma mark -
#pragma mark - Navigation
 // In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"StreamDetailsSegue"])
    {
        FFStreamDetailsController *detailsController = segue.destinationViewController;
        [detailsController setActiveFeed:activeFeedObject withActionType:actionType];
    }
}

@end
