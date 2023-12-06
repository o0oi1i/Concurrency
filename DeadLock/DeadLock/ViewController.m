//
//  ViewController.m
//  DeadLock
//
//  Created by o0oi1i on 2023/12/6.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self deadLock2];
}

- (void)deadLock
{
    NSLog(@"Start %@", [NSThread currentThread]);
    dispatch_sync(dispatch_get_main_queue(), ^{
        NSLog(@"Task %@", [NSThread currentThread]);
    });
    NSLog(@"End %@", [NSThread currentThread]);
}

- (void)deadLock1
{
    NSLog(@"Start %@", [NSThread currentThread]);
    dispatch_queue_t queue = dispatch_queue_create("queue", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
        NSLog(@"Start 1 %@", [NSThread currentThread]);
        dispatch_sync(dispatch_get_main_queue(), ^{
            NSLog(@"Task %@", [NSThread currentThread]);
        });
        NSLog(@"End 1 %@", [NSThread currentThread]);
    });
    NSLog(@"End %@", [NSThread currentThread]);
}

- (void)deadLock2
{
    NSLog(@"Start %@", [NSThread currentThread]);
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_async(group, dispatch_get_main_queue(), ^{
        NSLog(@"Task %@", [NSThread currentThread]);
    });
    dispatch_group_wait(group, DISPATCH_TIME_FOREVER); 
    NSLog(@"End %@", [NSThread currentThread]);
}

@end
