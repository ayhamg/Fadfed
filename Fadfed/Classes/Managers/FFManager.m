//
//  FFManager.m
//  Fadfed
//
//  Created by Hani Abu Shaer on 7/29/13.
//  Copyright (c) 2013 AlphaApps. All rights reserved.
//

#import "FFManager.h"

@implementation FFManager

static FFManager *sharedManager = nil;

#pragma mark -
#pragma mark Singilton Init Methods
// init shared Cache singleton.
+ (FFManager*)sharedManager
{
	@synchronized(self)
    {
		if ( !sharedManager )
        {
            sharedManager = [[FFManager alloc] init];
        }
	}
	return sharedManager;
}

// Dealloc shared API singleton.
+ (id)alloc
{
	@synchronized( self )
    {
		NSAssert(sharedManager == nil, @"Attempted to allocate a second instance of a singleton.");
		return [super alloc];
	}
    
	return nil;
}

// Init the manager
- (id)init
{
	if ( self = [super init] )
    {
        
	}
    
	return self;
}

#pragma mark -
#pragma mark Interface Functions
// Check if flat mode iOS7
- (BOOL)checkUIKitIsFlatMode
{
    static BOOL isUIKitFlatMode = NO;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (floor(NSFoundationVersionNumber) > 993.0) {
            // If your app is running in legacy mode, tintColor will be nil - else it must be set to some color.
            if (UIApplication.sharedApplication.keyWindow &&
                [UIApplication.sharedApplication.delegate respondsToSelector:@selector(window)]) {
                isUIKitFlatMode = [UIApplication.sharedApplication.delegate.window performSelector:@selector(tintColor)] != nil;
            } else {
                // Possible that we're called early on (e.g. when used in a Storyboard). Adapt and use a temporary window.
                isUIKitFlatMode = [[UIWindow new] performSelector:@selector(tintColor)] != nil;
            }
        }
    });
    return isUIKitFlatMode;
}

#pragma mark -
#pragma mark Interface Functions
// Color for right nav button
- (UIColor*)colorRightNavButton
{
    return [UIColor colorWithRed:250.0/255.0 green:82.0/255.0 blue:94.0/255.0 alpha:1.0];
}

// Color for cell image
- (UIColor*)colorCellImage
{
    return [UIColor whiteColor];//[UIColor colorWithRed:238.0/255.0 green:238.0/255.0 blue:238.0/255.0 alpha:1.0];
}

// Color for library cell image
- (UIColor*)colorLibraryCellImage
{
    return [UIColor lightGrayColor];
}

// Color for cell image
- (UIColor*)colorNavigationBar
{
    return [UIColor colorWithRed:252.0/255.0 green:252.0/255.0 blue:252.0/255.0 alpha:1.0];
}

// Color for cell image
- (UIColor*)colorMenuItem
{
    return [UIColor colorWithRed:227.0/255.0 green:227.0/255.0 blue:220.0/255.0 alpha:1.0];
}

// Stroke color
- (UIColor*)strokeColor
{
    return [UIColor blackColor];
}

#pragma mark -
#pragma mark Caching Data
// Save feed data
- (void)saveFeedData:(NSMutableArray*)data
{
    // Saving an offline copy of the feed.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    NSString *folderPath = [libraryDirectory stringByAppendingPathComponent:CACH_FEED_FOLDER];
    NSString *filePath = [folderPath stringByAppendingPathComponent:CACH_FEED_FILE];
    BOOL isDir;
    // folder not exist
    if ( ![fileManager fileExistsAtPath:folderPath isDirectory:&isDir] )
    {
        NSError *dirWriteError = nil;
        
        if ( ![fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:&dirWriteError] )
        {
            NSLog(@"Error: failed to create folder!");
        }
    }
    // wrote to disk
    if ( [NSKeyedArchiver archiveRootObject:data toFile:filePath] )
    {
        NSLog(@"Successfully wrote feed to disk!");
    }
    else // failed to write
    {
        NSLog(@"Failed to write feed to disk!");
    }
}

// Return the cached feed data
- (NSMutableArray *)cachedFeedData
{
    // return the data from saved file
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    NSString *pathString = [NSString stringWithFormat:@"%@/%@", CACH_FEED_FOLDER, CACH_FEED_FILE];
    NSString *filePath =  [libraryDirectory stringByAppendingPathComponent:pathString];
    return [[NSKeyedUnarchiver unarchiveObjectWithFile:filePath] mutableCopy];
}

