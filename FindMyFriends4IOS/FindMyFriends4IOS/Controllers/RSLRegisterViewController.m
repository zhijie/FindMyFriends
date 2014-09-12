//
//  RSLRegisterViewController.m
//  FindMyFriends4IOS
//
//  Created by lizhijie on 9/4/14.
//  Copyright (c) 2014 ___resolr___. All rights reserved.
//

#import "RSLRegisterViewController.h"
#import "RSLLoginViewController.h"
#import "RSLAppDelegate.h"

@interface RSLRegisterViewController ()

@end

@implementation RSLRegisterViewController

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
    self.title = @"Register";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onRegister:(id)sender {
}

- (IBAction)login:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        RSLLoginViewController* loginController = [[RSLLoginViewController alloc] initWithNibName:@"RSLLoginViewController" bundle:nil];
        RSLAppDelegate *appDelegate = (RSLAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.rootController presentViewController:loginController animated:YES completion:nil];
    }];
}
@end
