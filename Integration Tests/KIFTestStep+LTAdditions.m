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
#import "LTCommunication.h"
#import "SSKeychain.h"

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

+ (id) stepToCheckIfBlipIsPresentWithSongNamed:(NSString *)name inRow:(NSInteger)row{
  return [KIFTestStep stepWithDescription:@"Check for blip in row" executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError *__autoreleasing *error) {
    if ([[UIApplication sharedApplication] accessibilityElementWithLabel:@"Blip Table"] == nil) {
      return KIFTestStepResultFailure;
    } else {
      UIAccessibilityElement *tableElem = [[UIApplication sharedApplication] accessibilityElementWithLabel:@"Blip Table"];
      UITableView *tableView = (UITableView*)[UIAccessibilityElement viewContainingAccessibilityElement:tableElem];
      UITableViewCell *tableCell = [tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
      if ([tableCell.accessibilityLabel isEqualToString:name]) {
        return KIFTestStepResultSuccess;
      } else {
        return KIFTestStepResultFailure;
      }
    }
  }];
}

+ (id) stepToResetKeychain {
  return [KIFTestStep stepWithDescription:@"Reset Keychain" executionBlock:^KIFTestStepResult(KIFTestStep *step, NSError *__autoreleasing *error) {
    for (NSDictionary *account in [SSKeychain accountsForService:@"latitune"]) {
      NSLog(@"%@",account);
      [SSKeychain deletePasswordForService:@"latitune" account:account[@"acct"]];
    }
    return KIFTestStepResultSuccess;
  }];
}

#pragma mark - Automators

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

+ (id) stepsToLoginUserWithUsername:(NSString *)username password:(NSString *)password {
  return @[
    [KIFTestStep stepToTapViewWithAccessibilityLabel:@"Login Button"],
    [KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Login View"],
    [KIFTestStep stepToEnterText:username intoViewWithAccessibilityLabel:@"Username field"],
    [KIFTestStep stepToEnterText:password intoViewWithAccessibilityLabel:@"Password field"],
    [KIFTestStep stepToTapViewWithAccessibilityLabel:@"Login Submit Button"],
    [KIFTestStep stepToWaitForViewWithAccessibilityLabel:@"Main View"]
  ];
}

#pragma mark - Generators

+ (id) stepToGenerateDefaultUser{
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
      if ([responseDict[@"meta"][@"status"] isEqualToNumber:@(Success)]){
        return KIFTestStepResultSuccess;
      }
    }
    return KIFTestStepResultFailure;
  }];
}

+ (id) stepToGenerateDefaultSong{
  return [KIFTestStep stepWithDescription:@"Create default song" executionBlock:^(KIFTestStep *step, NSError **error) {
    NSURL *url = [NSURL URLWithString:SONG_EXT];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:@"The Kinks" forKey:@"artist"];
    [request setPostValue:@"Big Sky" forKey:@"title"];
    [request setRequestMethod:@"PUT"];
    [request startSynchronous];
    NSError *err = [request error];
    if (!err) {
      NSString *response = [request responseString];
      NSDictionary *responseDict = [response JSONValue];
      if ([responseDict[@"meta"][@"status"] isEqualToNumber:@(Success)]){
        return KIFTestStepResultSuccess;
      }
    }
    return KIFTestStepResultFailure;
  }];
}

+ (id) stepToGenerateDefaultBlip{
  return [KIFTestStep stepWithDescription:@"Create default blip" executionBlock:^(KIFTestStep *step, NSError **error) {
    NSURL *url = [NSURL URLWithString:BLIP_EXT];
    ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    [request setPostValue:@"1" forKey:@"user_id"];
    [request setPostValue:@"1" forKey:@"song_id"];
    // set to center of Boston for relative distance testing
    [request setPostValue:@"-71.059721" forKey:@"longitude"];
    [request setPostValue:@"42.359625"  forKey:@"latitude"];
    [request setPostValue:@"testpass"   forKey:@"password"];
    
    [request setRequestMethod:@"PUT"];
    [request startSynchronous];
    NSError *err = [request error];
    if (!err) {
      NSString *response = [request responseString];
      NSDictionary *responseDict = [response JSONValue];
      if ([responseDict[@"meta"][@"status"] isEqualToNumber:@(Success)]){
        return KIFTestStepResultSuccess;
      }
    }
    return KIFTestStepResultFailure;
  }];
}

@end
