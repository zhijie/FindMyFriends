//
//  RSLContactViewController.h
//  FindMyFriends4IOS
//
//  Created by lizhijie on 9/4/14.
//  Copyright (c) 2014 ___resolr___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSLContactViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

- (IBAction)onCancel:(id)sender;
- (IBAction)onAdd:(id)sender;
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@end
