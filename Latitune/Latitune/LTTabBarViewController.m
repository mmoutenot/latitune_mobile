//
//  LTTabBarViewController.m
//  Latitune
//
//  Created by Ben Weitzman on 11/27/12.
//  Copyright (c) 2012 Ben Weitzman. All rights reserved.
//

#import "LTTabBarViewController.h"

@interface LTTabBarViewController ()

@end

@implementation LTTabBarViewController
@synthesize logoutButton;

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
  logoutButton.accessibilityLabel = @"Logout Button";
  self.view.accessibilityLabel = @"Main View";
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)logout:(id)sender {
  [self performSegueWithIdentifier:@"showAuthenticateSegue" sender:self];
}
@end
