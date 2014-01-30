//
//  FFDragView.h
//  Fadfed
//
//  Created by Hani Abu Shaer on 10/22/13.
//  Copyright (c) 2013 AlphaApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFManager.h"

@interface FFDragView : UIView
{
    CGPoint touchStart;
    CGPoint touchEnd;
    int selectedAlignment;
    int selectedFontSize;
}

@property(nonatomic) int selectedAlignment;
@property(nonatomic) int selectedFontSize;

- (UITextView*)addCustomText:(UITextView*)editTextArea withColor:(UIColor*)selectedColor;
- (void)adjustTextSize:(UITextView*)editTextArea withDestination:(UITextView*)renderedTextView withColor:(UIColor*)selectedColor;
- (void)adjustTextColor:(UITextView*)renderedTextView withColor:(UIColor*)selectedColor;

@end
