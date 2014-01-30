//
//  FFEditView.m
//  Fadfed
//
//  Created by Hani Abu Shaer on 10/22/13.
//  Copyright (c) 2013 AlphaApps. All rights reserved.
//

#import "FFEditView.h"

@implementation FFEditView

#pragma mark -
#pragma mark Add Actions
// Add background
- (UIButton*)addBackground
{
    // add background
    UIImageView *transparentBg = [[UIImageView alloc] init];
    [transparentBg setBackgroundColor:[UIColor whiteColor]];
    transparentBg.layer.opacity = 0.3;
    transparentBg.frame = CGRectMake(0, 0, 320, 320);
    [self addSubview:transparentBg];
    // add clear btn
    UIButton *clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    [self addSubview:clearBtn];
    return clearBtn;
}

// Add text view
- (UITextView*)addTextView
{
    // add max size button
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 10, 300, 150)];
    [textView setBackgroundColor:[UIColor whiteColor]];
    //textView.textContainerInset = UIEdgeInsetsZero;
    textView.textAlignment = NSTextAlignmentCenter;
    [textView setTextColor:[UIColor blackColor]];
    textView.layer.cornerRadius = 5;
    [self addSubview:textView];
    return textView;
}

// Add alignment segment
- (UISegmentedControl*)addAlignSegment:(int)index
{
    NSArray *itemArray = [NSArray arrayWithObjects: @"", @"", @"", nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    UIColor *borderColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
    [segmentedControl setTintColor:borderColor];
    segmentedControl.frame = CGRectMake(10, 170, 100, 24);
    [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                               NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:15]}
                                    forState:UIControlStateNormal];
    [segmentedControl setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor darkGrayColor],
                                               NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:15]}
                                    forState:UIControlStateSelected];
    // set selected index
    segmentedControl.selectedSegmentIndex = index;
    [self addSubview:segmentedControl];
    return segmentedControl;
}

// Add font size segment
- (UISegmentedControl*)addFontSizeSegment:(int)index
{
    UIImage *choice1 = [UIImage imageNamed:@"sizeChoice1.png"];
    UIImage *choice2 = [UIImage imageNamed:@"sizeChoice2.png"];
    UIImage *choice3 = [UIImage imageNamed:@"sizeChoice3.png"];
    // selectd index
    switch (index)
    {
        case 0:
        {
            choice1 = [UIImage imageNamed:@"sizeChoiceActive1.png"];
            break;
        }
        case 1:
        {
            choice2 = [UIImage imageNamed:@"sizeChoiceActive2.png"];
            break;
        }
        case 2:
        {
            choice3 = [UIImage imageNamed:@"sizeChoiceActive3.png"];
            break;
        }
        default:
            break;
    }
    choice1 = [choice1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    choice2 = [choice2 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    choice3 = [choice3 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    NSArray *itemArray = [NSArray arrayWithObjects: choice1, choice2, choice3, nil];
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:itemArray];
    UIColor *borderColor = [UIColor colorWithRed:235.0/255.0 green:235.0/255.0 blue:235.0/255.0 alpha:1.0];
    [segmentedControl setTintColor:borderColor];
    segmentedControl.frame = CGRectMake(210, 170, 100, 24);
    segmentedControl.selectedSegmentIndex = index;
    [self addSubview:segmentedControl];
    return segmentedControl;
}

@end
