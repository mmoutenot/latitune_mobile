//
//  LTAppDelegate.h
//  Latitune
//
//  Created by Ben Weitzman on 11/10/12.
//  Copyright (c) 2012 Ben Weitzman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTCommunication.h"

@interface LTAppDelegate : UIResponder <UIApplicationDelegate, LoginDelegate>

@property (strong, nonatomic) UIWindow *window;

@end
