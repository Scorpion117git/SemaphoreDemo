//
//  ViewController.m
//  SemaDemo
//
//  Created by shmily on 2021/7/19.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //    [self normalThread];
//    [self semaphoreThread];
    //    [self semaphore1];
    [self groupThread];
}

- (void)semaphoreThread{
    //顺序执行
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        dispatch_semaphore_t  semaphore = dispatch_semaphore_create(0);
        
        NSURLSessionDataTask * dataTask = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"https://www.baidu.com"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            dispatch_semaphore_signal(semaphore);
            NSLog(@"1请求成功");
        }];
        [dataTask resume];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER); //等待信号,当信号总量少于0 的时候就会一直等待 ,否则就可以正常的执行,并让信号总量-1
        
        NSURLSessionDataTask * dataTask1 = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"https://www.hao123.com"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            dispatch_semaphore_signal(semaphore);
            NSLog(@"2请求成功");
            
        }];
        [dataTask1 resume];
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        
        NSURLSessionDataTask * dataTask2 = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"https://www.hao123.com"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
            NSLog(@"3请求成功");
        }];
        [dataTask2 resume];
    });
    
}
-(void)normalThread{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        NSLog(@"run task1");
    });
    dispatch_async(queue, ^{
        NSLog(@"run task2");
    });
    dispatch_async(queue, ^{
        NSLog(@"run task3");
    });
    dispatch_async(queue, ^{
        NSLog(@"run task4");
    });
}
-(void)semaphore1{
    //为1的时候不能保证顺序执行,只能保证每次一个运行
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"run task1");
        dispatch_semaphore_signal(semaphore);
        
    });
    dispatch_async(queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"run task2");
        dispatch_semaphore_signal(semaphore);
        
    });
    dispatch_async(queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"run task3");
        dispatch_semaphore_signal(semaphore);
        
    });
    dispatch_async(queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"run task4");
        dispatch_semaphore_signal(semaphore);
        
    });
    dispatch_async(queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"run task5");
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_async(queue, ^{
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
        NSLog(@"run task6");
        dispatch_semaphore_signal(semaphore);
    });
}
-(void)groupThread{
    //结束请求进行下一步操作,不注重顺序
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
       dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
       dispatch_group_t group = dispatch_group_create();
    
       dispatch_group_async(group, queue, ^{
           NSURLSessionDataTask * dataTask = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"https://www.baidu.com"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
               dispatch_semaphore_signal(semaphore);
               NSLog(@"1请求成功");
           }];
           [dataTask resume];
       });
    
       dispatch_group_async(group, queue, ^{
           NSURLSessionDataTask * dataTask = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"https://www.baidu.com"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
               dispatch_semaphore_signal(semaphore);
               NSLog(@"2请求成功");
           }];
           [dataTask resume];
       });
    
       dispatch_group_notify(group, queue, ^{
   //        信号量 -1 为0时wait会阻塞线程
           dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
           dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
           NSLog(@"信号量为0");
           NSURLSessionDataTask * dataTask = [[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"https://www.baidu.com"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
               dispatch_semaphore_signal(semaphore);
               NSLog(@"3请求成功");
           }];
           [dataTask resume];
       });

}
@end
