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
    BMKLocationService* locationService;


}

@end

@implementation RSLMapViewController
@synthesize mapView;

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
    
    locationService = [[BMKLocationService alloc]init];
    
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

-(void)viewWillAppear:(BOOL)animated {
    [mapView viewWillAppear];
    mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    locationService.delegate = self;
    mapView.showsUserLocation = YES;
    [locationService startUserLocationService ];
}

-(void)viewWillDisappear:(BOOL)animated {
    [mapView viewWillDisappear];
    mapView.delegate = nil; // 不用时，置nil
    locationService.delegate = nil;
    mapView.showsUserLocation = NO;
    [locationService stopUserLocationService ];
}

-(void) viewDidAppear:(BOOL)animated
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

#pragma mark mapview
/**
 *在地图View将要启动定位时，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewWillStartLocatingUser:(BMKMapView *)mapView
{
	NSLog(@"start locate");
}

/**
 *用户方向更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    [mapView updateLocationData:userLocation];
    NSLog(@"heading is %@",userLocation.heading);
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [mapView updateLocationData:userLocation];
}

/**
 *在地图View停止定位后，会调用此函数
 *@param mapView 地图View
 */
- (void)mapViewDidStopLocatingUser:(BMKMapView *)mapView
{
    NSLog(@"stop locate");
}

/**
 *定位失败后，会调用此函数
 *@param mapView 地图View
 *@param error 错误号，参考CLError.h中定义的错误号
 */
- (void)mapView:(BMKMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"location error");
}

@end
