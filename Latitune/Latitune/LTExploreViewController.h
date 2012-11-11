//
//  LTFirstViewController.h
//  Latitune
//
//  Created by Ben Weitzman on 11/10/12.
//  Copyright (c) 2012 Ben Weitzman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTCommunication.h"

@interface LTExploreViewController : UITableViewController <GetBlipsDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *blips;
@property (strong, nonatomic) UIWebView *webViewPlayer;

@end
