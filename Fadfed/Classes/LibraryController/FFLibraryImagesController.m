//
//  FFLibraryImagesController.m
//  Fadfed
//
//  Created by Hani Abu Shaer on 10/22/13.
//  Copyright (c) 2013 AlphaApps. All rights reserved.
//

#import "FFLibraryImagesController.h"

@implementation FFLibraryImagesController

@synthesize topNavigationBar;
@synthesize libraryCollectionView;
@synthesize feedData;
@synthesize topNavigationItem;
@synthesize categoriesList;
@synthesize filterPicker;
@synthesize filterView;
@synthesize filterNavigationBar;
@synthesize filterNavigationItem;
@synthesize filterBgImage;
@synthesize activeFeedObject;
@synthesize activityLoader;

#pragma mark -
#pragma mark View Controller
// View did load
- (void)viewDidLoad
{
    // configure header view
    [self configureHeaderView];
    [self configurePickerView];
    // Load from cache
    FFManager *cacheManager = [FFManager sharedManager];
    NSMutableArray *savedFeed = [cacheManager cachedTemplateData];
    // feed data exist
    if (savedFeed != nil)
    {
        feedData = [[NSMutableArray alloc] initWithArray:savedFeed];
    }
    else // new data
    {
        [activityLoader startAnimating];
        feedData = [[NSMutableArray alloc] init];
    }
    filteredData = [[NSMutableArray alloc] initWithArray:feedData];
    [libraryCollectionView setHidden:NO];
    // download feed
    batchNumber = 0;
    activeFeedObject = [[NSMutableDictionary alloc] init];
    activeCategory = [[NSMutableDictionary alloc] init];
    // load categories
    NSMutableArray *savedCategory = [cacheManager cachedCategoryData];
    // feed data exist
    if (savedCategory != nil)
    {
        categoriesList = [[NSMutableArray alloc] initWithArray:savedCategory];
        [rightFilterButton setEnabled:YES];
    }
    else // new data
    {
        categoriesList = [[NSMutableArray alloc] init];
        [rightFilterButton setEnabled:NO];
    }
    [self downloadCategories];
    [super viewDidLoad];
}

// Configure header view
- (void)configureHeaderView
{
    // flat mode iOS7
    if ([[FFManager sharedManager] checkUIKitIsFlatMode])
    {
        [self.topNavigationBar performSelector:@selector(setBarTintColor:) withObject:[[FFManager sharedManager] colorNavigationBar]];
        self.topNavigationBar.tintColor = [UIColor darkGrayColor];
        self.topNavigationBar.translucent = NO;
    }
    else// iOS6
    {
        self.topNavigationBar.tintColor = [[FFManager sharedManager] colorNavigationBar];
    }
    // set header view
    UIView *titleHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIImageView *titleHeaderImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"titleHeader.png"]];
    CGRect frame = titleHeaderImage.frame;
    frame.origin = CGPointMake(72, 12);
    titleHeaderImage.frame = frame;
    [titleHeaderView addSubview:titleHeaderImage];
    self.topNavigationItem.titleView = titleHeaderView;
    // left button
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"إلغاء" style:UIBarButtonItemStyleDone target:self action:@selector(cancelAction)];
    self.topNavigationItem.leftBarButtonItem = leftButton;
    // right button
    rightFilterButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showPicker:)];
    self.topNavigationItem.rightBarButtonItem = rightFilterButton;
}

// Receive memory warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// Cancel action
- (void)cancelAction
{
    activeFeedObject = [[NSMutableDictionary alloc] init];
    [self performSegueWithIdentifier:@"UnwindDetailsSegue" sender:self];
}

