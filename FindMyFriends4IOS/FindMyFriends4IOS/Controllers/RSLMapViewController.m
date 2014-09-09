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
#import "RSLConstants.h"
#import "XMPPFramework.h"
#import "DDLog.h"
#import "RSLSettingViewController.h"

@interface RSLMapViewController () {
    RSLLoginViewController* loginController;
    BMKLocationService* locationService;
    
    RSLAppDelegate* appDelegate;
    XMPPJID* myJid;
    BOOL isMapMovedToUserCenter;
    
}

@end

@implementation RSLMapViewController
@synthesize mapView;
@synthesize roomJid;

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
    
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Rooms" style:UIBarButtonItemStylePlain target:self action:@selector(showContacts)];
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
    appDelegate = (RSLAppDelegate *)[[UIApplication sharedApplication] delegate];

    myJid = appDelegate.xmppStream.myJID;
}

-(void)viewDidUnload
{
    [super viewDidUnload];
    [appDelegate.xmppStream removeDelegate:self];
}

-(void)setting
{
    RSLSettingViewController* setting = [[RSLSettingViewController alloc] initWithNibName:@"RSLSettingViewController" bundle:nil];
    [self.navigationController pushViewController:setting animated:YES];
}

-(void)showContacts
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        RSLContactViewController* contacts = [[RSLContactViewController alloc] initWithNibName:@"RSLContactViewController" bundle:nil];
        [appDelegate.rootController presentViewController:contacts animated:YES completion:nil];
    }else {
        UISplitViewController* spv = appDelegate.splitController;
        
        self.hideMaster= !self.hideMaster;
        [ spv.view setNeedsLayout ];
    }
}

-(void)viewWillAppear:(BOOL)animated {
    [mapView viewWillAppear];
    mapView.zoomLevel = 17;
    mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    locationService.delegate = self;
    mapView.showsUserLocation = YES;
    
    [appDelegate.xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
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
    
	if (![appDelegate connect])
	{
		dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 0.0 * NSEC_PER_SEC);
		dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
			loginController = [[RSLLoginViewController alloc] initWithNibName:@"RSLLoginViewController" bundle:nil];
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

//- (BOOL)splitViewController: (UISplitViewController*)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation
//{
//    //This method is only available in iOS5
//    
//    return self.hideMaster;
//}

#pragma mark - Rotation support

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (mapView ) {
        [self.view setNeedsUpdateConstraints];
        [mapView viewWillDisappear];
        [mapView viewWillAppear];
    }
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
    if (roomJid != nil) {
//        [self sendMessage:[NSString stringWithFormat:@"GPS:%f,%f,%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude,userLocation.heading.magneticHeading]];
    }
}

/**
 *用户位置更新后，会调用此函数
 *@param userLocation 新的用户位置
 */
- (void)didUpdateUserLocation:(BMKUserLocation *)userLocation
{
    //    NSLog(@"didUpdateUserLocation lat %f,long %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
    [mapView updateLocationData:userLocation];
    
    if (!isMapMovedToUserCenter) {
        isMapMovedToUserCenter = YES;
        CLLocationCoordinate2D coordnate;
        coordnate.latitude =userLocation.location.coordinate.latitude;
        coordnate.longitude =userLocation.location.coordinate.longitude;
        [mapView setCenterCoordinate:coordnate animated:YES];
    }
    
    if (roomJid != nil) {
        [self sendMessage:[NSString stringWithFormat:@"GPS:%f,%f,%f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude,userLocation.heading.magneticHeading]];
    }
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
// Override
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKPinAnnotationView *newAnnotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.pinColor = BMKPinAnnotationColorPurple;
        newAnnotationView.animatesDrop = NO;// 设置该标注点动画显示

        return newAnnotationView;
    }
    return nil;
}

#pragma mark xmpp delegate
- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
//	[messageField setEnabled:YES];
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    XMPPJID* fromJid = [message from];

    NSString *messageStr = [[message elementForName:@"body"] stringValue];
    //parse coordnate
    CLLocationCoordinate2D coord ;
    if ([messageStr hasPrefix:@"GPS:"]) {
        NSArray* gpsinfo = [[messageStr substringFromIndex:4] componentsSeparatedByString:@","];
        if (gpsinfo && gpsinfo.count == 3) {
            coord.latitude = [[gpsinfo objectAtIndex:0] doubleValue];
            coord.longitude= [[gpsinfo objectAtIndex:1] doubleValue];
        }
    }
    
    NSArray* annotations = mapView.annotations;
    
    BOOL alreadyIn = NO;
    for (int i =0 ; i < annotations.count; i ++) {
        BMKPointAnnotation* anno = [annotations objectAtIndex:i];
        NSString* username = fromJid.resource;
        if ([[anno title] isEqualToString:username]) {
            alreadyIn = YES;
            //update location
            anno.coordinate = coord;
            [mapView removeAnnotation:anno];
            [mapView addAnnotation:anno];
//            [mapView selectAnnotation:anno animated:NO];
            
            break;
        }
    }
    if (!alreadyIn) {
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
        annotation.coordinate = coord;
        annotation.title = fromJid.resource;
        [mapView addAnnotation:annotation];
    }
    
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
//	[messageField setEnabled:NO];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPRoom Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppRoomDidCreate:(XMPPRoom *)sender
{
//	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
//	[logField setStringValue:@"did create room"];
}

- (void)xmppRoomDidJoin:(XMPPRoom *)sender
{
//	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
//	[logField setStringValue:@"did join room"];
}

- (void)xmppRoomDidLeave:(XMPPRoom *)sender
{
//	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
//	[logField setStringValue:@"did leave room"];
}

- (void)xmppRoom:(XMPPRoom *)sender occupantDidJoin:(XMPPJID *)occupantJID
{
//	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
//	[logField setStringValue:[NSString stringWithFormat:@"occupant did join: %@", [occupantJID resource]]];
}

- (void)xmppRoom:(XMPPRoom *)sender occupantDidLeave:(XMPPJID *)occupantJID
{
//	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
//	[logField setStringValue:[NSString stringWithFormat:@"occupant did join: %@", [occupantJID resource]]];
}

- (void)xmppRoom:(XMPPRoom *)sender didReceiveMessage:(XMPPMessage *)message fromOccupant:(XMPPJID *)occupantJID
{
//	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
//	[logField setStringValue:[NSString stringWithFormat:@"did receive msg from: %@", [occupantJID resource]]];
}


- (void)sendMessage:(NSString*)messageStr
{
	if([messageStr length] > 0)
	{
		NSXMLElement *body = [NSXMLElement elementWithName:@"body"];
		[body setStringValue:messageStr];
		
		NSXMLElement *message = [NSXMLElement elementWithName:@"message"];
		[message addAttributeWithName:@"type" stringValue:@"groupchat"];
		[message addAttributeWithName:@"to" stringValue:roomJid.bare];
		[message addChild:body];
		
		[appDelegate.xmppStream sendElement:message];
	}
}

@end
