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

+ (id)scenarioToRegisterUserWithValidData;
+ (id)scenarioToRegisterUserWithInvalidEmail;
+ (id)scenarioToRegisterUserWithInvalidPasswords;
+ (id)scenarioToRegisterUserWithEmptyFields;
+ (id)scenarioToRegisterUserWithExistingAccount;


+ (id)scenarioToLogIn;

@end
