//
//  FFEditView.h
//  Fadfed
//
//  Created by Hani Abu Shaer on 10/22/13.
//  Copyright (c) 2013 AlphaApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FFEditView : UIView
{
}

- (UIButton*)addBackground;
- (UITextView*)addTextView;
- (UISegmentedControl*)addAlignSegment:(int)index;
- (UISegmentedControl*)addFontSizeSegment:(int)index;

@end
