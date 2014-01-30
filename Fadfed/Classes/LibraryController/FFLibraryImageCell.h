//
//  FFLibraryImageCell.h
//  Fadfed
//
//  Created by Hani Abu Shaer on 10/22/13.
//  Copyright (c) 2013 AlphaApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "Constants.h"
#import "FFManager.h"

@interface FFLibraryImageCell : UICollectionViewCell
{
    int imgIndex;
    UIImageView *libraryImage;
    UIActivityIndicatorView *activityIndicator;
    BOOL populated;
}

@property (nonatomic) int imgIndex;
@property(nonatomic, retain) IBOutlet UIImageView *libraryImage;
@property(nonatomic, retain) IBOutlet UIActivityIndicatorView *activityIndicator;

- (void)populateCellWithContent:(NSMutableDictionary*)data;

@end
