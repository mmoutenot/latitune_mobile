//
//  KIFTestScenario+LTAdditions.m
//  
//
//  Created by Marshall Moutenot on 11/15/12.
//
//

#import "KIFTestScenario+LTAdditions.h"
#import "KIFTestStep.h"
#import "KIFTestStep+LTAdditions.h"

@implementation KIFTestScenario (LTAdditions)

+ (id) scenarioTrue{
  KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Always Succeed"];
  [scenario addStep:[KIFTestStep stepThatSucceeds]];
  return scenario;
}

#pragma mark - Register Scenarios

+ (id) scenarioToRegisterUserWithValidData{
  KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Register User With Valid Data"];
  [scenario addStepsFromArray:[KIFTestStep stepsToRegisterUserWithUsername:@"testuser" email:@"mmoutenot@gmail.com" passwordA:@"testpass" passwordB:@"testpass"]];
  [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Register Submit Button"]];
  [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Instructions View"]];
  [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Close Instructions Button"]];
  return scenario;
}

+ (id) scenarioToRegisterUserWithInvalidEmail{
  KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Register User With Invalid Email"];
  NSArray *invalidEmails = @[@"test@.com", @"test@gmail", @"test", @"test@g."];
  for (NSString *invalidEmail in invalidEmails) {
    [scenario addStepsFromArray:[KIFTestStep stepsToRegisterUserWithUsername:@"testuser" email:invalidEmail passwordA:@"testpass" passwordB:@"testpass"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Register Submit Button"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Invalid Email"]];
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"Invalid Email"]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Register View"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Authenticate"]];
  }
  return scenario;
}

