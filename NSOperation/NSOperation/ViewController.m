//
//  ViewController.m
//  NSOperation
//
//  Created by o0oi1i on 2023/12/5.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    //    [self invocationOperation];
    //    [self blockOperation];
    //    [self operationQueue];
    [self operationQueue1];
}

- (void)invocationOperation
{
    NSInvocationOperation *invocationOperation =
  [[NSInvocationOperation alloc] initWithTarget:self
                                       selector:@selector(invocationOperationTask)
                                         object:nil];
   [invocationOperation start];
    NSLog(@"End");
}

- (void)invocationOperationTask
{
    NSLog(@"task %@", [NSThread currentThread]);
}

- (void)blockOperation
{
    NSBlockOperation *blockOperation =
   [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1];
         NSLog(@"blockOperation A:%@", [NSThread currentThread]);
    }];
    [blockOperation addExecutionBlock:^{
        [NSThread sleepForTimeInterval:2];
         NSLog(@"blockOperation B:%@", [NSThread currentThread]);
    }];
    [blockOperation addExecutionBlock:^{
        [NSThread sleepForTimeInterval:1];
         NSLog(@"blockOperation C:%@", [NSThread currentThread]);
    }];
    [blockOperation start];
     NSLog(@"End");
}

- (void)operationQueue
{
    NSBlockOperation *blockOperation =
   [NSBlockOperation blockOperationWithBlock:^{
        [NSThread sleepForTimeInterval:1];
         NSLog(@"blockOperation A:%@", [NSThread currentThread]);
   }];
   [blockOperation addExecutionBlock:^{
        [NSThread sleepForTimeInterval:2];
         NSLog(@"blockOperation B:%@", [NSThread currentThread]);
   }];
   [blockOperation addExecutionBlock:^{
        [NSThread sleepForTimeInterval:1];
         NSLog(@"blockOperation C:%@", [NSThread currentThread]);
   }];
    blockOperation.completionBlock = ^{
         NSLog(@"blockOperation Completion:%@", [NSThread currentThread]);
   };
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
   [queue addOperation:blockOperation];
    NSLog(@"End %@", [NSThread currentThread]);
}

- (void)operationQueue1
{
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"Operation Read A:%d:%@", i, [NSThread currentThread]);
        }
    }];
    [queue addBarrierBlock:^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"Operation Write D:%d:%@", i, [NSThread currentThread]);
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"Operation Read B:%d:%@", i, [NSThread currentThread]);
        }
    }];
    [queue addOperationWithBlock:^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"Operation Read C:%d:%@", i, [NSThread currentThread]);
        }
    }];
      NSLog(@"End %@", [NSThread currentThread]);
}

@end