// Save template data
- (void)saveTemplateData:(NSMutableArray*)data
{
    // Saving an offline copy of the feed.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    NSString *folderPath = [libraryDirectory stringByAppendingPathComponent:CACH_TEMPLATE_FOLDER];
    NSString *filePath = [folderPath stringByAppendingPathComponent:CACH_TEMPLATE_FILE];
    BOOL isDir;
    // folder not exist
    if ( ![fileManager fileExistsAtPath:folderPath isDirectory:&isDir] )
    {
        NSError *dirWriteError = nil;
        
        if ( ![fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:&dirWriteError] )
        {
            NSLog(@"Error: failed to create folder!");
        }
    }
    // wrote to disk
    if ( [NSKeyedArchiver archiveRootObject:data toFile:filePath] )
    {
        NSLog(@"Successfully wrote feed to disk!");
    }
    else // failed to write
    {
        NSLog(@"Failed to write feed to disk!");
    }
}

// Return the cached template data
- (NSMutableArray *)cachedTemplateData
{
    // return the data from saved file
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    NSString *pathString = [NSString stringWithFormat:@"%@/%@", CACH_TEMPLATE_FOLDER, CACH_TEMPLATE_FILE];
    NSString *filePath =  [libraryDirectory stringByAppendingPathComponent:pathString];
    return [[NSKeyedUnarchiver unarchiveObjectWithFile:filePath] mutableCopy];
}

// Save category data
- (void)saveCategoryData:(NSMutableArray*)data
{
    // Saving an offline copy of the feed.
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    NSString *folderPath = [libraryDirectory stringByAppendingPathComponent:CACH_CATEGORY_FOLDER];
    NSString *filePath = [folderPath stringByAppendingPathComponent:CACH_CATEGORY_FILE];
    BOOL isDir;
    // folder not exist
    if ( ![fileManager fileExistsAtPath:folderPath isDirectory:&isDir] )
    {
        NSError *dirWriteError = nil;
        
        if ( ![fileManager createDirectoryAtPath:folderPath withIntermediateDirectories:YES attributes:nil error:&dirWriteError] )
        {
            NSLog(@"Error: failed to create folder!");
        }
    }
    // wrote to disk
    if ( [NSKeyedArchiver archiveRootObject:data toFile:filePath] )
    {
        NSLog(@"Successfully wrote feed to disk!");
    }
    else // failed to write
    {
        NSLog(@"Failed to write feed to disk!");
    }
}

// Return the cached category data
- (NSMutableArray *)cachedCategoryData
{
    // return the data from saved file
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *libraryDirectory = [paths objectAtIndex:0];
    NSString *pathString = [NSString stringWithFormat:@"%@/%@", CACH_CATEGORY_FOLDER, CACH_CATEGORY_FILE];
    NSString *filePath =  [libraryDirectory stringByAppendingPathComponent:pathString];
    return [[NSKeyedUnarchiver unarchiveObjectWithFile:filePath] mutableCopy];
}

#pragma mark -
#pragma mark Social Sharing
// Facebook post in background with Parse
- (void)facebookPostParse:(NSString*)title andPhoto:(NSURL*)photoURL
{
    NSData* imgData = [NSData dataWithContentsOfURL:photoURL];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if( imgData )
    {
        UIImage* image  = [[UIImage alloc ] initWithData:imgData];
        [params setObject:image forKey:@"picture"];
    }
    [params setObject:title forKey:@"name"];
    
    NSArray *permissions = [NSArray arrayWithObjects:@"publish_actions", nil];
    
    [PF_FBSession openActiveSessionWithPublishPermissions:permissions defaultAudience:PF_FBSessionDefaultAudienceFriends allowLoginUI:YES completionHandler:^(PF_FBSession *session, PF_FBSessionState state, NSError *error)
     {
         if (state == PF_FBSessionStateOpen)
         {
             [PF_FBRequestConnection startWithGraphPath:@"me/photos" parameters:params HTTPMethod:@"POST" completionHandler:^(PF_FBRequestConnection *connection, id result, NSError *error)
              {
                  if (!error)
                  {
                      NSLog(@"Sucess");
                  }
                  else
                  {
                      NSLog(@"Failed");
                  }
              }];
             
         }
         else if (state == PF_FBSessionStateClosed || state == PF_FBSessionStateClosedLoginFailed)
         {
             
         }
     }];
}