+ (id) scenarioToRegisterUserWithInvalidPasswords{
  KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Register User With Invalid Passwords"];
  [scenario addStepsFromArray:[KIFTestStep stepsToRegisterUserWithUsername:@"testuser" email:@"testuser@gmail.com" passwordA:@"testpass123" passwordB:@"testpass"]];
  [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Register Submit Button"]];
  [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Passwords Don't Match"]];
  [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"Passwords Don't Match"]];
  [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Register View"]];
  [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Authenticate"]];
  return scenario;
}

+ (id) scenarioToRegisterUserWithEmptyFields {
  KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Register User With Empty Fields"];
  NSArray *fieldDicts = @[
  @{@"username":@"",@"email":@"testuser@gmail.com",@"passwordA":@"testpass",@"passwordB":@"testpass",@"error":@"Username field is empty"},
  @{@"username":@"testuser",@"email":@"",@"passwordA":@"testpass",@"passwordB":@"testpass",@"error":@"Email field is empty"},
  @{@"username":@"testuser",@"email":@"testuser@gmail.com",@"passwordA":@"",@"passwordB":@"testpass",@"error":@"Password field is empty"},
  @{@"username":@"testuser",@"email":@"testuser@gmail.com",@"passwordA":@"testpass",@"passwordB":@"",@"error":@"Passwords Don't Match"}
  ];
  for (NSDictionary *fieldDict in fieldDicts) {
    [scenario addStepsFromArray:[KIFTestStep stepsToRegisterUserWithUsername:fieldDict[@"username"]
                                                                       email:fieldDict[@"email"]
                                                                   passwordA:fieldDict[@"passwordA"]
                                                                   passwordB:fieldDict[@"passwordB"]]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Register Submit Button"]];
    NSString *errorText = fieldDict[@"error"];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:errorText]];
    [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:errorText]];
    [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Register View"]];
    [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Authenticate"]];
  }
  return scenario;
}

+ (id) scenarioToRegisterUserWithExistingAccount {
  KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Register User With Existing Account"];
  [scenario addStep:[KIFTestStep stepToGenerateDefaultUser]];
  [scenario addStepsFromArray:[KIFTestStep stepsToRegisterUserWithUsername:@"testuser2" email:@"testuser@gmail.com" passwordA:@"testpass" passwordB:@"testpass"]];
  [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Register Submit Button"]];
  [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Email already exists"]];
  [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"Email already exists"]];
  [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Register View"]];
  [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Authenticate"]];
  [scenario addStepsFromArray:[KIFTestStep stepsToRegisterUserWithUsername:@"testuser" email:@"testuser2@gmail.com" passwordA:@"testpass" passwordB:@"testpass"]];
  [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Register Submit Button"]];
  [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Username already exists"]];
  [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"Username already exists"]];
  [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Register View"]];
  [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Authenticate"]];
  return scenario;
}

#pragma mark - Login Scenarios

+ (id) scenarioToLogIn {
  KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Login User"];
  [scenario addStep:[KIFTestStep stepToGenerateDefaultUser]];
  [scenario addStepsFromArray:[KIFTestStep stepsToLoginUserWithUsername:@"testuser" password:@"testpass"]];
  return scenario;
}

+ (id) scenarioToLogInWithInvalidPassword {
  KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Login with invalid password"];
  [scenario addStep:[KIFTestStep stepToGenerateDefaultUser]];
  [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Login Button"]];
  [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Login View"]];
  [scenario addStep:[KIFTestStep stepToEnterText:@"testuser" intoViewWithAccessibilityLabel:@"Username field"]];
  [scenario addStep:[KIFTestStep stepToEnterText:@"testpass123" intoViewWithAccessibilityLabel:@"Password field"]];
  [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Login Submit Button"]];
  [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Incorrect Password"]];
  [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"Incorrect Password"]];
  [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Login View"]];
  [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Authenticate"]];
  return scenario;
}

+ (id) scenarioToLogInWithInvalidUsername {
  KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Login with invalid username"];
  [scenario addStep:[KIFTestStep stepToGenerateDefaultUser]];
  [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Login Button"]];
  [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Login View"]];
  [scenario addStep:[KIFTestStep stepToEnterText:@"testuser123" intoViewWithAccessibilityLabel:@"Username field"]];
  [scenario addStep:[KIFTestStep stepToEnterText:@"testpass" intoViewWithAccessibilityLabel:@"Password field"]];
  [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Login Submit Button"]];
  [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Username Does Not Exist"]];
  [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"Username Does Not Exist"]];
  [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Login View"]];
  [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Authenticate"]];
  return scenario;
}

+ (id) scenarioToLogInWithEmptyFields {
  KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Login with blank fields"];
  [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Login Button"]];
  [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Login View"]];
  [scenario addStep:[KIFTestStep stepToEnterText:@"" intoViewWithAccessibilityLabel:@"Username field"]];
  [scenario addStep:[KIFTestStep stepToEnterText:@"testpass" intoViewWithAccessibilityLabel:@"Password field"]];
  [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Login Submit Button"]];
  [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Username Field Is Blank"]];
  [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"Username Field Is Blank"]];
  [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Login View"]];
  [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Authenticate"]];
  [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Login Button"]];
  [scenario addStep:[KIFTestStep stepToEnterText:@"testuser" intoViewWithAccessibilityLabel:@"Username field"]];
  [scenario addStep:[KIFTestStep stepToEnterText:@"" intoViewWithAccessibilityLabel:@"Password field"]];
  [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Login Submit Button"]];
  [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Password Field Is Blank"]];
  [scenario addStep:[KIFTestStep stepToWaitForAbsenceOfViewWithAccessibilityLabel:@"Password Field is Blank"]];
  [scenario addStep:[KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Login View"]];
  [scenario addStep:[KIFTestStep stepToTapViewWithAccessibilityLabel:@"Authenticate"]];
  return scenario;
}

#pragma mark - Main Screen Tests

+ (id) scenarioToLoadNearbyBlips {
  KIFTestScenario *scenario = [KIFTestScenario scenarioWithDescription:@"Load Nearby Blips"];
  [scenario addStep:[KIFTestStep stepToGenerateDefaultUser]];
  [scenario addStep:[KIFTestStep stepToGenerateDefaultSong]];
  [scenario addStep:[KIFTestStep stepToGenerateDefaultBlip]];
  [scenario addStepsFromArray:[KIFTestStep stepsToLoginUserWithUsername:@"testuser" password:@"testpass"]];
  [scenario addStep:[KIFTestStep stepToCheckIfBlipIsPresentWithSongNamed:@"Big Sky by The Kinks" inRow:0]];
  return scenario;
}

@end
