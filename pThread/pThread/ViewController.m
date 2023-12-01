//
//  ViewController.m
//  pThread
//
//  Created by o0oi1i on 2023/12/1.
//

#import "ViewController.h"

#import "pthread.h"

sigset_t sigs;

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
   [super viewDidLoad];
   [self pthread2];
}

- (void)pthread2
{
    NSLog(@"当前线程 1:%@ pthread_self:%p", [NSThread currentThread], pthread_self());
    
    sigemptyset(&sigs);
    sigaddset(&sigs, SIGUSR2);
    
    pthread_t thread;
    pthread_create(&thread, NULL, task2, NULL);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        int res = pthread_kill(thread, SIGUSR2);
        NSLog(@"res:%d", res);
    });
}

void *task2(void *param) {
    NSLog(@"当前线程 2:%@ pthread_self:%p", [NSThread currentThread], pthread_self());
    
    while (1) {
        int s;
        sigwait(&sigs, &s);
        sigleHandle(SIGUSR2);
    }
    
    return NULL;
}

void sigleHandle(int sig) {
    NSLog(@"当前线程 3:%@ pthread_self:%p", [NSThread currentThread], pthread_self());
    NSLog(@"处理信号 %d", sig);
    return;
}

- (void)pthread1
{
    pthread_t thread;
    pthread_attr_t attr;
    pthread_attr_init(&attr);
    pthread_attr_setdetachstate(&attr, PTHREAD_CREATE_JOINABLE);
    
    pthread_create(&thread, &attr, task1, @"QQ");
    pthread_attr_destroy(&attr);
    void *ptr;
    pthread_join(thread, &ptr);
    NSLog(@"当前线程:%@ pthread_self:%p", [NSThread currentThread], pthread_self());
    NSLog(@"%s", (char *)ptr);  // 将接收到线程的返回值“end”
}

void *task1(void *param) {
//    pthread_exit("end");
    // 线程被提前主动结束,后面的代码将不会被执行到
    NSLog(@"当前线程:%@ pthread_self:%p 参数:%@", [NSThread currentThread], pthread_self(), param);
    sleep(3);
    return NULL;
}

- (void)pthread
{
    NSLog(@"当前线程:%@ pthread_self:%p", [NSThread currentThread], pthread_self());
    pthread_t thread;
    pthread_create(&thread, NULL, task, @"Hello World");
    pthread_detach(thread);
}

void *task(void *param) {
    NSLog(@"当前线程:%@ pthread_self:%p", [NSThread currentThread], pthread_self());
    NSLog(@"参数:%@", param);
    return NULL;
}

@end

