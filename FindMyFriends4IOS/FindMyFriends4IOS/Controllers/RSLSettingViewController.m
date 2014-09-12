//
//  RSLSettingViewController.m
//  FindMyFriends4IOS
//
//  Created by lizhijie on 9/9/14.
//  Copyright (c) 2014 ___resolr___. All rights reserved.
//

#import "RSLSettingViewController.h"
#import "RSLConstants.h"
#import "RSLAppDelegate.h"

@interface RSLSettingViewController ()

@end

@implementation RSLSettingViewController

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
    self.title = @"Settings";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logout:(id)sender {
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kXMPPmyJID];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kXMPPmyPassword];
    RSLAppDelegate* appdelegate = (RSLAppDelegate *)[[UIApplication sharedApplication] delegate];
    [appdelegate.xmppStream disconnect];
    [self.navigationController popViewControllerAnimated:YES];
}

@end
