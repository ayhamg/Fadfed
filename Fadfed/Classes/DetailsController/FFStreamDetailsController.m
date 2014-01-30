//
//  FFStreamDetailsController.m
//  Fadfed
//
//  Created by Hani Abu Shaer on 10/22/13.
//  Copyright (c) 2013 AlphaApps. All rights reserved.
//

#import "FFStreamDetailsController.h"

@implementation FFStreamDetailsController

@synthesize feedObject;
@synthesize imageActionType;
@synthesize feedImage;
@synthesize addTextButton;
@synthesize finalView;
@synthesize waterMark;
@synthesize barView;
@synthesize barPicker;

#pragma mark -
#pragma mark View Controller
// View did load
- (void)viewDidLoad
{
    startEditing = NO;    
    // configure header
    [self configureHeader];
    // check user action
    switch (imageActionType)
    {
        case FFActionImageUse:// use the image
        {
            NSString *photoPath = [feedObject objectForKey:PARSE_FEED_COL_IMAGE];
            [feedImage setImageWithURL:[NSURL URLWithString:photoPath] placeholderImage:nil];
            break;
        }
        case FFActionImageCamera:// take image from camera
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:NO completion:NULL];
        }
        case FFActionImageLibrary:// get image from photo library
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.delegate = self;
            picker.allowsEditing = YES;
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:picker animated:NO completion:NULL];
        }
        case FFActionImageFadfed:// get image from fadfed library
        {
            [self performSegueWithIdentifier:@"DetailsLibrarySegue" sender:self];            
        }
        default:
            break;
    }
    activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame = CGRectMake(142, 142, 36, 36);
    activityIndicator.hidesWhenStopped = YES;
    [activityIndicator stopAnimating];
    [feedImage addSubview:activityIndicator];
    // draw add text button
    [addTextButton setEnabled:YES];
    [barPicker setEnabled:YES];
    // init the dragable views array
    dragViewsArray = [[NSMutableArray alloc] init];
    renderedTextArray = [[NSMutableArray alloc] init];
    activeDragViewIndex = -1;
    // init the text area
    [self initTextArea];
    selectedColor = [UIColor colorWithHue:0  saturation: 1 brightness: 1 alpha: 1.0f];
    [super viewDidLoad];
}

// Change navigation bar color
- (void)viewWillAppear:(BOOL)animated
{
    // flat mode iOS7
    if ([[FFManager sharedManager] checkUIKitIsFlatMode])
    {
        [self.navigationController.navigationBar performSelector:@selector(setBarTintColor:) withObject:[UIColor blackColor]];
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        self.navigationController.navigationBar.translucent = NO;
    }
    else// iOS6
    {
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    }
}

// Configure header
- (void)configureHeader
{
    // right button item
    UIBarButtonItem *negativeSeperatorRight = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    UIBarButtonItem *negativeSeperatorLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    // flat mode iOS7
    if ([[FFManager sharedManager] checkUIKitIsFlatMode])
    {
        negativeSeperatorRight.width = -8;
        negativeSeperatorLeft.width = -8;
        [self.navigationController.navigationBar performSelector:@selector(setBarTintColor:) withObject:[UIColor blackColor]];
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
        self.navigationController.navigationBar.translucent = NO;
    }
    else
    {
        negativeSeperatorRight.width = 0;
        negativeSeperatorLeft.width = 0;
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    }
    // next button
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 44)];
    rightButtonView.backgroundColor = [UIColor blackColor];
    nextButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 54, 30)];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"nextButton"] forState:UIControlStateNormal];
    [nextButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    // editing mode
    if (startEditing)
    {
        [nextButton setTitle:@"حفظ" forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(saveTextView) forControlEvents:UIControlEventTouchUpInside];
    }
    else// navigation mode
    {
        [nextButton setTitle:@"التالي" forState:UIControlStateNormal];
        [nextButton addTarget:self action:@selector(nextAction) forControlEvents:UIControlEventTouchUpInside];
    }
    [rightButtonView addSubview:nextButton];
    UIBarButtonItem *addItem = [[UIBarButtonItem alloc] initWithCustomView:nextButton];
    NSArray *actionButtonItems = @[negativeSeperatorRight, addItem];
    self.navigationItem.rightBarButtonItems = actionButtonItems;
    // cancel button
    UIView *leftButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 70, 44)];
    leftButtonView.backgroundColor = [UIColor blackColor];
    cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 54, 30)];
    [cancelButton setBackgroundImage:[UIImage imageNamed:@"cancelButton"] forState:UIControlStateNormal];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    // editing mode
    if (startEditing)
    {
        [cancelButton setTitle:@"حذف" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(removeTextView) forControlEvents:UIControlEventTouchUpInside];
    }
    else// navigation mode
    {
        [cancelButton setTitle:@"عودة" forState:UIControlStateNormal];
        [cancelButton addTarget:self action:@selector(cancelAction) forControlEvents:UIControlEventTouchUpInside];
    }
    [leftButtonView addSubview:cancelButton];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithCustomView:cancelButton];
    NSArray *actionButtonItems2 = @[negativeSeperatorLeft, cancelItem];
    self.navigationItem.leftBarButtonItems = actionButtonItems2;
}

