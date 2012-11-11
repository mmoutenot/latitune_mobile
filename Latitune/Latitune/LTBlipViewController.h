//
//  LTBlipViewController.h
//  Latitune
//
//  Created by Ben Weitzman on 11/10/12.
//  Copyright (c) 2012 Ben Weitzman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "LTCommunication.h"
#import "LTLocationController.h"

@interface LTBlipViewController : UIViewController <MPMediaPickerControllerDelegate, AddSongDelegate, AddBlipDelegate, LTLocationControllerDelegate, LoginDelegate>{
  LTLocationController *locationController;
}

- (IBAction)showMediaPicker:(id)sender;

@end