#pragma mark -
#pragma mark Feed Control
// Download list of categories
- (void)downloadCategories
{
    FFManager *cacheManager = [FFManager sharedManager];
    PFQuery *query = [PFQuery queryWithClassName:PARSE_CATEGORY_TABLE];
    // load data in background
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error)
     {
         // result exists
         if (!error)
         {
             [categoriesList removeAllObjects]; // So clear this out.
             // add all feed objects to the array
             for (PFObject *feedObject in objects)
             {
                 // PFObject is not serializable, meaning it can't be saved to a text file. We need to make a dictionary copy of it and then use that everywhere else.
                 NSArray *keys = [[NSArray alloc] initWithObjects:PARSE_CATEGORY_COL_ID, PARSE_CATEGORY_COL_NAME, nil];
                 NSArray *objects = [[NSArray alloc] initWithObjects:[feedObject objectId], [feedObject objectForKey:PARSE_CATEGORY_COL_NAME], nil];
                 NSMutableDictionary *object = [[NSMutableDictionary alloc] initWithObjects:objects forKeys:keys];
                 // add the object
                 [categoriesList addObject:object];
             }
             // Saving an offline copy of the category
             [cacheManager saveCategoryData:categoriesList];
         }
         else // error
         {
             NSLog(@"Error: %@ %@", error, [error userInfo]);
             // No internet connection
             if (error.code == 100)
             {
             }
             // check the feed data
             if ([categoriesList count] == 0)
             {
                 NSMutableArray *savedCategory = [cacheManager cachedCategoryData];
                 if (savedCategory != nil)
                     categoriesList = [[NSMutableArray alloc] initWithArray:savedCategory];
             }
         }
         if ([categoriesList count] > 0)
            [rightFilterButton setEnabled:YES];
         else
             [rightFilterButton setEnabled:NO];
         [filterPicker reloadAllComponents];
         // download the images
         [self downloadFeed];
     }];
}

// Download list of feed
- (void)downloadFeed
{
    FFManager *cacheManager = [FFManager sharedManager];
    PFQuery *query = [PFQuery queryWithClassName:PARSE_TEMPLATE_TABLE];
    //[query setLimit:BATCH_TEMPLATE_NO];
    //[query setSkip:batchNumber];
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
                 NSArray *keys = [[NSArray alloc] initWithObjects:PARSE_TEMPLATE_COL_ID, PARSE_TEMPLATE_COL_CATEGORY, PARSE_TEMPLATE_COL_THUMB, PARSE_TEMPLATE_COL_IMAGE, PARSE_TEMPLATE_COL_SHARE, PARSE_TEMPLATE_COL_DATE, nil];
                 NSArray *objects = [[NSArray alloc] initWithObjects:[feedObject objectId], [feedObject objectForKey:PARSE_TEMPLATE_COL_CATEGORY], [feedObject objectForKey:PARSE_TEMPLATE_COL_THUMB], [feedObject objectForKey:PARSE_TEMPLATE_COL_IMAGE], [feedObject objectForKey:PARSE_TEMPLATE_COL_SHARE], [feedObject createdAt], nil];
                 NSMutableDictionary *object = [[NSMutableDictionary alloc] initWithObjects:objects forKeys:keys];
                 // add the object
                 [feedData addObject:object];
                 batchNumber = (int)[feedData count];
             }
             // Saving an offline copy of the feed
             [cacheManager saveTemplateData:feedData];
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
                 NSMutableArray *savedFeed = [cacheManager cachedTemplateData];
                 if (savedFeed != nil)
                     feedData = [[NSMutableArray alloc] initWithArray:savedFeed];
             }
             batchNumber = (int)[feedData count];
         }
         // reload data
         filteredData = [[NSMutableArray alloc] initWithArray:feedData];
        [libraryCollectionView reloadData];
        [activityLoader stopAnimating];
     }];
}

#pragma mark -
#pragma mark - UICollectionViewDataSource
// Number of sections in collection view
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView*)collectionView
{
    return 1;
}

// Number of rows
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [filteredData count];
}

// Cell for row at index path
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"libraryCollectionCell";
    FFLibraryImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.imgIndex = indexPath.row;
    // Configure the cell...
    NSMutableDictionary *feedObject = [filteredData objectAtIndex:indexPath.row];
    [cell populateCellWithContent:feedObject];
    return cell;
}

#pragma mark -
#pragma mark - UICollectionViewDelegate
// Select item
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    activeFeedObject = [filteredData objectAtIndex:[indexPath row]];
    [self performSegueWithIdentifier:@"UnwindDetailsSegue" sender:self];
}

// Deselect item
- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark –
#pragma mark – UICollectionViewDelegateFlowLayout
// Item size
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100, 100);
}

// Border size
/*- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 0, 10, 0);
}*/

#pragma mark -
#pragma mark - Navigation
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
 }

#pragma mark -
#pragma mark PickerView DataSource
// Number of component in the picker
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView*)pickerView
{
    return 1;
}

