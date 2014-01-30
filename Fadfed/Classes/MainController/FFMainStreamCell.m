//
//  FFMainStreamCell.m
//  Fadfed
//
//  Created by Hani Abu Shaer on 10/22/13.
//  Copyright (c) 2013 AlphaApps. All rights reserved.
//

#import "FFMainStreamCell.h"

@implementation FFMainStreamCell

@synthesize rowNumber;
@synthesize streamImage;
@synthesize streamTitle;
@synthesize streamUseBtn;
@synthesize streamShareBtn;
@synthesize streamDate;

#pragma mark -
#pragma mark Cell main functions
// Init with style
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

// Set selected style
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

// Set content
- (void)populateCellWithContent:(NSMutableDictionary*)data
{
    // set feed date
    NSDate *photoDate = (NSDate*)[data objectForKey:PARSE_FEED_COL_DATE];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:FEED_DATE_FORMATE];
    streamDate.text = [formatter stringFromDate:photoDate];
    // set title
    streamTitle.text = (NSString*)[data objectForKey:PARSE_FEED_COL_TITLE];
    /*[streamShareBtn.titleLabel setFont:[UIFont fontWithName:@"FontAwesome" size:14]];
    [streamUseBtn.titleLabel setFont:[UIFont fontWithName:@"FontAwesome" size:14]];
    [streamShareBtn setTitle:@"شارك " forState:UIControlStateNormal];
    [streamUseBtn setTitle:@"استخدم " forState:UIControlStateNormal];*/
    streamShareBtn.tag = rowNumber;
    streamUseBtn.tag = rowNumber;
    // set cell photo
    NSString *photoPath = [data objectForKey:PARSE_FEED_COL_IMAGE];
    __block UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame = CGRectMake(142, 142, 36, 36);
    activityIndicator.hidesWhenStopped = YES;
    [activityIndicator startAnimating];
    [streamImage addSubview:activityIndicator];
    [streamImage setBackgroundColor:[[FFManager sharedManager] colorCellImage]];
    [streamImage setImageWithURL:[NSURL URLWithString:photoPath]
                  placeholderImage:nil
                  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
                    {
                        [activityIndicator removeFromSuperview];
                    }];
}

@end
