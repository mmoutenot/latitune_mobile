//
//  LTBlipViewController.m
//  Latitune
//
//  Created by Ben Weitzman on 11/10/12.
//  Copyright (c) 2012 Ben Weitzman. All rights reserved.
//

#import "LTBlipViewController.h"
#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>

@interface LTBlipViewController ()

@end

@implementation LTBlipViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (IBAction)showMediaPicker:(id)sender
{
  MPMediaPickerController *mediaPicker = [[MPMediaPickerController alloc] initWithMediaTypes: MPMediaTypeAny];
  mediaPicker.delegate = self;
  mediaPicker.allowsPickingMultipleItems = YES;
  mediaPicker.prompt = @"Select songs to play";
  @try {
    [self presentViewController:mediaPicker animated:YES completion:nil];
  }
  @catch (NSException *exception) {
    [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Oops!",@"Error title")
                                message:NSLocalizedString(@"The music library is not available.",@"Error message when MPMediaPickerController fails to load")
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
  }
}

- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection
{
  if (mediaItemCollection) {
  }
  [self dismissViewControllerAnimated:YES completion:nil];
}
- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
