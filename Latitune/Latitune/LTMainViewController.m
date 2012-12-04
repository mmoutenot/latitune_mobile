//
//  LTMainViewController.m
//  Latitune
//
//  Created by Ben Weitzman on 12/3/12.
//  Copyright (c) 2012 Ben Weitzman. All rights reserved.
//

#import "LTMainViewController.h"

@interface LTMainViewController ()

@end

@implementation LTMainViewController

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
  self.accessibilityLabel = @"Main View";
  self.logoutButton.accessibilityLabel = @"Logout Button";
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
