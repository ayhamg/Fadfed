//
//  FFAppDelegate.h
//  Fadfed
//
//  Created by Hani Abu Shaer on 10/21/13.
//  Copyright (c) 2013 AlphaApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import <Parse/Parse.h>
#import "Flurry.h"
#import <FacebookSDK/FacebookSDK.h>

@interface FFAppDelegate : UIResponder <UIApplicationDelegate>
{
    
}

@property (strong, nonatomic) UIWindow *window;

+ (FFAppDelegate*)sharedDelegate;

@end
