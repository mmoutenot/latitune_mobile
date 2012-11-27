//
//  LTTabBarViewController.h
//  Latitune
//
//  Created by Ben Weitzman on 11/27/12.
//  Copyright (c) 2012 Ben Weitzman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTTabBarViewController : UITabBarController
@property (strong, nonatomic) IBOutlet UIBarButtonItem *logoutButton;
- (IBAction)logout:(id)sender;

@end
