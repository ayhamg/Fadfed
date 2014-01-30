//
//  FFAppDelegate.m
//  Fadfed
//
//  Created by Hani Abu Shaer on 10/21/13.
//  Copyright (c) 2013 AlphaApps. All rights reserved.
//

#import "FFAppDelegate.h"

@implementation FFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    //[[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed:252.0/255.0 green:252.0/255.0 blue:252.0/255.0 alpha:1.0]];
    // ****************************************************************************
    // Uncomment and fill in with your Parse credentials:
    [Parse setApplicationId:PARSE_APP_ID clientKey:PARSE_CLIENT_ID];
    //
    // If you are using Facebook, uncomment and add your FacebookAppID to your bundle's plist as
    // described here: https://developers.facebook.com/docs/getting-started/facebook-sdk-for-ios/
    // [PFFacebookUtils initializeFacebook];
    // ****************************************************************************
    [PFUser enableAutomaticUser];
    
    PFACL *defaultACL = [PFACL ACL];
    
    // If you would like all objects to be private by default, remove this line.
    [defaultACL setPublicReadAccess:YES];
    
    [PFACL setDefaultACL:defaultACL withAccessForCurrentUser:YES];
    [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeBadge|
     UIRemoteNotificationTypeAlert|
     UIRemoteNotificationTypeSound];
    return YES;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken
{
    [PFPush storeDeviceToken:newDeviceToken];
    //[PFPush subscribeToChannelInBackground:@"" target:self selector:@selector(subscribeFinished:error:)];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    if ( error.code == 3010 )
    {
        NSLog(@"Push notifications are not supported in the iOS Simulator.");
    }
    else
    {
        // Show some alert or otherwise handle the failure to register.
        NSLog(@"application:didFailToRegisterForRemoteNotificationsWithError: %@", error);
	}
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    [PFPush handlePush:userInfo];
    
    if ( application.applicationState != UIApplicationStateActive )
    {
        //[PFAnalytics trackAppOpenedWithRemoteNotificationPayload:userInfo]; // Not available in Parse 1.1.32.
    }
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark -
#pragma mark Delegate static functions
// Return shared delegate.
+ (FFAppDelegate *)sharedDelegate
{
    return (FFAppDelegate *)[[UIApplication sharedApplication] delegate];
}

// Handle open url
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    //only for parse
    return [PFFacebookUtils handleOpenURL:url];
}

// Open external url application
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    
    //none parese function
    return [[FBSession activeSession] handleOpenURL:url];
    //parse function
    //return [[PF_FBSession activeSession] handleOpenURL:url];
}

@end
