//
//  KIFTestStepAsync.h
//  WhatsOn
//
//  Created by Dmitry Jerusalimsky on 7/16/12.
//  Copyright (c) 2012 Comcast. All rights reserved.
//

#import "KIFTestStep.h"


/*!
 @define KIFTestAsyncWaitCondition
 @abstract Tests a condition and returns a wait result if the condition isn't true, as well as sending an async signal to wait.
 @discussion This is a useful macro for quickly evaluating conditions in a test step that spawns an asynchronous process. If the condition is false then the current test step will be aborted with a wait result, and it will continuously return a wait result without executing the step's block until it either times out or receives another signal from the asynchronous process.
 @param condition The condition to test.
 @param error The NSError object to put the error string into. May be nil, but should usually be the error parameter from the test step execution block.
 @param ... A string describing why the step needs to wait. This is important since this reason will be considered the cause of a timeout error if the step requires waiting for too long. This may be a format string with additional arguments.
 */
#define KIFTestAsyncWaitCondition(condition, error, ...) ({ \
    if (!(condition)) { \
        if (error) { \
            *error = [[[NSError alloc] initWithDomain:@"KIFTest" code:KIFTestStepResultWait userInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:__VA_ARGS__], NSLocalizedDescriptionKey, nil]] autorelease]; \
            [(KIFTestStepAsync*)step asyncWaitWithError:*error]; \
        } \
        return KIFTestStepResultWait; \
    } \
})

@interface KIFTestStepAsync : KIFTestStep

/*!
 @method asyncSucceed:
 @abstract Override a currently waiting step to return a successful result on next execution attempt.
 @discussion This method allows asynchronous processes started by a step to signal success.
 */
- (void)asyncSucceed;

/*!
 @method asyncFailWithError:
 @abstract Override a currently waiting step to return a failing result on next execution attempt.
 @discussion This method allows asynchronous processes started by a step to signal failure.
 @param error The error corresponding to the failure.
 */
- (void)asyncFailWithError:(NSError *)error;

/*!
 @method asyncWaitWithError:
 @abstract Override a currently waiting step to wait until another async signal is sent.
 @discussion This method allows an asynchronous processes to make a step wait until it can finish.
 @param error The error identifying the reason for waiting.
 */
- (void)asyncWaitWithError:(NSError *)error;

@end
