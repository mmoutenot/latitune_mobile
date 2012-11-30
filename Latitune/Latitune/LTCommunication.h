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

typedef enum {
  Success = 20,
  MissingRequiredParameters = 10,
  EmailDuplicate = 30,
  UsernameDuplicate = 31,
  InvalidAuthentication = 32,
  InvalidSongID = 40,
  InvalidBlipID = 50,
  InvalidCommentID = 60,
  InvalidFavoriteID = 70
} LatituneServerStatus;

@interface Song : NSObject
@property (strong, nonatomic) NSString *title, *album, *artist, *providerSongID, *providerKey;
@property (nonatomic) NSInteger songID;

- (id) initWithTitle:(NSString *)_title artist:(NSString*)_artist album:(NSString*)_album;

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

- (void) createUserDidFailWithError:(NSNumber *)errorCode;
- (void) createUserDidSucceedWithUser:(NSDictionary*)user;

@end

@protocol LoginDelegate <NSObject>

- (void) loginDidFail;
- (void) loginDidSucceedWithUser:(NSDictionary*)user;

@end

@interface LTCommunication : NSObject
@property (strong,nonatomic) NSString *username, *password;
@property (nonatomic) NSInteger userID;

+(id)sharedInstance;
- (void) loginWithStoredData;
- (void) loginWithUsername:(NSString *)uname password:(NSString *)password withDelegate:(NSObject <LoginDelegate>*)delegate;
- (void) createUserWithUsername:(NSString *)uname email:(NSString*)uemail password:(NSString*)upassword
                   withDelegate:(NSObject<CreateUserDelegate>*) delegate;
- (void) addSong:(Song *)song withDelegate:(NSObject <AddSongDelegate>*)delegate;
- (void) addBlipWithSong:(Song *)song atLocation:(GeoPoint)point withDelegate:(NSObject <AddBlipDelegate>*)delegate;
- (void) getBlipsWithDelegate:(NSObject <GetBlipsDelegate> *)delegate;
- (void) getBlipsNearLocation:(GeoPoint)location withDelegate:(NSObject<GetBlipsDelegate>*)delegate;
- (void) getBlipWithID:(NSInteger)blipID withDelegate:(NSObject<GetBlipsDelegate>*)delegate;

@end
