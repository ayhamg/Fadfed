//
//  FFMainStreamController.h
//  Fadfed
//
//  Created by Hani Abu Shaer on 10/22/13.
//  Copyright (c) 2013 AlphaApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFMainStreamCell.h"
#import "FFAppDelegate.h"
#import "FFManager.h"
#import "REMenu.h"
#import "FFNavigationController.h"
#import "IBActionSheet.h"
#import "FFStreamDetailsController.h"

@interface FFMainStreamController : UIViewController <UITableViewDelegate, UITableViewDataSource, IBActionSheetDelegate>
{
    UITableView *streamTableView;
    UIRefreshControl *tableRefreshControl;
    NSMutableArray *feedData;
    int batchNumber;
    BOOL endOfFeed;
    NSMutableDictionary *activeFeedObject;
    FFActionImageUsage actionType;
    UIButton *addButton;
    BOOL menuClicked;
    BOOL loadingInProgress;
}

@property (nonatomic, retain) IBOutlet UITableView *streamTableView;
@property (nonatomic, retain) NSMutableArray *feedData;
@property (nonatomic) FFActionImageUsage actionType;
@property (nonatomic, retain) UIButton *addButton;

- (void)resetMenuButton;

@end