// Number of row in the picker
- (NSInteger)pickerView:(UIPickerView*)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [categoriesList count]+1;
}

// Title for picker row
- (NSString *)pickerView:(UIPickerView*)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (row == 0)
        return @"-";
    NSMutableDictionary *catObject = [categoriesList objectAtIndex:row-1];
    return [catObject objectForKey:PARSE_CATEGORY_COL_NAME];
}

// Select certain picker row
- (void)pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (row == 0)
        activeCategory = [[NSMutableDictionary alloc] init];
    else
        activeCategory = [categoriesList objectAtIndex:row-1];
}

// Picker row view
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *retval = (id)view;
    if (!retval)
    {
        retval= [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, [pickerView rowSizeForComponent:component].width, [pickerView rowSizeForComponent:component].height)];
    }
    if (row == 0)
        retval.text = @"-";
    else
    {
        NSMutableDictionary *catObject = [categoriesList objectAtIndex:row-1];
        retval.text = [catObject objectForKey:PARSE_CATEGORY_COL_NAME];
    }
    retval.textAlignment = NSTextAlignmentCenter;
    retval.font = [UIFont systemFontOfSize:22];
    return retval;
}

#pragma mark -
#pragma mark Picker View Config
// Configure picker view header
- (void)configurePickerView
{
    [filterView setHidden:YES];
    CGRect newFrame = self.filterView.frame;
    newFrame.origin.y += PICKER_HEIGHT;
    self.filterView.frame = newFrame;
    [self.filterBgImage setAlpha:0.0];
    [self.filterBgImage setHidden:YES];
    // flat mode iOS7
    if ([[FFManager sharedManager] checkUIKitIsFlatMode])
    {
        [self.filterNavigationBar performSelector:@selector(setBarTintColor:) withObject:[[FFManager sharedManager] colorNavigationBar]];
        self.filterNavigationBar.translucent = NO;
    }
    else// iOS6
    {
        self.filterNavigationBar.tintColor = [[FFManager sharedManager] colorNavigationBar];
    }
    // left button
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"إلغاء" style:UIBarButtonItemStylePlain target:self action:@selector(hidePicker:)];
    self.filterNavigationItem.leftBarButtonItem = leftButton;
    // right button
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"اختيار" style:UIBarButtonItemStyleDone target:self action:@selector(selectCategory:)];
    self.filterNavigationItem.rightBarButtonItem = rightButton;
}

// Show picker
- (IBAction)showPicker:(id)sender
{
    [libraryCollectionView setUserInteractionEnabled:NO];
    CGRect newFrame = self.filterView.frame;
    newFrame.origin.y -= PICKER_HEIGHT;
    [filterView setHidden:NO];
    [filterBgImage setHidden:NO];
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.filterView.frame = newFrame;
        [self.filterBgImage setAlpha:0.4];
    } completion:^(BOOL finished) {
    }];
}

// Hide picker
- (IBAction)hidePicker:(id)sender
{
    CGRect newFrame = self.filterView.frame;
    newFrame.origin.y += PICKER_HEIGHT;
    [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
        self.filterView.frame = newFrame;
        [self.filterBgImage setAlpha:0.0];
    } completion:^(BOOL finished) {
        [filterView setHidden:YES];
        [filterBgImage setHidden:YES];
        [libraryCollectionView setUserInteractionEnabled:YES];
    }
    ];
}

// Select category
- (void)selectCategory:(id)sender
{
    // selected category
    if ([[activeCategory allKeys] count] > 0)
    {
        NSString *selectedCat = (NSString*)[activeCategory objectForKey:PARSE_CATEGORY_COL_ID];
        filteredData = [[NSMutableArray alloc] init];
        for (int i = 0; i < [feedData count]; i++)
        {
            NSMutableDictionary *obj = (NSMutableDictionary*)[feedData objectAtIndex:i];
            NSString *objCat = (NSString*)[obj objectForKey:PARSE_TEMPLATE_COL_CATEGORY];
            if ([objCat isEqualToString:selectedCat])
            {
                [filteredData addObject:obj];
            }
        }
    }
    else
        filteredData = [[NSMutableArray alloc] initWithArray:feedData];
    [libraryCollectionView reloadData];
    [self hidePicker:sender];
}

@end
