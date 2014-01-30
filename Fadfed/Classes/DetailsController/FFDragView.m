//
//  FFDragView.m
//  Fadfed
//
//  Created by Hani Abu Shaer on 10/22/13.
//  Copyright (c) 2013 AlphaApps. All rights reserved.
//

#import "FFDragView.h"

@implementation FFDragView

@synthesize selectedAlignment;
@synthesize selectedFontSize;

#pragma mark -
#pragma mark Touch Delegate
// Touches began
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint p = [[touches anyObject] locationInView:self.superview];
    touchStart.x = -self.center.x + p.x;
    touchStart.y = -self.center.y + p.y;
    [super touchesBegan:touches withEvent:event];
}

// Change position by touch
- (void)touchesMoved:(NSSet *)set withEvent:(UIEvent *)event
{
    CGPoint p = [[set anyObject] locationInView:self.superview];
    self.center = CGPointMake(p.x - touchStart.x, p.y - touchStart.y);
    [super touchesMoved:set withEvent:event];
}

#pragma mark -
#pragma mark Add Actions
// Add custom text
- (UITextView*)addCustomText:(UITextView*)editTextArea withColor:(UIColor*)selectedColor
{
    CGRect frame = CGRectMake(0, 0, 300, 35);
    UITextView *tempArea = [[UITextView alloc] initWithFrame:frame];
    // add stroke to the text
    NSMutableAttributedString* attString = [[NSMutableAttributedString alloc] initWithString:editTextArea.text];
    NSRange range = NSMakeRange(0, [attString length]);
    [attString addAttribute:NSFontAttributeName value:editTextArea.font range:range];
    [attString addAttribute:NSForegroundColorAttributeName value:selectedColor range:range];
    [attString addAttribute:NSStrokeWidthAttributeName value:[NSNumber numberWithFloat:EFFECT_STROKE_WIDTH] range:range];
    [attString addAttribute:NSStrokeColorAttributeName value:[[FFManager sharedManager] strokeColor] range:range];
    tempArea.attributedText = attString;
    tempArea.textAlignment = editTextArea.textAlignment;
    tempArea.backgroundColor = [UIColor clearColor];
    //tempArea.textContainerInset = UIEdgeInsetsZero;
    [tempArea setUserInteractionEnabled:NO];
    // add text area to the final view
    CGSize calculatedTextSize = [editTextArea sizeThatFits:CGSizeMake(editTextArea.frame.size.width, FLT_MAX)];
    frame.size.height = calculatedTextSize.height;
    tempArea.frame = frame;
    return tempArea;
}

// Adjust size
- (void)adjustTextSize:(UITextView*)editTextArea withDestination:(UITextView*)renderedTextView withColor:(UIColor*)selectedColor
{
    // add stroke to the text
    NSMutableAttributedString* attString = [[NSMutableAttributedString alloc] initWithString:editTextArea.text];
    NSRange range = NSMakeRange(0, [attString length]);
    [attString addAttribute:NSFontAttributeName value:editTextArea.font range:range];
    [attString addAttribute:NSForegroundColorAttributeName value:selectedColor range:range];
    [attString addAttribute:NSStrokeWidthAttributeName value:[NSNumber numberWithFloat:EFFECT_STROKE_WIDTH] range:range];
    [attString addAttribute:NSStrokeColorAttributeName value:[[FFManager sharedManager] strokeColor] range:range];
    renderedTextView.attributedText = attString;
    renderedTextView.textAlignment = editTextArea.textAlignment;
    renderedTextView.backgroundColor = [UIColor clearColor];
    //tempArea.textContainerInset = UIEdgeInsetsZero;
    [renderedTextView setUserInteractionEnabled:NO];
    // add text area to the final view
    CGSize calculatedTextSize = [editTextArea sizeThatFits:CGSizeMake(editTextArea.frame.size.width, FLT_MAX)];
    CGRect frame = renderedTextView.frame;
    frame.size.height = calculatedTextSize.height;
    renderedTextView.frame = frame;
}

// Adjust text color
- (void)adjustTextColor:(UITextView*)renderedTextView withColor:(UIColor*)selectedColor
{
    NSTextAlignment alignment = renderedTextView.textAlignment;
    UIFont *currentFont;
    if (selectedFontSize == 0)
        currentFont = [UIFont boldSystemFontOfSize:FONT_SIZE_SMALL];
    else if (selectedFontSize == 1)
        currentFont =  [UIFont boldSystemFontOfSize:FONT_SIZE_MEDIUM];
    else
        currentFont = [UIFont boldSystemFontOfSize:FONT_SIZE_LARGE];
    // add stroke to the text
    NSMutableAttributedString* attString = [[NSMutableAttributedString alloc] initWithString:renderedTextView.text];
    NSRange range = NSMakeRange(0, [attString length]);
    [attString addAttribute:NSFontAttributeName value:currentFont range:range];
    [attString addAttribute:NSForegroundColorAttributeName value:selectedColor range:range];
    [attString addAttribute:NSStrokeWidthAttributeName value:[NSNumber numberWithFloat:EFFECT_STROKE_WIDTH] range:range];
    [attString addAttribute:NSStrokeColorAttributeName value:[[FFManager sharedManager] strokeColor] range:range];
    renderedTextView.attributedText = attString;
    renderedTextView.textAlignment = alignment;
    renderedTextView.font = currentFont;
}

@end
