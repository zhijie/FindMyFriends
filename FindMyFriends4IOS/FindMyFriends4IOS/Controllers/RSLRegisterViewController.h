//
//  RSLRegisterViewController.h
//  FindMyFriends4IOS
//
//  Created by lizhijie on 9/4/14.
//  Copyright (c) 2014 ___resolr___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RSLRegisterViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *usernameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;
- (IBAction)onRegister:(id)sender;
- (IBAction)login:(id)sender;
@end
