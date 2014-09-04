//
//  RSLMapViewController.m
//  FindMyFriends4IOS
//
//  Created by lizhijie on 9/4/14.
//  Copyright (c) 2014 ___resolr___. All rights reserved.
//

#import "RSLMapViewController.h"
#import "RSLAppDelegate.h"
#import "RSLLoginViewController.h"
#import "RSLContactViewController.h"

@interface RSLMapViewController () {
    RSLLoginViewController* loginController;

}

@end

@implementation RSLMapViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Map";
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(showContacts)];
    leftBarButtonItem.title = @"Contacts";
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
//        UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
//        if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
//            self.navigationItem.leftBarButtonItem = nil;
//        }
//    }
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(setting)];
    rightBarButtonItem.title = @"Setting";
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
}
-(void)setting
{
    
}

-(void)showContacts
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        RSLContactViewController* contacts = [[RSLContactViewController alloc] initWithNibName:@"RSLContactViewController" bundle:nil];
        RSLAppDelegate *appDelegate = (RSLAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.rootController presentViewController:contacts animated:YES completion:nil];
    }
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    RSLAppDelegate *appDelegate = (RSLAppDelegate *)[[UIApplication sharedApplication] delegate];
    
	if (![appDelegate connect])
	{
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.0 * NSEC_PER_SEC);
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
			loginController = [[RSLLoginViewController alloc] initWithNibName:@"RSLLoginViewController" bundle:nil];
            RSLAppDelegate *appDelegate = (RSLAppDelegate *)[[UIApplication sharedApplication] delegate];
            [appDelegate.rootController presentViewController:loginController animated:YES completion:nil];
		});
	}
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Split view support

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController*)popoverController
{
    [self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];

}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    // Called when the view is shown again in the split view, invalidating the button and popover controller.
    [self.navigationItem setLeftBarButtonItem:nil animated:YES];

}


// Called when the hidden view controller is about to be displayed in a popover.
- (void)splitViewController:(UISplitViewController*)svc popoverController:(UIPopoverController*)pc willPresentViewController:(UIViewController *)aViewController
{
	// Check whether the popover presented from the "Tap" UIBarButtonItem is visible.
//	if ([self.barButtonItemPopover isPopoverVisible])
//    {
//		// Dismiss the popover.
//        [self.barButtonItemPopover dismissPopoverAnimated:YES];
//    }
}


#pragma mark - Rotation support

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{

}


- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{

}

@end
