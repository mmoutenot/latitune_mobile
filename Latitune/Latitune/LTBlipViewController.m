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

- (void)viewDidLoad
{
  [super viewDidLoad];
  locationController = [[LTLocationController alloc] init];
  locationController.delegate = self;
  [locationController.locationManager startUpdatingLocation];
  NSLog(@"started location");
}

- (IBAction)showMediaPicker:(id)sender {
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

- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) mediaItemCollection {
  if (mediaItemCollection) {
    MPMediaItem *representativeItem = [mediaItemCollection representativeItem];
    NSString *albumName = [representativeItem valueForProperty: MPMediaItemPropertyAlbumTitle];
    NSString *artistName = [representativeItem valueForProperty: MPMediaItemPropertyArtist];
    NSString *songName = [representativeItem valueForProperty: MPMediaItemPropertyTitle];
    
    Song *newSong = [[Song alloc] initWithTitle:songName artist:artistName album:albumName];
    
    [[LTCommunication sharedInstance] addSong:newSong withDelegate:self];
    
    GeoPoint point;
    point.lat = locationController.locationManager.location.coordinate.latitude;
    point.lng = locationController.locationManager.location.coordinate.longitude;
    
    [[LTCommunication sharedInstance] addBlipWithSong:newSong atLocation:point withDelegate:self];
  }
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) addSongDidFail {
  NSLog(@"Failed adding song");
}

- (void) addSongDidSucceedWithSong:(Song*) song {
  NSLog(@"Song succesfully added");
}

- (void) getBlipsDidFail {
  NSLog(@"Failed adding blip");
}

- (void) getBlipsDidSucceedWithBlips:(NSArray *)blips {
  NSLog(@"Blip successfully added");
}

- (void)locationUpdate:(CLLocation *)location {
  NSLog(@"%@",location);
}

- (void)locationError:(NSError *)error {
  NSLog(@"%@",error);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
