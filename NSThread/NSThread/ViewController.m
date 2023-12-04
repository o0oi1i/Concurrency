//
//  ViewController.m
//  NSThread
//
//  Created by o0oi1i on 2023/12/4.
//

#import "ViewController.h"

#import "CustomThread.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self nsthread];
    [self notify];
    [self nsobject];
}

- (void)nsthread
{
    NSLog(@"%@", [NSThread currentThread]);
    // 匿名
    [NSThread detachNewThreadWithBlock:^{
        NSLog(@"%@", [NSThread currentThread]);
    }];
    
    [NSThread detachNewThreadSelector:@selector(task)
                             toTarget:self
                           withObject:nil];
    
    // 手动
    NSThread *thread = [[NSThread alloc] initWithBlock:^{
        NSLog(@"%@", [NSThread currentThread]);
    }];
    [thread start];
    
    NSThread *thread1 = [[NSThread alloc] initWithTarget:self
                                                selector:@selector(task1)
                                                  object:nil];
    [thread1 start];
    
    // 自定义
    CustomThread *customThread = [CustomThread new];
    [customThread start];
}

- (void)nsobject
{
    CustomThread *customThread = [CustomThread new];
    [customThread start];
    
    // 在主线程执行任务
//    [self performSelectorOnMainThread:@selector(task)
//                           withObject:nil
//                        waitUntilDone:YES
//                                modes:@[NSRunLoopCommonModes]];
//     NSLog(@"Wait Done");
//
//    [self performSelectorOnMainThread:@selector(task1)
//                           withObject:nil
//                        waitUntilDone:NO];
//     NSLog(@"Wait Done 1");

    // 在指定线程执行任务
    [self performSelector:@selector(task)
                 onThread:customThread
               withObject:nil
            waitUntilDone:YES
                    modes:@[NSRunLoopCommonModes]];
     NSLog(@"Wait Done");

//    [self performSelector:@selector(task1)
//                 onThread:customThread
//               withObject:nil
//            waitUntilDone:NO];
//     NSLog(@"Wait Done 1");

    // 在系统的后台线程中执行任务
//    [self performSelectorInBackground:@selector(task)
//                           withObject:nil];
}

- (void)notify
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(threadWillExitNotification:)
                                                 name:@"NSThreadWillExitNotification"
                                               object:nil];
}

- (void)task
{
    sleep(3);
    NSLog(@"task currentThread: %@ threadPriority:%f isMultiThreaded:%d isMainThread:%d isExecuting:%d isFinished:%d isCancelled:%d callStackSymbols:%@",
          [NSThread currentThread],
          [NSThread threadPriority],
          [NSThread isMultiThreaded],
          [NSThread isMainThread],
          [[NSThread currentThread] isExecuting],
          [[NSThread currentThread] isFinished],
          [[NSThread currentThread] isCancelled],
          [NSThread callStackSymbols]);
}

//- (void)task1
//{
//    NSLog(@"task1 %@", [NSThread currentThread]);
//}

- (void)threadWillExitNotification:(NSNotification *)notification
{
    NSLog(@"notification -> %@", notification);
}

@end
