//
//  LTLoginViewController.h
//  Latitune
//
//  Created by Ben Weitzman on 11/12/12.
//  Copyright (c) 2012 Ben Weitzman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTCommunication.h"

@interface LTLoginViewController : UITableViewController <LoginDelegate, UITextFieldDelegate>

@property (nonatomic, strong) NSMutableArray *textFields;
@property (nonatomic, strong) NSArray *fieldPrompts;
@property (nonatomic, strong) NSArray *accessibilityLabels;

@end
