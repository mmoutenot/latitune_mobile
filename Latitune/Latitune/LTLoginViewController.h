//
//  LTLoginViewController.h
//  Latitune
//
//  Created by Ben Weitzman on 11/12/12.
//  Copyright (c) 2012 Ben Weitzman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormKit.h"
#import "LTCommunication.h"

@interface LTLoginViewController : UITableViewController <LoginDelegate>

@property (nonatomic, strong) FKFormModel *formModel;
- (IBAction)close:(id)sender;

@end
