//
//  CollapsableTableViewHeaderViewController.m
//  CollapsableTableView
//
//  Created by Bernhard Häussermann on 2011/04/01.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "CollapsableTableViewHeaderViewController.h"


@implementation CollapsableTableViewHeaderViewController

@synthesize titleLabel,detailLabel,tapDelegate;


- (void) setView:(UIView*) newView
{
    if (viewWasSet)
    {
        [self.view removeGestureRecognizer:tapRecognizer];
        [tapRecognizer release];
    }
    [super setView:newView];
    tapRecognizer = [[CollapsableTableViewTapRecognizer alloc] initWithTitle:fullTitle andTappedView:newView andTapDelegate:tapDelegate];
    [self.view addGestureRecognizer:tapRecognizer];
    viewWasSet = YES;
    
    // In case a custom header view is used, this ensures that the collapsed indicator label (if present) displays the 
    // right characther ('-' or '+').
    if (! collapsedIndicatorLabel)
    {
        UIView* subView = [self.view viewWithTag:COLLAPSED_INDICATOR_LABEL_TAG];
        if ((subView) && ([subView.class isSubclassOfClass:[UILabel class]]))
        {
            collapsedIndicatorLabel = (UILabel*) subView;
            self.isCollapsed = isCollapsed;
        }
    }
    if (! collapsedIndicatorImageView)
    {
        UIView* subView = [self.view viewWithTag:COLLAPSED_INDICATOR_IMAGE_TAG];
        if ((subView) && ([subView.class isSubclassOfClass:[UIImageView class]]))
        {
            collapsedIndicatorImageView = (UIImageView *) subView;
            self.isCollapsed = isCollapsed;
        }
    }
    
    
    // This fixes a bug that occurs prior to iOS 5 with the plain style, which causes the title labels to disappear sometimes.
    if ((titleLabel.tag==321) && ([[[UIDevice currentDevice] systemVersion] characterAtIndex:0]<='4'))
        titleLabel.autoresizingMask = UIViewAutoresizingNone;
}

- (NSString*) fullTitle
{
    return fullTitle;
}

- (void) setFullTitle:(NSString*) theFullTitle
{
    [theFullTitle retain];
    [fullTitle release];
    fullTitle = theFullTitle;
    tapRecognizer.fullTitle = theFullTitle;
}

- (NSString*) titleText
{
    return titleLabel.text;
}

- (void) setTitleText:(NSString*) newText
{
    titleLabel.text = newText;
    
    CGFloat heightDiff = self.view.frame.size.height - titleLabel.frame.size.height;
    CGFloat labelHeight = [newText sizeWithFont:titleLabel.font constrainedToSize:CGSizeMake(titleLabel.frame.size.width,titleLabel.numberOfLines==0 ? MAXFLOAT : titleLabel.font.lineHeight * titleLabel.numberOfLines) lineBreakMode:UILineBreakModeWordWrap].height;
    CGRect frame = titleLabel.frame;
    frame.size.height = labelHeight;
    titleLabel.frame = frame;
    frame = self.view.frame;
    frame.size.height = labelHeight + heightDiff;
    self.view.frame = frame;
}

- (NSString*) detailText
{
    return detailLabel.text;
}

- (void) setDetailText:(NSString*) newText
{
    detailLabel.text = newText;
}

- (BOOL) isCollapsed
{
    return isCollapsed;
}

- (void) setIsCollapsed:(BOOL) flag
{
    isCollapsed = flag;
    //collapsedIndicatorLabel.text = isCollapsed ? @"+" : @"-";
    if(isCollapsed)
        [collapsedIndicatorImageView setImage:[UIImage imageNamed:@"up.png"]];
    else 
        [collapsedIndicatorImageView setImage:[UIImage imageNamed:@"down.png"]];
    
}


// The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
        viewWasSet = isCollapsed = NO;
    return self;
}


// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView 
{
    [super loadView];
    
    self.titleText = self.detailText = @"";
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
/*
- (void)viewDidLoad {
    [super viewDidLoad];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [tapRecognizer release];
    [fullTitle release];

    [super dealloc];
}


@end
