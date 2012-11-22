//
//  KIFTestStep+EXAdditions.m
//  Latitune
//
//  Created by Marshall Moutenot on 11/15/12.
//  Copyright (c) 2012 Ben Weitzman. All rights reserved.
//

#import "KIFTestStep+LTAdditions.h"
#import "ASIHTTPRequest.h"

@implementation KIFTestStep (EXAdditions)

+ (id) stepToResetDatabase {
  return [KIFTestStep stepWithDescription:@"Recreate database" executionBlock:^(KIFTestStep *step, NSError **error) {
    BOOL successfulReset = NO;
    
    NSURL *url = [NSURL URLWithString:RASA_EXT];
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
    [request startSynchronous];
    NSError *err = [request error];
    NSLog(@"%@", [request responseString]);
    if (!err) {
      NSString *response = [request responseString];
      if ([response isEqualToString:@"OK"]){
        return KIFTestStepResultSuccess;
      }
    }
    return KIFTestStepResultFailure;
  }];
}

@end
