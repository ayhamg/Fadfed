//
//  FFLibraryImageCell.m
//  Fadfed
//
//  Created by Hani Abu Shaer on 10/22/13.
//  Copyright (c) 2013 AlphaApps. All rights reserved.
//

#import "FFLibraryImageCell.h"

@implementation FFLibraryImageCell

@synthesize imgIndex;
@synthesize libraryImage;
@synthesize activityIndicator;

#pragma mark -
#pragma mark Cell main functions
// Init with style
- (id)init
{
    self = [super init];
    if (self) {
        populated = NO;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        [libraryImage insertSubview:activityIndicator aboveSubview:libraryImage];
    }
    return self;
}

// Forse set frame
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self setNeedsDisplay]; // force drawRect:
}

// Set content
- (void)populateCellWithContent:(NSMutableDictionary*)data
{
    // set cell photo
    NSString *photoPath = [data objectForKey:PARSE_TEMPLATE_COL_THUMB];
    [libraryImage setBackgroundColor:[[FFManager sharedManager] colorLibraryCellImage]];
    [activityIndicator startAnimating];
    [libraryImage setImageWithURL:[NSURL URLWithString:photoPath]
                  placeholderImage:nil
                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
                    {
                            [activityIndicator stopAnimating];
                    }];
    populated = YES;
}

@end
