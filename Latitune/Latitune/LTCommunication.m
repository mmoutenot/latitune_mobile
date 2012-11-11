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

- (void)getURL:(NSString*)urlString parameters:(NSDictionary*)params selector:(SEL)selector delegate:(id)delegate {
    urlString = [NSString stringWithFormat:@"%@?username=%@&password=%@",urlString,username,password];
    for (id key in [params allKeys]) {
        urlString = [NSString stringWithFormat:@"%@&%@=%@",urlString,key,params[key]];
    }
    NSURL *url = [NSURL URLWithString:urlString];
    __weak ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request setCompletionBlock:^{
        NSString *responseString = [request responseString];
        NSDictionary *responseDict = [responseString JSONValue];
        [self performSelector:selector withObject:responseDict];
    }];
    [request startAsynchronous];
}

- (void)putURL:(NSString*)urlString parameters:(NSDictionary*)params selector:(SEL)selector closure:(NSDictionary*)cl; {
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
        [self performSelector:selector withObject:responseDict withObject:cl];
    }];
    [request startAsynchronous];
}

- (void) addSong:(Song *)song withDelegate:(NSObject<AddSongDelegate> *)delegate {
    NSDictionary *params = [song asDictionary];
    NSDictionary *cl = @{@"delegate":delegate};
    [self putURL:SONG_EXT parameters:params selector:@selector(addSongDidSucceedWithSong:) closure:cl];
}

- (void) requestToAddSongDidSucceedWithResponse:(NSDictionary*)response closure:(NSDictionary*)cl {
    NSDictionary *song = response[@"objects"][0];
    Song *toReturn = [[Song alloc] initWithTitle:song[@"title"] artist:song[@"artist"] album:song[@"album"] providerSongID:song[@"provider_song_id"] providerKey:song[@"provider_key"]];
    toReturn.songID = [song[@"id"] intValue];
    [cl[@"delegate"] performSelector:@selector(addSongDidSucceedWithSong:) withObject:song];
}
                                                              

@end
