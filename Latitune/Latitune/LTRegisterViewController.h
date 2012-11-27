//
//  LTRegisterViewController.h
//  Latitune
//
//  Created by Ben Weitzman on 11/11/12.
//  Copyright (c) 2012 Ben Weitzman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormKit.h"
#import "LTCommunication.h"

@interface LTRegisterViewController : UITableViewController <CreateUserDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *textFields;
@property (nonatomic, strong) NSArray *fieldPrompts;
@property (nonatomic, strong) NSArray *accessibilityLabels;

@end
