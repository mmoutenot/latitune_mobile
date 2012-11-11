//
//  LTYouTubeViewController.m
//  Latitune
//
//  Created by Ben Weitzman on 11/11/12.
//  Copyright (c) 2012 Ben Weitzman. All rights reserved.
//

#import "LTYouTubeViewController.h"

@interface LTYouTubeViewController ()

@end

@implementation LTYouTubeViewController

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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)close:(id)sender {
  [self dismissViewControllerAnimated:YES completion:nil];
}
@end