// Facebook post in background
- (void)facebookPostStandard:(NSString*)title andPhoto:(UIImage*)image link:(NSURL*)link controller:(UIViewController*)controller
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        SLComposeViewController *facebookSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        [facebookSheet setInitialText:title];
        
        [facebookSheet addImage:image];
        //[facebookSheet addURL:[NSURL URLWithString:@"www.googl.com"]];
        if(link)
            [facebookSheet addURL:link];
        [controller presentViewController:facebookSheet animated:YES completion:nil];
        [facebookSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    //[self showAlert:@"تم إلغاء عملية النشر"];
                    break;
                case SLComposeViewControllerResultDone:
                    [self showAlert:@"تمت عملية النشر بنجاح"];
                    break;
                    
                default:
                    break;
            }
        }];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"تنبيه!"
                                  message:@"لا يمكنك النشر، تأكد من الاتصال بالانترنت وأنك تملك حساب مجهز واحد على الاقل"
                                  delegate:self
                                  cancelButtonTitle:@"موافق"
                                  otherButtonTitles:nil];
        [alertView show];
    }
    
    /*NSMutableDictionary *params = [NSMutableDictionary dictionary];
    //if( imgData )
    //{
      //  UIImage* image  = [[UIImage alloc ] initWithData:imgData];
        [params setObject:image forKey:@"picture"];
    //}
    [params setObject:title forKey:@"name"];
    
    NSArray *permissions = [NSArray arrayWithObjects:@"publish_actions", nil];
    
    [FBSession openActiveSessionWithPublishPermissions:permissions defaultAudience:FBSessionDefaultAudienceFriends allowLoginUI:YES
                                     completionHandler:^(FBSession *session, FBSessionState state, NSError *error)
     {
         if (state == FBSessionStateOpen)
         {
             [FBRequestConnection startWithGraphPath:@"me/photos" parameters:params HTTPMethod:@"POST" completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
              {
                  if (!error)
                  {
                      [self showAlert:@"تمت عملية النشر بنجاح"];
                  }
                  else
                  {
                      [self showAlert:@"فشلت العملية الرجاء التأكد من الاتصال بالانترنيت"];
                  }
              }];
         }
         else if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed)
         {
             
         }
     }];*/
}

// Facbook sharing
- (void)facebookShareStandard:(NSString*)name caption:(NSString*)caption description:(NSString*)description link:(NSString*)link picture:(NSString*)picture
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"fb://"]];
    
    if([[UIApplication sharedApplication] canOpenURL:url])
    {
        [self facebookShareDialog:name caption:caption description:description link:link picture:picture];
    }
    else
    {
        [self facebookShareWeb:name caption:caption description:description link:link picture:picture];
    }
}

// Facebook share with FB applicaiton
- (void)facebookShareDialog:(NSString*)name caption:(NSString*)caption description:(NSString*)description link:(NSString*)link picture:(NSString*)picture
{
    // Set up the dialog parameters
    FBShareDialogParams *params = [[FBShareDialogParams alloc] init];
    params.link = [NSURL URLWithString:link];
    params.picture = [NSURL URLWithString:picture];
    params.name = name;
    params.caption = caption;
    params.description = description;
    
    FBAppCall *call = [FBDialogs presentShareDialogWithParams:params
                                                  clientState:nil
                                                      handler:
                       ^(FBAppCall *call, NSDictionary *results, NSError *error) {
                           if(error) {
                               // If there's an error show the relevant message
                               //[self showAlert:[self checkErrorMessage:error]];
                           } else {
                               // Check if cancel info is returned and log the event
                               if (results[@"completionGesture"] &&
                                   [results[@"completionGesture"] isEqualToString:@"cancel"]) {
                                   NSLog(@"User canceled story publishing.");
                               } else {
                                   // If the post went through show a success message
                                   //[self showAlert:[self checkPostId:results]];
                               }
                           }
                       }];
    if (!call)
    {
        //[self showAlert:@"Share Dialog not supported. Make sure you're using the latest Facebook app."];
        [self facebookShareWeb:name caption:caption description:description link:link picture:picture];
    }
}

// Facebook share with parse framework
- (void)facebookShareParse:(NSString*)titile caption:(NSString*)caption description:(NSString*)description link:(NSString*)link picture:(NSString*)picture
{
    NSArray *permissions = [NSArray arrayWithObjects:@"publish_actions", nil];
    
    
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   titile, @"name",
                                   caption, @"caption",
                                   description, @"description",
                                   link, @"link",
                                   picture, @"picture",
                                   nil];
    
    [PF_FBSession openActiveSessionWithPublishPermissions:permissions defaultAudience:PF_FBSessionDefaultAudienceFriends allowLoginUI:NO completionHandler:^(PF_FBSession *session, PF_FBSessionState state, NSError *error)
     {
         
         if (state == PF_FBSessionStateOpen)
         {
             PF_Facebook *fb = [[PF_Facebook alloc]initWithAppId:session.appID andDelegate:nil];
             [fb dialog:@"feed" andParams:params andDelegate:self];
         }
     }];
}

