//
//  KIFTestStep+EXAdditions.h
//  Latitune
//
//  Created by Marshall Moutenot on 11/15/12.
//  Copyright (c) 2012 Ben Weitzman. All rights reserved.
//

#import "KIFTestStep.h"

@interface KIFTestStep (EXAdditions)

+ (id) stepToResetDatabase;
+ (id) stepToShowAuthenticationWindow;
+ (id) stepToResetKeychain;

+ (id) stepsToRegisterUserWithUsername:(NSString *)username email:(NSString*) email passwordA:(NSString *)passwordA passwordB:(NSString *)passwordB;
+ (id) stepsToLoginUserWithUsername:(NSString *)username password:(NSString *)password;

+ (id) stepToCheckIfBlipIsPresentWithSongNamed:(NSString *)name inRow:(NSInteger)row;

// Generators
+ (id) stepToGenerateDefaultUser;
+ (id) stepToGenerateDefaultSong;
+ (id) stepToGenerateDefaultBlip;

// Utility

@end
