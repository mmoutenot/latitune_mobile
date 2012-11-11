//
//  LTFirstViewController.m
//  Latitune
//
//  Created by Ben Weitzman on 11/10/12.
//  Copyright (c) 2012 Ben Weitzman. All rights reserved.
//

#import "LTExploreViewController.h"
#import "LTLocationController.h"

@interface LTExploreViewController ()

@end

@implementation LTExploreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
  LTLocationController *locationController = [LTLocationController sharedInstance];
  CLLocationCoordinate2D location = [locationController location];
  GeoPoint point;
  point.lat = location.latitude;
  point.lng = location.longitude;
  [[LTCommunication sharedInstance] getBlipsNearLocation:point withDelegate:self];
  
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) getBlipsDidSucceedWithBlips:(NSArray *)blips {
  NSMutableArray *locations = [[NSMutableArray alloc] init];
  LTLocationController *locationController = [LTLocationController sharedInstance];
  CLLocationCoordinate2D currentLocationCoordinate = [locationController location];
  CLLocation *currentLocation = [[CLLocation alloc] initWithLatitude:currentLocationCoordinate.latitude
                                                           longitude:currentLocationCoordinate.longitude];
  __block int waiting = 0;
  for (Blip *blip in blips) {
    CLLocation *location = [[CLLocation alloc] initWithLatitude:blip.location.lat longitude:blip.location.lng];
    waiting++;
    [[[CLGeocoder alloc] init] reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
      waiting--;
      NSDictionary *locationData = @{@"description":((CLPlacemark*)placemarks[0]).name,@"latlng":location,@"song":blip.song};
      NSUInteger newIndex = [locations indexOfObject:locationData
                                   inSortedRange:(NSRange){0, [locations count]}
                                         options:NSBinarySearchingInsertionIndex
                                     usingComparator:^NSComparisonResult(id obj1, id obj2) {
                                       CLLocation *obj1location = obj1[@"latlng"];
                                       CLLocation *obj2location = obj2[@"latlng"];
                                       return [@([obj1location distanceFromLocation:currentLocation]) compare:@([obj2location distanceFromLocation:currentLocation])] ;
                                     }];
      [locations insertObject:locationData atIndex:newIndex];
      if (waiting == 0) {
        for (NSDictionary *loc in locations) {
          NSLog(@"%@ bye %@ at %@",((Song *)loc[@"song"]).title, ((Song *)loc[@"song"]).artist, loc[@"description"]);
        }
      }
    }];
  }
}

- (void) getBlipsDidFail {
  NSLog(@"get blips fail");
}

@end
