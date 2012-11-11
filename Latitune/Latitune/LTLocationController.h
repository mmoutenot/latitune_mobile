//
//  LTLocationController.h
//  Latitune
//
//  Created by Marshall Moutenot on 11/10/12.
//  Copyright (c) 2012 Ben Weitzman. All rights reserved.
//

@protocol LTLocationControllerDelegate
@required
- (void)locationUpdate:(CLLocation *)location;
- (void)locationError:(NSError *)error;
@end


@interface LTLocationController : NSObject <CLLocationManagerDelegate> {
  id<LTLocationControllerDelegate> __unsafe_unretained delegate;
}

@property (unsafe_unretained) id <LTLocationControllerDelegate> delegate;

+ (id) sharedInstance;

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;

- (CLLocationCoordinate2D)location;

- (float) heading;

@end
