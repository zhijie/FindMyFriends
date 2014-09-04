//
//  RSLLoginViewController.m
//  FindMyFriends4IOS
//
//  Created by lizhijie on 9/4/14.
//  Copyright (c) 2014 ___resolr___. All rights reserved.
//

#import "RSLLoginViewController.h"
#import "RSLRegisterViewController.h"
#import "RSLAppDelegate.h"
#import "RSLConstants.h"

@interface RSLLoginViewController ()

@end

@implementation RSLLoginViewController

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
    self.title = @"Login";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setField:(UITextField *)field forKey:(NSString *)key
{
    if (field.text != nil)
    {
        [[NSUserDefaults standardUserDefaults] setObject:field.text forKey:key];
    } else {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    }
}

- (IBAction)login:(id)sender {
    
    [self setField:_usernameLabel forKey:kXMPPmyJID];
    [self setField:_passwordLabel forKey:kXMPPmyPassword];
    
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)newregister:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        RSLRegisterViewController* registerController = [[RSLRegisterViewController alloc] initWithNibName:@"RSLRegisterViewController" bundle:nil];
        RSLAppDelegate *appDelegate = (RSLAppDelegate *)[[UIApplication sharedApplication] delegate];
        [appDelegate.rootController presentViewController:registerController animated:YES completion:nil];
    }];
}

@end
