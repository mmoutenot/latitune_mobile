//
//  LTCommunication.h
//  Latitune
//
//  Created by Ben Weitzman on 11/10/12.
//  Copyright (c) 2012 Ben Weitzman. All rights reserved.
//
#import <Foundation/Foundation.h>

typedef struct {
    float lat;
    float lng;
} GeoPoint;

@interface Song : NSObject
@property (strong, nonatomic) NSString *title, *album, *artist, *providerSongID, *providerKey;
@property (nonatomic) NSInteger songID;
- (NSDictionary *)asDictionary;
@end

@interface Blip : NSObject
@property (nonatomic) NSInteger blipID, userID;
@property (strong, nonatomic) Song *song;
@property (nonatomic) GeoPoint location;
@property (strong, nonatomic) NSDate *timestamp;

@end

@protocol AddSongDelegate <NSObject>

- (void) addSongDidFail;
- (void) addSongDidSucceedWithSong:(Song*) song;

@end

@protocol AddBlipDelegate <NSObject>

- (void) addBlipDidFail;
- (void) addBlipDidSucceedWithBlip:(Blip*) song;

@end

@protocol GetBlipsDelegate <NSObject>

- (void) getBlipsDidFail;
- (void) getBlipsDidSucceedWithBlips:(NSArray *)blips;

@end

@protocol CreateUserDelegate <NSObject>

- (void) createUserDidFail;
- (void) createUserDidSucceedWithUser:(NSDictionary*)user;

@end

@interface LTCommunication : NSObject
@property (strong,nonatomic) NSString *username, *password;
@property (nonatomic) NSInteger userID;

+(id)sharedInstance;
- (void) createUserWithUsername:(NSString *)uname email:(NSString*)uemail password:(NSString*)upassword
                   withDelegate:(NSObject<CreateUserDelegate>*) delegate;
- (void) addSong:(Song *)song withDelegate:(NSObject <AddSongDelegate>*)delegate;
- (void) addBlipWithSong:(Song *)song atLocation:(GeoPoint)point withDelegate:(NSObject <AddBlipDelegate>*)delegate;
- (void) getBlipsWithDelegate:(NSObject <GetBlipsDelegate> *)delegate;
- (void) getBlipsNearLocation:(GeoPoint)location withDelegate:(NSObject<GetBlipsDelegate>*)delegate;
- (void) getBlipWithID:(NSInteger)blipID withDelegate:(NSObject<GetBlipsDelegate>*)delegate;

@end
