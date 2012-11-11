//
//  LTRegisterViewController.h
//  Latitune
//
//  Created by Ben Weitzman on 11/11/12.
//  Copyright (c) 2012 Ben Weitzman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormKit.h"

@interface LTRegisterViewController : UITableViewController

@property (nonatomic, strong) FKFormModel *formModel;
- (IBAction)close:(id)sender;

@end
