//
//  KIFTestScenario+LTAdditions.h
//  
//
//  Created by Marshall Moutenot on 11/15/12.
//
//

#import "KIFTestScenario.h"

@interface KIFTestScenario (LTAdditions)

+ (id)scenarioTrue;

// Registration Tests
+ (id)scenarioToRegisterUserWithValidData;
+ (id)scenarioToRegisterUserWithInvalidEmail;
+ (id)scenarioToRegisterUserWithInvalidPasswords;
+ (id)scenarioToRegisterUserWithEmptyFields;
+ (id)scenarioToRegisterUserWithExistingAccount;

// Main Screen Tests
+ (id)scenarioToLoadNearbyBlips;

//Login Tests
+ (id)scenarioToLogIn;
+ (id)scenarioToLogInWithInvalidPassword;
+ (id)scenarioToLogInWithInvalidUsername;
+ (id)scenarioToLogInWithEmptyFields;

@end
