//
//  LTCommunication.h
//  Latitune
//
//  Created by Ben Weitzman on 11/10/12.
//  Copyright (c) 2012 Ben Weitzman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Song : NSObject
@property (strong, nonatomic) NSString *title, *album, *artist, *providerSongID, *providerKey;
@property (nonatomic) NSInteger songID;
- (NSDictionary *)asDictionary;
@end

@protocol AddSongDelegate <NSObject>

- (void) addSongDidFail;
- (void) addSongDidSucceedWithSong:(Song*) song;

@end

@interface LTCommunication : NSObject
@property (strong,nonatomic) NSString *username, *password;
@property (nonatomic) NSInteger *userID;

+(id)sharedInstance;
- (void) addSong:(Song *)song withDelegate:(NSObject <AddSongDelegate>*)delegate;

@end
