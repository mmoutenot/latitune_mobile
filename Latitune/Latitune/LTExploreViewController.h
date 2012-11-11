//
//  LTFirstViewController.h
//  Latitune
//
//  Created by Ben Weitzman on 11/10/12.
//  Copyright (c) 2012 Ben Weitzman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTCommunication.h"
#import "LTLocationController.h"
#import "LBYouTube.h"

@interface LTExploreViewController : UITableViewController <GetBlipsDelegate, UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate, LTLocationControllerDelegate, LBYouTubePlayerControllerDelegate>
{
  LBYouTubePlayerViewController *controller;
}

@property (strong, nonatomic) NSMutableArray *blips;
@property (strong, nonatomic) UIWebView *webViewPlayer;
@property (nonatomic, strong) LBYouTubePlayerViewController* controller;


@end
