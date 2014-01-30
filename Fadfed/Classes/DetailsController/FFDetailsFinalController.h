//
//  FFDetailsFinalController.h
//  Fadfed
//
//  Created by Hani Abu Shaer on 10/22/13.
//  Copyright (c) 2013 AlphaApps. All rights reserved.
//

#import "FFAppDelegate.h"
#import "FFManager.h"
#import "Constants.h"

@interface FFDetailsFinalController : UIViewController
{
    UIImageView *feedImageView;
    UIImage *feedImage;
}

@property (nonatomic, retain) IBOutlet UIImageView *feedImageView;
@property (nonatomic, retain) UIImage *feedImage;

- (IBAction)shareOnFacebook:(id)sender;
- (IBAction)shareOnTwitter:(id)sender;

@end
