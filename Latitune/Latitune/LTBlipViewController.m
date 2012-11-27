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
  locationController = [LTLocationController sharedInstance];
}

- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker {
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (void) loginDidSucceedWithUser:(NSDictionary *)user {
  NSLog(@"login succeed");
}

- (void) loginDidFail {
  NSLog(@"login fail");
}

- (void) addSongDidFail {
  NSLog(@"Failed adding song");
}

- (void) addSongDidSucceedWithSong:(Song*) song {
  GeoPoint point;
  CLLocationCoordinate2D location = [locationController location];
  point.lat = location.latitude;
  point.lng = location.longitude;
  [[LTCommunication sharedInstance] addBlipWithSong:song atLocation:point withDelegate:self];
}

- (void) addBlipDidSucceedWithBlip:(Blip*) blip {
  NSLog(@"added blip y'all");
}

- (void) addBlipDidFail{
  NSLog(@"add blip failed");
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
