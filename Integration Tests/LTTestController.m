//
//  LTTestController.m
//  Latitune
//
//  Created by Marshall Moutenot on 11/15/12.
//  Copyright (c) 2012 Ben Weitzman. All rights reserved.
//

#import "LTTestController.h"
#import "KIFTestScenario+LTAdditions.h"

@implementation LTTestController

- (void)initializeScenarios;
{
  [self addScenario:[KIFTestScenario scenarioToChangeTabs]];
}

@end
