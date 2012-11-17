//
//  KIFTestScenario+LTAdditions.m
//  
//
//  Created by Marshall Moutenot on 11/15/12.
//
//

#import "KIFTestScenario+LTAdditions.h"
#import "KIFTestStep.h"

@implementation KIFTestScenario (LTAdditions)

+ (id) scenarioToChangeTabs {
  KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Test that a user can change tabs"];
  NSLog(@"testing");
  [scenario addStep:[KIFTestStep stepToSimulateMemoryWarning]];
  /*[scenario addStep:[KIFTestStep stepToReset]];
  [scenario addStep:[KIFTestStep stepToSelectTabNamed:@"Explore"]];
  [scenario addStep:[KIFTestStep stepToSelectTabNamed:@"Listen"]];
  [scenario addStep:[KIFTestStep stepToSelectTabNamed:@"Blip"]];*/
  
  return scenario;
}

@end
