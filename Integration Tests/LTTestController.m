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
  NSArray *setUpSteps = @[[KIFTestStep stepToResetDatabase]];
  [KIFTestScenario setDefaultStepsToSetUp:setUpSteps];
  [self addScenario:[KIFTestScenario scenarioTrue]];
  [self addScenario:[KIFTestScenario scenarioToRegisterUser]];
}

@end
