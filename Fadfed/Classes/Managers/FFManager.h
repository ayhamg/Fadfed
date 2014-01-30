//
//  FFManager.h
//  Fadfed
//
//  Created by Hani Abu Shaer on 7/29/13.
//  Copyright (c) 2013 AlphaApps. All rights reserved.
//

#include "Constants.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <Social/Social.h>

@interface FFManager : NSObject <PF_FBDialogDelegate>
{    
}

+ (FFManager*)sharedManager;
- (BOOL)checkUIKitIsFlatMode;
// Interface Functions
- (UIColor*)colorRightNavButton;
- (UIColor*)colorCellImage;
- (UIColor*)colorLibraryCellImage;
- (UIColor*)colorNavigationBar;
- (UIColor*)colorMenuItem;
- (UIColor*)strokeColor;
// Cache Functions
- (NSMutableArray*)cachedFeedData;
- (void)saveFeedData:(NSMutableArray*)data;
- (NSMutableArray*)cachedTemplateData;
- (void)saveTemplateData:(NSMutableArray*)data;
- (NSMutableArray*)cachedCategoryData;
- (void)saveCategoryData:(NSMutableArray*)data;
// Sharing options
- (void)facebookPostParse:(NSString*)title andPhoto:(NSURL*)photoURL;
- (void)facebookPostStandard:(NSString*)title andPhoto:(UIImage*)image  link:(NSURL*)link controller:(UIViewController*)controller;
- (void)facebookShareParse:(NSString*)titile caption:(NSString*)caption description:(NSString*)description link:(NSString*)link picture:(NSString*)picture;
- (void)facebookShareStandard:(NSString*)name caption:(NSString*)caption description:(NSString*)description link:(NSString*)link picture:(NSString*)picture;
- (void)twitterShareStandrad:(NSString *)titile photo:(UIImage *)image  link:(NSURL*)link controller:(UIViewController*)controller;

@end
