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
#import <UIKit/UIRefreshControl.h>

@interface LTExploreViewController : UITableViewController <GetBlipsDelegate, UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate, LTLocationControllerDelegate, LBYouTubePlayerControllerDelegate, LBYouTubePlayerDelegate>
{
  LBYouTubePlayerViewController *controller;
}

@property (strong, nonatomic) NSMutableArray *blips;
@property (strong, nonatomic) UIWebView *webViewPlayer;
@property (nonatomic, strong) LBYouTubePlayerViewController* controller;

-(void)videoFinished;

@end