// Set stream details params
- (void)setActiveFeed:(NSMutableDictionary*)activeFeed withActionType:(FFActionImageUsage)actionType
{
    feedObject = activeFeed;
    imageActionType = actionType;
}

// Cancel action
- (void)cancelAction
{
    // get image from fadfed library
    if (imageActionType == FFActionImageFadfed)
    {
        [self performSegueWithIdentifier:@"DetailsLibrarySegue" sender:self];
    }
    else // back to root
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}

// Cancel to root action
- (void)cancelToRoot
{
    [self removeTextView];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

// Next action
- (void)nextAction
{
    [self removeTextView];
    [self performSegueWithIdentifier:@"DetailsNextSegue" sender:self];
}

// Render the final image
- (UIImage*)renderFinalImage
{
    UIGraphicsBeginImageContextWithOptions(self.finalView.bounds.size, TRUE, [[UIScreen mainScreen] scale]);
    [self.finalView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark -
#pragma mark Edit Text View
// Add new text area
- (IBAction)addTextView:(id)sender
{
    // new text view
    [self addNewTextArea:1 withSelectedFont:1];
}

// Init the text area
- (void)initTextArea
{
    // new area
    activeDragViewIndex = -1;
    // init the text view
    editTextView = [[FFEditView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    [editTextView setBackgroundColor:[UIColor clearColor]];
    // add text view
    UIButton *clearBtn = [editTextView addBackground];
    [clearBtn addTarget:self action:@selector(stopWriting) forControlEvents:UIControlEventTouchUpInside];
    // add the text area
    editTextArea = [editTextView addTextView];
    [editTextArea setFont:[UIFont boldSystemFontOfSize:FONT_SIZE_MEDIUM]];
    // add alignment segment
    alignSegment = [editTextView addAlignSegment:1];
    [alignSegment addTarget:self action:@selector(changeAlignment:) forControlEvents: UIControlEventValueChanged];
    // add font size segment
    fontSizeSegment = [editTextView addFontSizeSegment:1];
    [fontSizeSegment addTarget:self action:@selector(changeFontSize:) forControlEvents: UIControlEventValueChanged];
}

// Add new text area
- (void)addNewTextArea:(int)selectedAlignment withSelectedFont:(int)selectedFontSize
{
    // new area
    activeDragViewIndex = -1;
    // init the text view
    editTextView = [[FFEditView alloc] initWithFrame:CGRectMake(0, 0, 320, 320)];
    [editTextView setBackgroundColor:[UIColor clearColor]];
    // add text view
    UIButton *clearBtn = [editTextView addBackground];
    [clearBtn addTarget:self action:@selector(stopWriting) forControlEvents:UIControlEventTouchUpInside];
    // add the text area
    editTextArea = [editTextView addTextView];
    [editTextArea setFont:[UIFont boldSystemFontOfSize:FONT_SIZE_MEDIUM]];
    // add alignment segment
    alignSegment = [editTextView addAlignSegment:selectedAlignment];
    [alignSegment addTarget:self action:@selector(changeAlignment:) forControlEvents: UIControlEventValueChanged];
    // add font size segment
    fontSizeSegment = [editTextView addFontSizeSegment:selectedFontSize];
    [fontSizeSegment addTarget:self action:@selector(changeFontSize:) forControlEvents: UIControlEventValueChanged];
    // add text view to final view
    [self.view addSubview:editTextView];
    startEditing = YES;
    [addTextButton setEnabled:NO];
    [barPicker setEnabled:NO];
    // start editing
    [editTextArea becomeFirstResponder];
    // configure header for editing mode
    [self configureHeader];
}

// Save the current text view
- (void)saveTextView
{
    if (startEditing)
    {
        [editTextArea resignFirstResponder];
        FFDragView *dragRenderView;
        UITextView *renderedTextView;
        // init the drag view
        if (activeDragViewIndex == -1)
        {
            dragRenderView = [[FFDragView alloc] initWithFrame:editTextArea.frame];
            renderedTextView = [dragRenderView addCustomText:editTextArea withColor:selectedColor];
            [dragRenderView addSubview:renderedTextView];
            // add members to arrays
            [dragViewsArray addObject:dragRenderView];
            [renderedTextArray addObject:renderedTextView];
            dragRenderView.tag = [dragViewsArray indexOfObject:dragRenderView];
            // add drag view to final view
            [finalView insertSubview:dragRenderView belowSubview:waterMark];
            [dragRenderView setBackgroundColor:[UIColor clearColor]];
            // double tap recognizer
            UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editDragTextView:)];
            tapRecognizer.numberOfTapsRequired = 2;
            tapRecognizer.numberOfTouchesRequired = 1;
            [dragRenderView addGestureRecognizer:tapRecognizer];
        }
        else// edit mode on previous view
        {
            dragRenderView = (FFDragView*)[dragViewsArray objectAtIndex:activeDragViewIndex];
            renderedTextView = (UITextView*)[renderedTextArray objectAtIndex:activeDragViewIndex];
        }
        dragRenderView.selectedAlignment = alignSegment.selectedSegmentIndex;
        dragRenderView.selectedFontSize = fontSizeSegment.selectedSegmentIndex;
        // adjust text size
        [dragRenderView adjustTextSize:editTextArea withDestination:renderedTextView withColor:selectedColor];
        CGRect frame = dragRenderView.frame;
        frame.size.height = renderedTextView.frame.size.height;
        dragRenderView.frame = frame;
        // remove the current text view
        [editTextView removeFromSuperview];
        startEditing = NO;
        [addTextButton setEnabled:YES];
        [barPicker setEnabled:YES];
        [self configureHeader];
    }
}

// Edit drag text view
- (void)editDragTextView:(UITapGestureRecognizer*)recognizer
{
    // get selected drag view
    FFDragView *dragRenderView = (FFDragView*)[dragViewsArray objectAtIndex:recognizer.view.tag];
    UITextView *renderedTextView = (UITextView*)[renderedTextArray objectAtIndex:recognizer.view.tag];
    // add the new text area with previous config
    [self addNewTextArea:dragRenderView.selectedAlignment withSelectedFont:dragRenderView.selectedFontSize];
    editTextArea.text = renderedTextView.text;
    editTextArea.textAlignment = renderedTextView.textAlignment;
    if (dragRenderView.selectedFontSize == 0)
        [editTextArea setFont:[UIFont boldSystemFontOfSize:FONT_SIZE_SMALL]];
    else if (dragRenderView.selectedFontSize == 1)
        [editTextArea setFont:[UIFont boldSystemFontOfSize:FONT_SIZE_MEDIUM]];
    else
        [editTextArea setFont:[UIFont boldSystemFontOfSize:FONT_SIZE_LARGE]];
    startEditing = YES;
    activeDragViewIndex = recognizer.view.tag;
}

// Remove the current text view
- (void)removeTextView
{
    if (startEditing)
    {
        [editTextArea resignFirstResponder];
        [editTextView removeFromSuperview];
        startEditing = NO;
        [addTextButton setEnabled:YES];
        [barPicker setEnabled:YES];
        if (activeDragViewIndex != -1)
        {
            FFDragView *dragRenderView = (FFDragView*)[dragViewsArray objectAtIndex:activeDragViewIndex];
            UITextView *renderedTextView = (UITextView*)[renderedTextArray objectAtIndex:activeDragViewIndex];
            [dragRenderView removeFromSuperview];
            [renderedTextView removeFromSuperview];
            activeDragViewIndex = -1;
        }
        // configure header for editing mode
        [self configureHeader];
    }
}

// Stop writing
- (void)stopWriting
{
    [editTextArea resignFirstResponder];
}

// Change Alignment
- (void)changeAlignment:(UISegmentedControl*)segment
{
    // left alignment
    if(segment.selectedSegmentIndex == 0)
    {
        [editTextArea setTextAlignment:NSTextAlignmentLeft];
    }
    // center alignment
    else if(segment.selectedSegmentIndex == 1)
    {
        [editTextArea setTextAlignment:NSTextAlignmentCenter];
    }
    // right alignment    
    else if(segment.selectedSegmentIndex == 2)
    {
        [editTextArea setTextAlignment:NSTextAlignmentRight];
    }
}

// Change font size
- (void)changeFontSize:(UISegmentedControl*)segment
{
    // small font size
    if(segment.selectedSegmentIndex == 0)
    {
        [editTextArea setFont:[UIFont boldSystemFontOfSize:FONT_SIZE_SMALL]];
        [fontSizeSegment removeFromSuperview];
        fontSizeSegment = [editTextView addFontSizeSegment:0];
        [fontSizeSegment addTarget:self action:@selector(changeFontSize:) forControlEvents: UIControlEventValueChanged];
    }
    // medium font size
    else if(segment.selectedSegmentIndex == 1)
    {
        [editTextArea setFont:[UIFont boldSystemFontOfSize:FONT_SIZE_MEDIUM]];
        [fontSizeSegment removeFromSuperview];
        fontSizeSegment = [editTextView addFontSizeSegment:1];
        [fontSizeSegment addTarget:self action:@selector(changeFontSize:) forControlEvents: UIControlEventValueChanged];
    }
    // large font size
    else if(segment.selectedSegmentIndex == 2)
    {
        [editTextArea setFont:[UIFont boldSystemFontOfSize:FONT_SIZE_LARGE]];
        [fontSizeSegment removeFromSuperview];
        fontSizeSegment = [editTextView addFontSizeSegment:2];
        [fontSizeSegment addTarget:self action:@selector(changeFontSize:) forControlEvents: UIControlEventValueChanged];
    }
}

// Receive memory warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
#pragma mark Image Picker Controller delegate methods
// Image picker pick media
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
    self.feedImage.image = chosenImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

// Dismiss picker
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:NO completion:NULL];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

#pragma mark -
#pragma mark UIColor picker
// Take picker color value
- (IBAction)takeBarPickerValue:(InfColorBarPicker*)sender
{
    float hue = sender.value;
    selectedColor = [UIColor colorWithHue:hue  saturation: 1 brightness: 1 alpha: 1.0f];
    [self updateColor];
}

// Update the text color
- (void)updateColor
{
    for (int i = 0; i < [dragViewsArray count]; i++)
    {
        FFDragView *dragRenderView = (FFDragView*)[dragViewsArray objectAtIndex:i];
        UITextView *renderedTextView = (UITextView*)[renderedTextArray objectAtIndex:i];
        [dragRenderView adjustTextColor:renderedTextView withColor:selectedColor];
    }
}

#pragma mark -
#pragma mark - Navigation
// Navigation contorller
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{    // Esconder el StatusBar. Provocado por el iOS7 y el UIImagePickerController
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

 // In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"DetailsNextSegue"])
    {
        FFDetailsFinalController *finalController = segue.destinationViewController;
        // render the final image from view
        finalController.feedImage = [self renderFinalImage];
    }
}

// Un wind to details segue
- (IBAction)unwindDetailsSegue:(UIStoryboardSegue*)segue
{
    // check the unwind segue identefier
    if ([[segue identifier] isEqualToString:@"UnwindDetailsSegue"])
    {
        FFLibraryImagesController* libraryImagesController = (FFLibraryImagesController*)segue.sourceViewController;
        // the item selected
        if ([[libraryImagesController.activeFeedObject allKeys] count] > 0)
        {
            [self setFeedObject:libraryImagesController.activeFeedObject];
            NSString *photoPath = [feedObject objectForKey:PARSE_TEMPLATE_COL_IMAGE];
            [feedImage setImageWithURL:[NSURL URLWithString:photoPath] placeholderImage:nil];
            [activityIndicator startAnimating];
            [nextButton setEnabled:NO];
            [feedImage addSubview:activityIndicator];
            [feedImage setImageWithURL:[NSURL URLWithString:photoPath]
                                placeholderImage:nil
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
             {
                 [activityIndicator stopAnimating];
                 [nextButton setEnabled:YES];
             }];
        }
        else // go back to root
        {
            [self performSelector:@selector(cancelToRoot) withObject:nil afterDelay:0.0];
        }
    }
}

@end
