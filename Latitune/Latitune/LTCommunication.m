//
//  LTCommunication.m
//  Latitune
//
//  Created by Ben Weitzman on 11/10/12.
//  Copyright (c) 2012 Ben Weitzman. All rights reserved.
//

#import "LTCommunication.h"
#import "ASIHTTPRequest.h"
#import "SBJson.h"

@implementation Song

@synthesize album,artist,providerKey,providerSongID,songID,title;
- (id) initWithTitle:(NSString *)_title artist:(NSString*)_artist album:(NSString*)_album
      providerSongID:(NSString*)_providerSongID providerKey:(NSString*)_providerKey {
    self = [super init];
    if (self) {
        title = _title;
        artist = _artist;
        album = _album;
        providerKey = _providerKey;
        providerSongID = _providerSongID;
    }
    return self;
}

- (NSDictionary *)asDictionary {
    return @{@"title":title,@"artist":artist,@"album":album,@"provider_key":providerKey,@"providerSongID":providerSongID};
}
@end

@implementation Blip

@synthesize userID,blipID,location,song,timestamp;

@end

@implementation LTCommunication
@synthesize password, userID, username;

+ (id)sharedInstance {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

- (id) performSelector: (SEL) selector withObject:(id) p1 withObject: (id) p2 {
    NSMethodSignature *sig = [self methodSignatureForSelector:selector];
    if (!sig)
        return nil;
    
    NSInvocation* invo = [NSInvocation invocationWithMethodSignature:sig];
    [invo setTarget:self];
    [invo setSelector:selector];
    [invo setArgument:&p1 atIndex:2];
    [invo setArgument:&p2 atIndex:3];
    [invo invoke];
    if (sig.methodReturnLength) {
        id anObject;
        [invo getReturnValue:&anObject];
        return anObject;
    }
    return nil;
}

- (void)getURL:(NSString*)urlString parameters:(NSDictionary*)params succeedSelector:(SEL)succeedSelector
  failSelector:(SEL) failSelector closure:(NSDictionary*)cl; {
    urlString = [NSString stringWithFormat:@"%@?username=%@&password=%@",urlString,username,password];
    for (id key in [params allKeys]) {
        urlString = [NSString stringWithFormat:@"%@&%@=%@",urlString,key,params[key]];
    }
    NSURL *url = [NSURL URLWithString:urlString];
    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        NSDictionary *responseDict = [responseString JSONValue];
        [self performSelector:succeedSelector withObject:responseDict withObject:cl];

    }];
    [request setFailedBlock:^{
        [self performSelector:failSelector withObject:cl];
    }];
    [request startAsynchronous];
}

- (void)putURL:(NSString*)urlString parameters:(NSDictionary*)params succeedSelector:(SEL)succeedSelector
        failSelector:(SEL) failSelector closure:(NSDictionary*)cl; {
    NSURL *url = [NSURL URLWithString:urlString];
    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    NSString *paramString = [NSString stringWithFormat:@"username=%@&password=%@",username,password];
    for (id key in [params allKeys]) {
        paramString = [NSString stringWithFormat:@"%@&%@=%@",paramString,key,params[key]];
    }
    [request appendPostData:[paramString dataUsingEncoding:NSUTF8StringEncoding]];
    [request setRequestMethod:@"PUT"];
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        NSDictionary *responseDict = [responseString JSONValue];
        [self performSelector:succeedSelector withObject:responseDict withObject:cl];
    }];
    [request setFailedBlock:^{
        [self performSelector:failSelector withObject:cl];
    }];
    [request startAsynchronous];
}

- (void) requestToAddUserDidSucceedWithResponse:(NSDictionary*)response closure:(NSDictionary*)cl {
    NSDictionary *user = response[@"objects"][0];
    [cl[@"delegate"] performSelector:@selector(createUserDidSucceedWithUser:) withObject:user];
}

- (void) requestToAddUserDidFailWithClosure:(NSDictionary*)cl {
    [cl[@"delegate"] performSelector:@selector(createUserDidFail)];
}

- (void) createUserWithUsername:(NSString *)uname email:(NSString*)uemail password:(NSString*)upassword
                   withDelegate:(NSObject<CreateUserDelegate>*) delegate {
    username = uname;
    password = upassword;
    NSDictionary *params = @{@"email":uemail};
    NSDictionary *cl = @{@"delegate":delegate};
    [self putURL:USER_EXT parameters:params succeedSelector:@selector(requestToAddUserDidSucceedWithResponse:closure:)
    failSelector:@selector(requestToAddUserDidFailWithClosure:) closure:cl];
}

- (void) requestToLoginDidSucceedWithResponse:(NSDictionary*)response closure:(NSDictionary*)cl {
    NSDictionary *user = response[@"objects"][0];
    [cl[@"delegate"] performSelector:@selector(loginDidSucceedWithUser:) withObject:user];
}

- (void) requestToLoginDidFailWithClosure:(NSDictionary*)cl {
    [cl[@"delegate"] performSelector:@selector(loginDidFail)];
}


- (void) loginWithUsername:(NSString *)uname password:(NSString *)upassword withDelegate:(NSObject <LoginDelegate>*)delegate {
    username = uname;
    password = upassword;
    NSDictionary *cl = @{@"delegate":delegate};
    [self putURL:USER_EXT parameters:nil succeedSelector:@selector(requestToLoginDidSucceedWithResponse:closure:)
    failSelector:@selector(requestToLoginDidFailWithClosure:) closure:cl];
}

