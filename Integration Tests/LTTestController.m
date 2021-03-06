//
//  LTTestController.m
//  Latitune
//
//  Created by Marshall Moutenot on 11/15/12.
//  Copyright (c) 2012 Ben Weitzman. All rights reserved.
//

#import "LTTestController.h"
#import "KIFTestScenario+LTAdditions.h"
#import "KIFTestStep+LTAdditions.h"

@implementation LTTestController

- (void)initializeScenarios;
{
  NSArray *setUpSteps = @[[KIFTestStep stepToResetDatabase],[KIFTestStep stepToShowAuthenticationWindow],[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Authentication View"],[KIFTestStep stepToResetKeychain]];
  [KIFTestScenario setDefaultStepsToSetUp:setUpSteps];
  [self addScenario:[KIFTestScenario scenarioTrue]];
  [self addScenario:[KIFTestScenario scenarioToLogInWithEmptyFields]];
  [self addScenario:[KIFTestScenario scenarioToLogInWithInvalidUsername]];
  [self addScenario:[KIFTestScenario scenarioToLogInWithInvalidPassword]];
  [self addScenario:[KIFTestScenario scenarioToLoadNearbyBlips]];
  [self addScenario:[KIFTestScenario scenarioToRegisterUserWithExistingAccount]];
  [self addScenario:[KIFTestScenario scenarioToRegisterUserWithEmptyFields]];
  [self addScenario:[KIFTestScenario scenarioToRegisterUserWithValidData]];
  [self addScenario:[KIFTestScenario scenarioToRegisterUserWithInvalidEmail]];
  [self addScenario:[KIFTestScenario scenarioToRegisterUserWithInvalidPasswords]];
  [self addScenario:[KIFTestScenario scenarioToLogIn]];
}

@end
