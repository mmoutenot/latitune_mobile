//
//  KIFTestStepAsync.m
//  WhatsOn
//
//  Created by Dmitry Jerusalimsky on 7/16/12.
//  Copyright (c) 2012 Comcast. All rights reserved.
//

#import "KIFTestStepAsync.h"

enum {
	KIFTestStepAsyncSignalFailure = KIFTestStepResultFailure,
	KIFTestStepAsyncSignalSuccess,
	KIFtestStepAsyncSignalWait,
	KIFTestStepAsyncSignalNone,
};
typedef NSInteger KIFTestStepAsyncSignal;

@interface KIFTestStepAsync ()

@property (nonatomic, retain) NSError *asyncError;
@property KIFTestStepAsyncSignal asyncSignal;

@end


@implementation KIFTestStepAsync
@synthesize asyncError;
@synthesize asyncSignal;

- (id)init;
{
    self = [super init];
    if (self) {
        self.asyncSignal = KIFTestStepAsyncSignalNone;
    }

    return self;
}

- (void)dealloc;
{
    [self.asyncError release];
	self.asyncError = nil;
    
    [super dealloc];
}

- (KIFTestStepResult)executeAndReturnError:(NSError **)error;
{    
    KIFTestStepResult result = KIFTestStepResultFailure;
    
    if (executionBlock) {
		if (self.asyncSignal == KIFTestStepAsyncSignalNone) {
			@try {
				result = executionBlock(self, error);
			}
			@catch (id exception) {
				// We need to catch exceptions and things like NSInternalInconsistencyException, which is actually an NSString
				KIFTestCondition(NO, error, @"Step threw exception: %@", exception);
			}
		} else {
			result = self.asyncSignal;
			if (self.asyncError) {
				*error = [[self.asyncError copy] autorelease];
			}
		}
    }
    
    return result;
}

- (void)asyncSucceed;
{
	self.asyncSignal = KIFTestStepAsyncSignalSuccess;
}

- (void)asyncFailWithError:(NSError *)error
{
	self.asyncSignal = KIFTestStepAsyncSignalFailure;
	self.asyncError = error;
}

- (void)asyncWaitWithError:(NSError *)error
{
	self.asyncSignal = KIFtestStepAsyncSignalWait;
	self.asyncError = error;
}

@end
