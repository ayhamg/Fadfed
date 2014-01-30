//
//  FFStreamDetailsController.h
//  Fadfed
//
//  Created by Hani Abu Shaer on 10/22/13.
//  Copyright (c) 2013 AlphaApps. All rights reserved.
//

#import "FFAppDelegate.h"
#import "FFManager.h"
#import "Constants.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "FFLibraryImagesController.h"
#import "FFDetailsFinalController.h"
#import "FFEditView.h"
#import "FFDragView.h"
#import "InfColorBarPicker.h"

@interface FFStreamDetailsController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    NSMutableDictionary *feedObject;
    FFActionImageUsage imageActionType;
    UIImageView *feedImage;
    UIActivityIndicatorView *activityIndicator;
    UIButton *nextButton;
    UIButton *cancelButton;
    UIButton *addTextButton;
    BOOL startEditing;
    
    UIView *finalView;
    UIImageView *waterMark;
    
    FFEditView *editTextView;
    UITextView *editTextArea;
    UISegmentedControl *alignSegment;
    UISegmentedControl *fontSizeSegment;
    
    NSMutableArray *dragViewsArray;
    NSMutableArray *renderedTextArray;
    int activeDragViewIndex;
    
    InfColorBarView* barView;
    InfColorBarPicker* barPicker;
    UIColor *selectedColor;
}

@property (nonatomic, retain) NSMutableDictionary *feedObject;
@property (nonatomic) FFActionImageUsage imageActionType;
@property (nonatomic, retain) IBOutlet UIImageView *feedImage;
@property (nonatomic, retain) IBOutlet UIButton *addTextButton;
@property (nonatomic, retain) IBOutlet UIView *finalView;
@property (nonatomic, retain) IBOutlet UIImageView *waterMark;
@property (nonatomic) IBOutlet InfColorBarView* barView;
@property (nonatomic) IBOutlet InfColorBarPicker* barPicker;

- (void)configureHeader;
- (void)setActiveFeed:(NSMutableDictionary*)activeFeed withActionType:(FFActionImageUsage)actionType;
- (IBAction)unwindDetailsSegue:(UIStoryboardSegue*)segue;
- (IBAction)addTextView:(id)sender;
- (IBAction)takeBarPickerValue:(InfColorBarPicker*)sender;

@end
