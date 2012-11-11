//
//  LTBlipViewController.h
//  Latitune
//
//  Created by Ben Weitzman on 11/10/12.
//  Copyright (c) 2012 Ben Weitzman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface LTBlipViewController : UIViewController <MPMediaPickerControllerDelegate>

- (IBAction)showMediaPicker:(id)sender;

@end