// Facebook with web
- (void)facebookShareWeb:(NSString*)name caption:(NSString*)caption description:(NSString*)description link:(NSString*)link picture:(NSString*)picture
{
    // Put together the dialog parameters
    NSMutableDictionary *params =
    /*[NSMutableDictionary dictionaryWithObjectsAndKeys:
     @"Facebook SDK for iOS", @"name",
     @"Build great social apps and get more installs.", @"caption",
     @"The Facebook SDK for iOS makes it easier and faster to develop Facebook integrated iOS apps.", @"description",
     @"https://developers.facebook.com/ios", @"link",
     @"https://raw.github.com/fbsamples/ios-3.x-howtos/master/Images/iossdk_logo.png", @"picture",
     nil];*/
    [NSMutableDictionary dictionaryWithObjectsAndKeys:
     name, @"name",
     caption, @"caption",
     description, @"description",
     link, @"link",
     picture, @"picture",
     nil];
    
    // Invoke the dialog
    [FBWebDialogs presentFeedDialogModallyWithSession:nil
                                           parameters:params
                                              handler:
     ^(FBWebDialogResult result, NSURL *resultURL, NSError *error) {
         if (error) {
             // Error launching the dialog or publishing a story.
             NSLog(@"Error publishing story.");
         } else {
             if (result == FBWebDialogResultDialogNotCompleted) {
                 // User clicked the "x" icon
                 NSLog(@"User canceled story publishing.");
             } else {
                 // Handle the publish feed callback
                 NSDictionary *urlParams = [self parseURLParams:[resultURL query]];
                 if (![urlParams valueForKey:@"post_id"]) {
                     // User clicked the Cancel button
                     NSLog(@"User canceled story publishing.");
                 } else {
                     // User clicked the Share button
                     NSString *msg = [NSString stringWithFormat:
                                      @"Posted story, id: %@",
                                      [urlParams valueForKey:@"post_id"]];
                     NSLog(@"%@", msg);
                     // Show the result in an alert
                     [[[UIAlertView alloc] initWithTitle:@"المشاركة"
                                                 message:msg
                                                delegate:nil
                                       cancelButtonTitle:@"موافق"
                                       otherButtonTitles:nil]
                      show];
                 }
             }
         }
     }];
}

/*
 * Helper method to check for the posted ID
 */
- (NSString *) checkPostId:(NSDictionary *)results {
    NSString *message = @"تم عملية النشر بنجاح";
    if (results[@"postId"]) {
        message = [NSString stringWithFormat:@"Posted story, id: %@", results[@"postId"]];
    }
    return message;
}

/**
 * A function for parsing URL parameters.
 */
- (NSDictionary*)parseURLParams:(NSString *)query {
    NSArray *pairs = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *val =
        [kv[1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        params[kv[0]] = val;
    }
    return params;
}

/*
 * Helper method to show an alert
 */
- (void)showAlert:(NSString *) alertMsg {
    if (![alertMsg isEqualToString:@""]) {
        [[[UIAlertView alloc] initWithTitle:@"المشاركة"
                                    message:alertMsg
                                   delegate:nil
                          cancelButtonTitle:@"موافق"
                          otherButtonTitles:nil] show];
    }
}

// Twitter standard share
- (void)twitterShareStandrad:(NSString *)title photo:(UIImage *)image  link:(NSURL*)link controller:(UIViewController*)controller
{
    if ([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])
    {
        SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
        [tweetSheet setInitialText:title];
        [tweetSheet addImage:image];
        if(link)
            [tweetSheet addURL:link];
        [controller presentViewController:tweetSheet animated:YES completion:nil];
        
        [tweetSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    //[self showAlert:@"تم إالغاء التغريدة"];
                    break;
                case SLComposeViewControllerResultDone:
                    [self showAlert:@"تمت عملية نشر التغريدة بنجاح"];
                    break;
                    
                default:
                    break;
            }
        }];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]
                                  initWithTitle:@"تنبيه!"
                                  message:@"لا تستطيع ارسال تغريدة تأكد من الاتصال بالانترنيت وأنك تملك حساب مجهز واحد على الاقل"
                                  delegate:self
                                  cancelButtonTitle:@"موافق"
                                  otherButtonTitles:nil];
        [alertView show];
    }
}

@end
