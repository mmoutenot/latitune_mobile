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

+ (id) scenarioTrue{
  KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Always Succeed"];
  [scenario addStep:[KIFTestStep stepThatSucceeds]];
  return scenario;
}

+ (id) scenarioToRegisterUser{
  KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Register User"];
  [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Register Button"]];
  [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Register View"]];
  [scenario addStep:[KIFTestStep stepToEnterText:@"testuser" intoViewWithAccessibilityLabel:@"Username field"]];
  [scenario addStep:[KIFTestStep stepToEnterText:@"testuser@gmail.com" intoViewWithAccessibilityLabel:@"Email field"]];
  [scenario addStep:[KIFTestStep stepToEnterText:@"testpass" intoViewWithAccessibilityLabel:@"Password field"]];
  [scenario addStep:[KIFTestStep stepToEnterText:@"testpass" intoViewWithAccessibilityLabel:@"Password Again field"]];
  [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Register Submit Button"]];
  [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Instructions View"]];
  return scenario;
}

@end
