//
//  KIFTestStep+EXAdditions.m
//  Latitune
//
//  Created by Marshall Moutenot on 11/15/12.
//  Copyright (c) 2012 Ben Weitzman. All rights reserved.
//

#import "KIFTestStep+EXAdditions.h"

@implementation KIFTestStep (EXAdditions)

+ (id) stepToSelectTabNamed:(NSString *) tabName{
  return [KIFTestStep stepWithDescription:@"Change tabs to tab named tabName" executionBlock:^(KIFTestStep *step, NSError **error) {
    BOOL successfulTabSelection = NO;
    
    // Do the actual reset for your app. Set successfulReset = NO if it fails.
    
    KIFTestCondition(successfulTabSelection, error, @"Failed to change tabs to %@.", tabName);
    
    return KIFTestStepResultSuccess;
  }];
}

@end
