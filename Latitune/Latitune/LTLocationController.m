//
//  LTLocationController.m
//  Latitune
//
//  Created by Marshall Moutenot on 11/10/12.
//  Copyright (c) 2012 Ben Weitzman. All rights reserved.
//

#import "LTLocationController.h"

@interface LTLocationController()
{
    CLLocationManager *locationManager;
}
@end

@implementation LTLocationController

@synthesize delegate;

+ (id)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

- (id) init {
    self = [super init];
    if (self != nil) {
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        [locationManager startUpdatingLocation];
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

- (CLLocationCoordinate2D)location {
    return locationManager.location.coordinate;
}

@end