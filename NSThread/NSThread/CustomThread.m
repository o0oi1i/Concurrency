//
//  CustomThread.m
//  NSThread
//
//  Created by o0oi1i on 2023/12/4.
//

#import "CustomThread.h"

@implementation CustomThread

- (void)main
{
    NSLog(@"Custom Thread %@", [NSThread currentThread]);
    @autoreleasepool {
        [[NSRunLoop currentRunLoop] runMode:NSDefaultRunLoopMode
                                 beforeDate:[NSDate distantFuture]];
    }
}

- (void)task
{
    sleep(3);
    NSLog(@"task currentThread: %@ isMultiThreaded:%d callStackSymbols:%@ isMainThread:%d threadPriority:%f isExecuting:%d isFinished:%d isCancelled:%d",
          [NSThread currentThread],
          [NSThread isMultiThreaded],
          [NSThread callStackSymbols],
          [NSThread isMainThread],
          [NSThread threadPriority],
          [[NSThread currentThread] isExecuting],
          [[NSThread currentThread] isFinished],
          [[NSThread currentThread] isCancelled]);
}

- (void)task1
{
    sleep(3);
    NSLog(@"task1 %@", [NSThread currentThread]);
}

@end
