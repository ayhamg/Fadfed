//
//  FFMainStreamCell.h
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

@interface FFMainStreamCell : UITableViewCell
{
    int rowNumber;
    UIImageView *streamImage;
    UILabel *streamTitle;
    UILabel *streamDate;
    UIButton *streamUseBtn;
    UIButton *streamShareBtn;
}

@property (nonatomic) int rowNumber;
@property(nonatomic, retain) IBOutlet UIImageView *streamImage;
@property(nonatomic, retain) IBOutlet UILabel *streamTitle;
@property(nonatomic, retain) IBOutlet UILabel *streamDate;
@property(nonatomic, retain) IBOutlet UIButton *streamUseBtn;
@property(nonatomic, retain) IBOutlet UIButton *streamShareBtn;

- (void)populateCellWithContent:(NSMutableDictionary*)data;

@end
