//
//  RSLMapViewController.h
//  FindMyFriends4IOS
//
//  Created by lizhijie on 9/4/14.
//  Copyright (c) 2014 ___resolr___. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BMapKit.h"
@interface RSLMapViewController : UIViewController<UISplitViewControllerDelegate,BMKLocationServiceDelegate,BMKMapViewDelegate>

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@end
