//
//  LTMainViewController.h
//  Latitune
//
//  Created by Ben Weitzman on 12/3/12.
//  Copyright (c) 2012 Ben Weitzman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LTMainViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UIBarButtonItem *logoutButton;

- (IBAction)logout:(id)sender;

@end
