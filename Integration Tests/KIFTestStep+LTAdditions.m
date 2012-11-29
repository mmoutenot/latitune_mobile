//
//  KIFTestStep+EXAdditions.m
//  Latitune
//
//  Created by Marshall Moutenot on 11/15/12.
//  Copyright (c) 2012 Ben Weitzman. All rights reserved.
//

#import "KIFTestStep+LTAdditions.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
#import "SBJson.h"
#import "UIAccessibilityElement-KIFAdditions.h"
#import "UIApplication-KIFAdditions.h"
#import "UIView-KIFAdditions.h"

@implementation KIFTestStep (EXAdditions)

+ (id) stepToResetDatabase {
  return [KIFTestStep stepWithDescription:@"Recreate database" executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError **error) {
    NSURL *url = [NSURL URLWithString:RASA_EXT];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSError *err = [request error];
    if (!err) {
      NSString *response = [request responseString];
      if ([response isEqualToString:@"OK"]){
        return KIFTestStepResultSuccess;
      }
    }
    return KIFTestStepResultFailure;
  }];
}

+ (id) stepToShowAuthenticationWindow {
  return [KIFTestStep stepWithDescription:@"Show Authentication Window" executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError *__autoreleasing *error) {
    if ([[UIApplication sharedApplication] accessibilityElementWithLabel:@"Authentication View"] != nil) {
      return KIFTestStepResultSuccess;
    } else {
      UIAccessibilityElement *logoutAccessibilityElement = [[UIApplication sharedApplication] accessibilityElementWithLabel:@"Logout Button"];
      UIView *logoutButton = [UIAccessibilityElement viewContainingAccessibilityElement:logoutAccessibilityElement];
      [logoutButton tap];
      return KIFTestStepResultSuccess;
    }
  }];
}

+ (id) stepsToRegisterUserWithUsername:(NSString *)username email:(NSString*) email passwordA:(NSString *)passwordA passwordB:(NSString *)passwordB{
  return @[
    [KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Authentication View"],
    [KIFTestStep stepToTapViewWithAccessibilityLabel:@"Register Button"],
    [KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Register View"],
    [KIFTestStep stepToEnterText:username intoViewWithAccessibilityLabel:@"Username field"],
    [KIFTestStep stepToEnterText:email intoViewWithAccessibilityLabel:@"Email field"],
    [KIFTestStep stepToEnterText:passwordA intoViewWithAccessibilityLabel:@"Password field"],
    [KIFTestStep stepToEnterText:passwordB intoViewWithAccessibilityLabel:@"Password Again field"]
  ];
}

+ (id) stepToCreateDefaultUser {
  return [KIFTestStep stepWithDescription:@"Create default user" executionBlock:^(KIFTestStep *step, NSError **error) {
    NSURL *url = [NSURL URLWithString:USER_EXT];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:@"testuser" forKey:@"username"];
    [request setPostValue:@"testpass" forKey:@"password"];
    [request setPostValue:@"testuser@gmail.com" forKey:@"email"];
    [request setRequestMethod:@"PUT"];
    [request startSynchronous];
    NSError *err = [request error];
    if (!err) {
      NSString *response = [request responseString];
      NSDictionary *responseDict = [response JSONValue];
      if ([responseDict[@"meta"][@"status"] isEqualToString:@"OK"]){
        return KIFTestStepResultSuccess;
      }
    }
    return KIFTestStepResultFailure;
  }];
}

@end
