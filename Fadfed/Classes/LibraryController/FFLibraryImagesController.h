//
//  FFLibraryImagesController.h
//  Fadfed
//
//  Created by Hani Abu Shaer on 10/22/13.
//  Copyright (c) 2013 AlphaApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFAppDelegate.h"
#import "FFManager.h"
#import "FFLibraryImageCell.h"

#define PICKER_HEIGHT  206

@interface FFLibraryImagesController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate,
                                                            UIPickerViewDataSource, UIPickerViewDelegate>
{
    UINavigationBar *topNavigationBar;
    UINavigationItem *topNavigationItem;
    UICollectionView *libraryCollectionView;
    NSMutableArray *feedData;
    NSMutableArray *filteredData;
    int batchNumber;
    BOOL endOfFeed;
    NSMutableDictionary *activeFeedObject;
    NSMutableArray *categoriesList;
    UIView *filterView;
    UIPickerView *filterPicker;
    UINavigationBar *filterNavigationBar;
    UINavigationItem *filterNavigationItem;
    UIImageView *filterBgImage;
    NSMutableDictionary *activeCategory;
    UIActivityIndicatorView *activityLoader;
    UIBarButtonItem *rightFilterButton;
}

@property (nonatomic, retain) IBOutlet UINavigationBar *topNavigationBar;
@property (nonatomic, retain) IBOutlet UINavigationItem *topNavigationItem;
@property (nonatomic, retain) IBOutlet UICollectionView *libraryCollectionView;
@property (nonatomic, retain) NSMutableArray *feedData;
@property (nonatomic, retain) NSMutableDictionary *activeFeedObject;
@property (nonatomic, retain) NSMutableArray *categoriesList;
@property (nonatomic, retain) IBOutlet UIView *filterView;
@property (nonatomic, retain) IBOutlet UIPickerView *filterPicker;
@property (nonatomic, retain) IBOutlet UINavigationBar *filterNavigationBar;
@property (nonatomic, retain) IBOutlet UINavigationItem *filterNavigationItem;
@property (nonatomic, retain) IBOutlet UIImageView *filterBgImage;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activityLoader;

- (IBAction)showPicker:(id)sender;
- (IBAction)hidePicker:(id)sender;

@end
