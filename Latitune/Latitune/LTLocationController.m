//
//  LTLocationController.m
//  Latitune
//
//  Created by Marshall Moutenot on 11/10/12.
//  Copyright (c) 2012 Ben Weitzman. All rights reserved.
//

#import "LTLocationController.h"

@implementation LTLocationController

@synthesize locationManager;
@synthesize delegate;

- (id) init {
  self = [super init];
  if (self != nil) {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
  }
  return self;
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
  [self.delegate locationUpdate:newLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
  [self.delegate locationError:error];
}

@end