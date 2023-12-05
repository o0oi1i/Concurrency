//
//  ViewController.m
//  GCD
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
    [self gcd9];
}

- (void)gcd
{
    dispatch_queue_t queue = dispatch_queue_create("myQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_sync(queue, ^{
        NSLog(@"%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"%@", [NSThread currentThread]);
    });
}

- (void)gcd1
{
    dispatch_queue_t queue1 = dispatch_queue_create("myQueue1", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t queue2 = dispatch_queue_create("myQueue2", DISPATCH_QUEUE_SERIAL);
    
    dispatch_group_t group  = dispatch_group_create();
    dispatch_group_async(group, queue1, ^{
        [NSThread sleepForTimeInterval:13];
         NSLog(@"Task A1 %@", [NSThread currentThread]);
    });
    
    dispatch_group_async(group, queue1, ^{
        [NSThread sleepForTimeInterval:1];
         NSLog(@"Task A2 %@", [NSThread currentThread]);
    });
    
    dispatch_group_async(group, queue2, ^{
        [NSThread sleepForTimeInterval:15];
         NSLog(@"Task B1 %@", [NSThread currentThread]);
    });
    
    dispatch_group_async(group, queue2, ^{
        [NSThread sleepForTimeInterval:1];
         NSLog(@"Task B2 %@", [NSThread currentThread]);
    });
    
    NSLog(@"currentThread %@", [NSThread currentThread]);

    dispatch_group_wait(group, DISPATCH_TIME_FOREVER);
    
    NSLog(@"Task C %@", [NSThread currentThread]);
}

- (void)gcd2
{
    dispatch_queue_t queue3 = dispatch_queue_create("myQueue3", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_group_t group  = dispatch_group_create();
    dispatch_group_async(group, queue3, ^{
        [NSThread sleepForTimeInterval:6];
         NSLog(@"Task G %@", [NSThread currentThread]);
    });
    
    dispatch_group_async(group, queue3, ^{
        [NSThread sleepForTimeInterval:4];
         NSLog(@"Task H %@", [NSThread currentThread]);
    });
    
    NSLog(@"currentThread %@", [NSThread currentThread]);

    dispatch_group_notify(group, queue3, ^{
        [NSThread sleepForTimeInterval:5];
         NSLog(@"Task I %@", [NSThread currentThread]);
    });
    
    NSLog(@"Task J %@", [NSThread currentThread]);
}

- (void)gcd3
{
    dispatch_queue_t queue5 = dispatch_queue_create("myQueue5", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_group_t group  = dispatch_group_create();
    
//    dispatch_group_enter(group);
    dispatch_group_async(group, queue5, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Async Task K %@", [NSThread currentThread]);
//            dispatch_group_leave(group);
        });
    });
    
    NSLog(@"currentThread %@", [NSThread currentThread]);

    dispatch_group_notify(group, queue5, ^{
         NSLog(@"Task L %@", [NSThread currentThread]);
    });
    
    NSLog(@"Task M %@", [NSThread currentThread]);
}

- (void)gcd4
{
    NSArray *ary = @[@"a",@"b",@"c",@"d",@"e",@"f",@"g",@"h",@"i"];
    dispatch_apply(ary.count, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(size_t iteration) {
        NSLog(@"%@||%zu:%@", [NSThread currentThread], iteration, ary[iteration]);
    });// 0.000028
    
    for (NSString *item in ary) {
        NSLog(@"%@", item);
    }// 0.001011
    
    NSLog(@"currentThread:%@", [NSThread currentThread]);
}

- (void)gcd5
{
    dispatch_source_t source_t = dispatch_source_create(DISPATCH_SOURCE_TYPE_DATA_ADD, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_event_handler(source_t, ^{
        NSLog(@"source_t:%lu", dispatch_source_get_data(source_t));
    });
    dispatch_resume(source_t);
    for (int i = 0; i < 10; i++) {
        dispatch_source_merge_data(source_t, i);
    }
}

- (void)gcd6
{
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue());
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 5 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"timer:%@", timer);
    });
    dispatch_resume(timer);
}

- (void)gcd7
{
    static int count = 1;
    dispatch_semaphore_t semaphore_t = dispatch_semaphore_create(0);
    dispatch_semaphore_signal(semaphore_t);
    while (1) {
        dispatch_semaphore_wait(semaphore_t, DISPATCH_TIME_FOREVER);
        NSLog(@"count:%d", count++);
    }
}

- (void)gcd8
{
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)),
                   dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSLog(@"Delay Task %@", [NSThread currentThread]);
    });
    NSLog(@"End %@", [NSThread currentThread]);
}

- (void)gcd9
{
    dispatch_queue_t queue = dispatch_queue_create("Queue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"currentThread:%@ Read Task A:%d", [NSThread currentThread], i);
        }
    });
    dispatch_barrier_sync(queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"currentThread:%@ Write Task:%d", [NSThread currentThread], i);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"currentThread:%@ Read Task B:%d", [NSThread currentThread], i);
        }
    });
    dispatch_async(queue, ^{
        for (int i = 0; i < 5; i++) {
            NSLog(@"currentThread:%@ Read Task C:%d", [NSThread currentThread], i);
        }
    });
}

@end
