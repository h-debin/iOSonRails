//
//  NavViewController.m
//  iOSonRails
//
//  Created by huangmh on 3/21/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

#import <CoreMotion/CoreMotion.h>
#import "NavViewController.h"
#import "NavSubView.h"
#import "News.h"

@interface NavViewController ()

@property NSArray *topNewsList;
@property NSArray *categorys;

@property NSMutableArray *views;
@property int index;

@property (strong,nonatomic) CMMotionManager *motionManager;

@end

@implementation NavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   	
    self.motionManager = [[CMMotionManager alloc] init];//一般在viewDidLoad中进行
    self.motionManager.accelerometerUpdateInterval = .1;//加速仪更新频率，以秒为单位
    
    News *new0 = [[News alloc] initWithDictionary:@{@"title": @"缅甸总统：果敢冲突是内部事务 中国无法解决",
                                                    @"link": @"http://news.163.com/15/0321/10/AL7N01GH0001121M.html",
                                                    @"picture": @"http://img3.cache.netease.com/cnews/2015/3/21/20150321102847189e4.jpg"
                                                    }];
    News *new1 = [[News alloc] initWithDictionary:@{@"title": @"中缅边境事件进展：缅方赔遇难者7万元消息不实",
                                                    @"link": @"http://news.163.com/15/0320/15/AL5LQ6AS0001124J.html",
                                                    @"picture": @"http://img4.cache.netease.com/photo/0001/2015-03-21/900x600_AL7OUVCN00AP0001.jpg"
                                                    }];
    News *new2 = [[News alloc] initWithDictionary:@{@"title": @"中日韩开外长会 王毅称中韩与日关系严重受干扰",
                                                    @"link": @"http://news.163.com/15/0321/18/AL8HTFMU00014SEH.html",
                                                    @"picture": @"http://img1.cache.netease.com/catchpic/5/53/5348703CF58E09ED100E81DD3938693F.jpg"
                                                    }];
    News *new3 = [[News alloc] initWithDictionary:@{@"title": @"依偎习近平合影女孩长大 其父系感动中国人物",
                                                    @"link": @"http://news.163.com/15/0321/02/AL6SBT3000014AED.html",
                                                    @"picture": @"http://img1.cache.netease.com/catchpic/B/B9/B9381E9677E20EB85799F616D2EDCC78.jpg"
                                                    }];
    News *new4 = [[News alloc] initWithDictionary:@{@"title": @"南京军区原司令员:周永康徐才厚等人可耻可",
                                                    @"link": @"http://news.163.com/15/0321/20/AL8Q86K80001124J.html",
                                                    @"picture": @"http://img4.cache.netease.com/cnews/2015/3/21/20150321204313d0176.jpg"
                                                    }];
    News *new5 = [[News alloc] initWithDictionary:@{@"title": @"昆明人大决定罢免仇和省人大代表职务",
                                                    @"link": @"http://news.163.com/15/0321/15/AL889A8O0001124J.html",
                                                    @"picture": @"http://img4.cache.netease.com/photo/0001/2015-03-15/900x600_AKOPRICE00AN0001.jpg"
                                                    }];
    News *new6 = [[News alloc] initWithDictionary:@{@"title": @"北京市长：北京暂不考虑放开住房限购",
                                                    @"link": @"http://news.163.com/15/0321/19/AL8KCVI600014JB5.html",
                                                    @"picture": @""
                                                    }];
    self.topNewsList = @[new0, new1, new2, new3, new4, new5, new6];
    self.categorys = @[@"今日最好", @"今日最乐", @"今日最哀", @"今日最惧", @"今日最恶", @"今日最怒", @"今日最惊"];
    
    self.views = [[NSMutableArray alloc] init];
    for (int i = 0; i < 7; i++) {
        News *news = self.topNewsList[i];
        NavSubView *view = [NavSubView initWithEmotionCategory: self.categorys[i]
                                                    coverImage: news.image
                                                         title: news.title];
        [self.views addObject:view];
    }
    self.index = 0;
    [self setViewWithIndex:self.index];
    // Do any additional setup after loading the view.
    
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
    }}



- (void)setViewWithIndex:(int)index {
    self.view = self.views[abs(self.index % 7)];
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];

    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    /*
     * TODO: this code do not fix the already in issue, since they differect id
     */
    if (![self.view.gestureRecognizers containsObject:swipeLeft]) {
        [self.view addGestureRecognizer:swipeLeft];
    }
    if (![self.view.gestureRecognizers containsObject:swipeRight]) {
         [self.view addGestureRecognizer:swipeRight];
    }
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    if (![self.view.gestureRecognizers containsObject:tap]) {
        [self.view addGestureRecognizer:tap];
    }
}


- (void) handleSwipe:(UISwipeGestureRecognizer *)swipe {
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        self.index = self.index - 1;
        [self setViewWithIndex:self.index];
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        self.index = self.index + 1;
        [self setViewWithIndex:self.index];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateEnded) {
        /*
         * go to news list accord category
         */
        NSLog(@"tapped it %d", self.index);
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
