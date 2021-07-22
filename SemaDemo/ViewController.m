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
/**
 信号量可以控制线程并发的数量,且可以通过信号量来控制信号量执行顺序.
 dispatch_semaphore_signal与dispatch_semaphore_wait一般为配对使用,signal升高信号量+1,wait降低信号量-1,当信号量为0时执行wait会导致信号量小于0,阻塞线程.
 耗时操作一般应该放在signal或wait前面,这样才能达到想要的效果.
 */
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //        [self normalThread];
    [self semaphoreThread];
//            [self semaphoreThread_1];
//    [self semaphoreThread_0];

    //    [self groupThread];
}


/**
 2021-07-21 20:36:03.756500+0800 SemaDemo[1331:20883] run task2
 2021-07-21 20:36:03.756510+0800 SemaDemo[1331:20881] run task3
 2021-07-21 20:36:03.756518+0800 SemaDemo[1331:20882] run task4
 2021-07-21 20:36:03.756500+0800 SemaDemo[1331:20885] run task1
 顺序随机
 */
- (void)normalThread{
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

/**
 021-07-22 12:56:09.217002+0800 SemaDemo[1773:25741] run task1
 2021-07-22 12:56:09.217201+0800 SemaDemo[1773:25741] run task2
 2021-07-22 12:56:09.217343+0800 SemaDemo[1773:25741] run task3
 2021-07-22 12:56:09.217485+0800 SemaDemo[1773:25743] run task4
 顺序执行
 */

- (void)semaphoreThread{
    //信号量初始值为2
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(2);
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);

    dispatch_async(queue, ^{
        NSLog(@"run task1");
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);//0

    dispatch_async(queue, ^{
        NSLog(@"run task2");
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    dispatch_async(queue, ^{
        NSLog(@"run task3");
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    dispatch_async(queue, ^{
        NSLog(@"run task4");
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_semaphore_signal(semaphore);

    
//    for (int i =0 ; i<10; i++) {
//        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
//        dispatch_async(queue, ^{
//            NSString *str = [NSString stringWithFormat:@"%ld",i];
//            NSLog(@"-- run task%@ --",str);
//            dispatch_semaphore_signal(semaphore);
//        });
//    }

}


/**
 2021-07-22 12:57:38.788727+0800 SemaDemo[1922:30421] run task1
 2021-07-22 12:57:38.789048+0800 SemaDemo[1922:30421] run task2
 2021-07-22 12:57:38.789230+0800 SemaDemo[1922:30421] run task3
 2021-07-22 12:57:38.789526+0800 SemaDemo[1922:30251] ---4----
 顺序执行
 */
- (void)semaphoreThread_1{
    //信号量初始值为1
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(1);
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    dispatch_async(queue, ^{
        NSLog(@"run task1");
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    dispatch_async(queue, ^{
        NSLog(@"run task2");
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    dispatch_async(queue, ^{
        NSLog(@"run task3");
        dispatch_semaphore_signal(semaphore);
    });
    NSLog(@"---4----");
}
/**
 
 2021-07-22 12:58:41.810017+0800 SemaDemo[1978:31675] run task1
 2021-07-22 12:58:41.810205+0800 SemaDemo[1978:31675] run task2
 2021-07-22 12:58:41.810353+0800 SemaDemo[1978:31675] run task3
 2021-07-22 12:58:41.810494+0800 SemaDemo[1978:31675] run task4
 顺序执行
 */
- (void)semaphoreThread_0{
    //信号量初始值为0
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(queue, ^{
        NSLog(@"run task1");
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    dispatch_async(queue, ^{
        NSLog(@"run task2");
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    dispatch_async(queue, ^{
        NSLog(@"run task3");
        dispatch_semaphore_signal(semaphore);
    });
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    
    dispatch_async(queue, ^{
        NSLog(@"run task4");
        dispatch_semaphore_signal(semaphore);
        
    });
    
}


- (void)groupThread{
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
        //        信号量为0时再wait会阻塞线程
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
