//
//  FFNavigationController.m
//  Fadfed
//
//  Created by Hani Abu Shaer on 4/18/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//
//  Sample icons from http://icons8.com/download-free-icons-for-ios-tab-bar
//

#import "FFNavigationController.h"
#import "FFMainStreamController.h"

@implementation FFNavigationController

@synthesize menu;

#pragma mark -
#pragma mark View Controller
// View did load
- (void)viewDidLoad
{
    [super viewDidLoad];
    // flat mode iOS7
    if ([[FFManager sharedManager] checkUIKitIsFlatMode])
    {
        [self.navigationBar performSelector:@selector(setBarTintColor:) withObject:[[FFManager sharedManager] colorNavigationBar]];
        self.navigationBar.tintColor = [UIColor whiteColor];
        self.navigationBar.translucent = NO;        
    }
    else
    {
        self.navigationBar.tintColor = [[FFManager sharedManager] colorNavigationBar];
    }
    // add the items
    FFMainStreamController *mainStream = (FFMainStreamController*)[self.childViewControllers objectAtIndex:0];
    REMenuItem *cameraItem = [[REMenuItem alloc] initWithTitle:@"التقط صورة جديدة"
                                                            subtitle:@""
                                                            image:[UIImage imageNamed:@"cameraIcon"]
                                                            highlightedImage:nil
                                                            action:^(REMenuItem *item) {
                                                                NSLog(@"Item: %@", item);
                                                                // camer action
                                                                mainStream.actionType = FFActionImageCamera;
                                                                [mainStream resetMenuButton];
                                                                [mainStream performSegueWithIdentifier: @"StreamDetailsSegue" sender:mainStream];
                                                            }];
    
    REMenuItem *galleryItem = [[REMenuItem alloc] initWithTitle:@"اختر صورة من معرض الصور"
                                                            subtitle:@""
                                                            image:[UIImage imageNamed:@"galleryIcon"]
                                                            highlightedImage:nil
                                                            action:^(REMenuItem *item) {
                                                                NSLog(@"Item: %@", item);
                                                                // camer action
                                                                mainStream.actionType = FFActionImageLibrary;
                                                                [mainStream resetMenuButton];
                                                                [mainStream performSegueWithIdentifier: @"StreamDetailsSegue" sender:mainStream];
                                                            }];
    REMenuItem *fadfedItem = [[REMenuItem alloc] initWithTitle:@"اختر صورة من فضفض"
                                                            subtitle:@""
                                                            image:[UIImage imageNamed:@"fadfedIcon"]
                                                            highlightedImage:nil
                                                            action:^(REMenuItem *item) {
                                                                NSLog(@"Item: %@", item);
                                                                // camer action
                                                                mainStream.actionType = FFActionImageFadfed;
                                                                [mainStream resetMenuButton];
                                                                [mainStream performSegueWithIdentifier: @"StreamDetailsSegue" sender:mainStream];
                                                            }];
    cameraItem.tag = 0;
    galleryItem.tag = 1;
    fadfedItem.tag = 2;
    // creat the menu with the available options    
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            menu = [[REMenu alloc] initWithItems:@[fadfedItem]];
        else
            menu = [[REMenu alloc] initWithItems:@[galleryItem, fadfedItem]];
    }
    else
    {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
            menu = [[REMenu alloc] initWithItems:@[cameraItem, fadfedItem]];
        else
            menu = [[REMenu alloc] initWithItems:@[cameraItem, galleryItem, fadfedItem]];
    }
    //if (!REUIKitIsFlatMode()) {
        self.menu.cornerRadius = 4;
        self.menu.shadowRadius = 4;
        self.menu.shadowColor = [UIColor blackColor];
        self.menu.shadowOffset = CGSizeMake(0, 1);
        self.menu.shadowOpacity = 1;
    //}
    menu.textColor = [[FFManager sharedManager] colorMenuItem];
    menu.font = [UIFont systemFontOfSize:16];
    menu.itemHeight = 42;
    self.menu.imageOffset = CGSizeMake(5, -1);
    self.menu.waitUntilAnimationIsComplete = YES;
    self.menu.mainStreamController = mainStream;
}

// Toggle menu
- (void)toggleMenu
{
    // if opened then close
    if (self.menu.isOpen)
    {
        return [self.menu close];
    }
    // show menu
    [self.menu showFromNavigationController:self];
}

@end
