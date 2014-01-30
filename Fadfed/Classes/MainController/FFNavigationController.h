//
//  FFNavigationController.h
//  Fadfed
//
//  Created by Hani Abu Shaer on 4/18/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FFManager.h"
#import "REMenu.h"

@class REMenu;
@interface FFNavigationController : UINavigationController
{
    REMenu *menu;
}

@property (strong, readonly, nonatomic) REMenu *menu;

- (void)toggleMenu;

@end