- (void) addSong:(Song *)song withDelegate:(NSObject<AddSongDelegate> *)delegate {
    NSDictionary *params = [song asDictionary];
    NSDictionary *cl = @{@"delegate":delegate};
    [self putURL:SONG_EXT parameters:params succeedSelector:@selector(requestToAddSongDidSucceedWithResponse:closure:)
          failSelector:@selector(requestToAddSongDidFailWithClosure:) closure:cl];
}

- (void) requestToAddSongDidSucceedWithResponse:(NSDictionary*)response closure:(NSDictionary*)cl {
    NSDictionary *song = response[@"objects"][0];
    Song *toReturn = [[Song alloc] initWithTitle:song[@"title"] artist:song[@"artist"] album:song[@"album"] providerSongID:song[@"provider_song_id"] providerKey:song[@"provider_key"]];
    toReturn.songID = [song[@"id"] intValue];
    [cl[@"delegate"] performSelector:@selector(addSongDidSucceedWithSong:) withObject:song];
}

- (void) requestToAddSongDidFailWithClosure:(NSDictionary *)cl {
    [cl[@"delegate"] performSelector:@selector(addSongDidFail)];
}

- (void) addBlipWithSong:(Song *)song atLocation:(GeoPoint)point withDelegate:(NSObject <AddBlipDelegate>*)delegate {
    NSDictionary *params = @{@"song_id":@(song.songID),@"latitude":@(point.lat),@"longitude":@(point.lng),@"user_id":@(userID)};
    NSDictionary *cl = @{@"delegate":delegate};
    [self putURL:BLIP_EXT parameters:params succeedSelector:@selector(requestToAddBlipDidSucceedWithResponse:closure:) failSelector:@selector(requestToAddBlipDidFailWithClosure:) closure:cl];
}

- (void) getBlipsWithDelegate:(NSObject<GetBlipsDelegate> *)delegate {
    NSDictionary *cl = @{@"delegate":delegate};
    [self getURL:BLIP_EXT parameters:nil succeedSelector:@selector(requestToAddBlipDidSucceedWithResponse:closure:) failSelector:@selector(requestToAddBlipDidFailWithClosure:) closure:cl];
}

- (void) requestToAddBlipDidSucceedWithResponse:(NSDictionary*)response closure:(NSDictionary*)cl {
    NSDictionary *blip = response[@"objects"][0];
    Blip *toReturn = [[Blip alloc] init];
    toReturn.userID = [blip[@"user_id"] intValue];
    NSDictionary *song = blip[@"song"];
    toReturn.song = [[Song alloc] initWithTitle:song[@"title"]
                                         artist:song[@"artist"]
                                          album:song[@"album"]
                                 providerSongID:song[@"provider_song_id"]
                                    providerKey:song[@"provider_key"]];
    toReturn.song.songID = [song[@"id"] intValue];
    toReturn.userID = [blip[@"user_id"] intValue];
    toReturn.timestamp = nil;
    GeoPoint location;
    location.lat = [blip[@"latitude"] floatValue];
    location.lng = [blip[@"longitude"] floatValue];
    toReturn.location = location;
    [cl[@"delegate"] performSelector:@selector(addBlipDidSucceedWithBlip:) withObject:toReturn];
}

- (void) requestToAddBlipDidFailWithClosure:(NSDictionary *)cl {
    [cl[@"delegate"] performSelector:@selector(addBlipDidFail)];
}

- (void) requestToGetBlipsDidSucceedWithResponse:(NSDictionary*)response closure:(NSDictionary*)cl {
    NSDictionary *blips = response[@"objects"];
    NSMutableArray *toReturn = [[NSMutableArray alloc] init];
    for (NSDictionary *blip in blips) {
        Blip *blipObj = [[Blip alloc] init];
        blipObj.userID = [blip[@"user_id"] intValue];
        NSDictionary *song = blip[@"song"];
        blipObj.song = [[Song alloc] initWithTitle:song[@"title"]
                                             artist:song[@"artist"]
                                              album:song[@"album"]
                                     providerSongID:song[@"provider_song_id"]
                                        providerKey:song[@"provider_key"]];
        blipObj.song.songID = [song[@"id"] intValue];
        blipObj.userID = [blip[@"user_id"] intValue];
        blipObj.timestamp = nil;
        GeoPoint location;
        location.lat = [blip[@"latitude"] floatValue];
        location.lng = [blip[@"longitude"] floatValue];
        blipObj.location = location;
        [toReturn addObject:blipObj];
    }
    [cl[@"delegate"] performSelector:@selector(getBlipsDidSucceedWithBlips:) withObject:toReturn];
}

- (void) getBlipsNearLocation:(GeoPoint)location withDelegate:(NSObject<GetBlipsDelegate>*)delegate {
    NSDictionary *params = @{@"latitude":@(location.lat),@"longitude":@(location.lng)};
    NSDictionary *cl = @{@"delegate":delegate};
    [self getURL:BLIP_EXT parameters:params succeedSelector:@selector(requestToAddBlipDidSucceedWithResponse:closure:) failSelector:@selector(requestToAddBlipDidFailWithClosure:) closure:cl];
}

- (void) getBlipWithID:(NSInteger)blipID withDelegate:(NSObject<GetBlipsDelegate> *)delegate {
    NSDictionary *params = @{@"id":@(blipID)};
    NSDictionary *cl = @{@"delegate":delegate};
    [self getURL:BLIP_EXT parameters:params succeedSelector:@selector(requestToAddBlipDidSucceedWithResponse:closure:) failSelector:@selector(requestToAddBlipDidFailWithClosure:) closure:cl];
}


@end
