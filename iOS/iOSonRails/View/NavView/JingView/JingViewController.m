//
//  NavViewController.m
//  iOSonRails
//
//  Created by huangmh on 3/21/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

// * hao -> le -> jing -> ai -> ju -> e -> nu
#import <CoreMotion/CoreMotion.h>
#import "JingViewController.h"
#import "LeViewController.h"
#import "AiViewController.h"
#import "NavSubView.h"
#import "News.h"

@interface JingViewController ()

@property (strong,nonatomic) CMMotionManager *motionManager;

@end

@implementation JingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   	
    self.motionManager = [[CMMotionManager alloc] init];//一般在viewDidLoad中进行
    self.motionManager.accelerometerUpdateInterval = .1;//加速仪更新频率，以秒为单位
    
    /*
     * TODO: should get from Server via REST API
     */
    
    News *new0 = [[News alloc] initWithDictionary:@{@"title": @"昆明人大决定罢免仇和省人大代表职务",
                                                    @"link": @"http://news.163.com/15/0321/15/AL889A8O0001124J.html",
                                                    @"picture": @"http://img4.cache.netease.com/photo/0001/2015-03-15/900x600_AKOPRICE00AN0001.jpg"
                                                    }];
    
    self.view = [NavSubView initWithEmotionCategory:@"今日最惊"
                                         coverImage: new0.image
                                              title: new0.title];
    
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];

    [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    [self.view addGestureRecognizer:swipeUp];
    [self.view addGestureRecognizer:swipeDown];
}

- (void)viewDidAppear:(BOOL)animated {
    [self startAccelerometer];
    
    //viewDidAppear中加入
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:UIApplicationWillEnterForegroundNotification object:nil];
}

-(void)startAccelerometer
{
    //以push的方式更新并在block中接收加速度
    [self.motionManager startAccelerometerUpdatesToQueue:[[NSOperationQueue alloc]init]
                                             withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                                 [self outputAccelertionData:accelerometerData.acceleration];
                                                 if (error) {
                                                     NSLog(@"motion error:%@",error);
                                                 }
                                             }];
}

-(void)outputAccelertionData:(CMAcceleration)acceleration
{
    //综合3个方向的加速度
    double accelerameter =sqrt( pow( acceleration.x , 2 ) + pow( acceleration.y , 2 )
                               + pow( acceleration.z , 2) );
    //当综合加速度大于2.3时，就激活效果（此数值根据需求可以调整，数据越小，用户摇动的动作就越小，越容易激活，反之加大难度，但不容易误触发）
    if (accelerameter>2.5f) {
        //立即停止更新加速仪（很重要！）
        [self.motionManager stopAccelerometerUpdates];
        dispatch_async(dispatch_get_main_queue(), ^{
            //UI线程必须在此block内执行，例如摇一摇动画、UIAlertView之类
            /*
             * go to feedback view, if feedback view closed, Accelerometer should start again
             */
            NSLog(@"Shakeing stop");
            [self startAccelerometer];
        });
    }
}
-(void)viewDidDisappear:(BOOL)animated
{
    //停止加速仪更新（很重要！）
    [self.motionManager stopAccelerometerUpdates];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationWillEnterForegroundNotification object:nil];
}

-(void)receiveNotification:(NSNotification *)notification
{
    if ([notification.name
         isEqualToString:UIApplicationDidEnterBackgroundNotification])
    {
        [self.motionManager stopAccelerometerUpdates];
    }else{
        [self startAccelerometer];
    }
}

- (void) handleSwipe:(UISwipeGestureRecognizer *)swipe {
    if (swipe.direction == UISwipeGestureRecognizerDirectionDown) {
        AiViewController *aiViewController = [[AiViewController alloc] init];
        [self presentViewController:aiViewController
                           animated:YES
                         completion:^{
                             NSLog(@"Present Done");
                         }
         ];
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        LeViewController *leViewController = [[LeViewController alloc] init];
        [self presentViewController:leViewController
                           animated:YES
                         completion:^{
                             NSLog(@"Present Done");
                         }
         ];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        /*
         * go to news list accord category
         */
        NSLog(@"tapped it %d", 0);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
