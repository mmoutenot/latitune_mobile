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

+ (id) stepToCreateDefaultUser;


@end
