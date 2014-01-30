//
//  FFDetailsFinalController.m
//  Fadfed
//
//  Created by Hani Abu Shaer on 10/22/13.
//  Copyright (c) 2013 AlphaApps. All rights reserved.
//

#import "FFDetailsFinalController.h"

@implementation FFDetailsFinalController

@synthesize feedImageView;
@synthesize feedImage;

#pragma mark -
#pragma mark View Controller
// View did load
- (void)viewDidLoad
{
    // configure header
    [self configureHeader];
    feedImageView.image = feedImage;
    [super viewDidLoad];
}

// Configure header
- (void)configureHeader
{
    // flat mode iOS7
    if ([[FFManager sharedManager] checkUIKitIsFlatMode])
    {
        [self.navigationController.navigationBar performSelector:@selector(setBarTintColor:) withObject:[[FFManager sharedManager] colorNavigationBar]];
        self.navigationController.navigationBar.tintColor = [UIColor darkGrayColor];
        self.navigationController.navigationBar.translucent = NO;
    }
    else
    {
        self.navigationController.navigationBar.tintColor = [[FFManager sharedManager] colorNavigationBar];
    }
    // set header view
    UIView *titleHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    UIImageView *titleHeaderImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"titleHeader.png"]];
    CGRect frame = titleHeaderImage.frame;
    frame.origin = CGPointMake(72, 12);
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
    UIButton *rootButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 44)];
    [rootButton setTitle:@"" forState:UIControlStateNormal];
    [rootButton.titleLabel setFont:[UIFont fontWithName:@"FontAwesome" size:20]];
    [rootButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rootButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateSelected];
    [rootButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateHighlighted];
    // click the button fire toggleMenu from navigation controller
    [rootButton addTarget:self action:@selector(backToHomeAction) forControlEvents:UIControlEventTouchUpInside];
    [rightButtonView addSubview:rootButton];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    NSArray *actionButtonItems = @[negativeSeperator, addItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
}

// Cancel action
- (void)cancelAction
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// Back to home action
- (void)backToHomeAction
{
    NSArray *viewsArray = [self.navigationController viewControllers];
    UIViewController *chosenView = [viewsArray objectAtIndex:0];
    [self.navigationController popToViewController:chosenView animated:YES];
}

// Write image to library
- (void)writeImageToLibrary:(UIImage*)image
{
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
}

// Receive memory warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Sharing Actions
// Share on facebook
- (IBAction)shareOnFacebook:(id)sender
{
    [[FFManager sharedManager] facebookPostStandard:@"" andPhoto:feedImage link:nil controller:self];
}

// Share on twitter
- (IBAction)shareOnTwitter:(id)sender
{
    [[FFManager sharedManager] twitterShareStandrad:@"" photo:feedImage link:nil controller:self];
}

#pragma mark -
#pragma mark - Navigation
 // In a story board-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
     // Get the new view controller using [segue destinationViewController].
     // Pass the selected object to the new view controller.
     /*if ([[segue identifier] isEqualToString:@"ActionSegue"])
     {
         DrillDownDetailController *dvController = [[segue destinationViewController] visibleViewController];
         //DrillDownDetailController *dvController = [[DrillDownDetailController alloc] initWithNibName:nil bundle:[NSBundle mainBundle]];
         [dvController setItemName:(NSString *)sender];
         [self.navigationController pushViewController:dvController animated:YES];
     }*/
 }

@end
