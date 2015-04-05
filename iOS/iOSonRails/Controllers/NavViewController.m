//
//  NavViewController.m
//  iOSonRails
//
//  Created by huangmh on 3/21/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

#import "NavViewController.h"
#import "MMPlaceHolder.h"
#import "NewsWebViewController.h"
#import "Color.h"

@interface NavViewController ()<NewsWebViewControllerDelegate>

@property UIView *contentView;
@property UIWebView *webView;

@property UIView *navBar;
@property UIButton *backButton;
@property UIButton *shareButton;

@end

@implementation NavViewController

- (id ) initWithEmotion:(Emotion *)emotion {
    if (self == [super init]) {
        self.emotion = emotion;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = .1;
}

- (void)viewDidAppear:(BOOL)animated {
    self.news = [[NSArray alloc] initWithArray:[News newsWithEmotion:self.emotion]];
    
    if ([self.news count] > 0) {
        News *news = self.news[self.activeNewsIndex];
        self.contentView = [[CommonView alloc] initWithNews:news];
        [self.view addSubview:self.contentView];
    }
    
    [self startAccelerometer];
    
    //viewDidAppear中加入
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receiveNotification:)
                                                 name:UIApplicationWillEnterForegroundNotification object:nil];
    [self addRightLeftGestrueRecognizers];
    [self addUpDownGestrueRecognizers];
    [self addTapGestrueRecognizers];
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

- (void) showNextEmotionTypeNews {
    self.activeNewsIndex = 0;
    for (int i = 0; i < 6; i++) {
        self.emotion = [self.emotion next];
        self.news = [[NSArray alloc] initWithArray:[News newsWithEmotion:self.emotion]];
        if ([self.news count] > 0) {
            News *news = self.news[self.activeNewsIndex];
            self.contentView = [[CommonView alloc] initWithNews:news];
            [self.view addSubview:self.contentView];
            break;
        }
    }
}

- (void) showPreviousEmotionTypeNews {
    self.activeNewsIndex = 0;
    for (int i = 0; i < 6; i++) {
        self.emotion = [self.emotion previous];
        self.news = [[NSArray alloc] initWithArray:[News newsWithEmotion:self.emotion]];
        if ([self.news count] > 0) {
            News *news = self.news[self.activeNewsIndex];
            self.contentView = [[CommonView alloc] initWithNews:news];
            [self.view addSubview:self.contentView];
            break;
        }
    }
}

- (void) handleSwipe:(UISwipeGestureRecognizer *)swipe {
    if (swipe.direction == UISwipeGestureRecognizerDirectionDown) {
        [self showPreviousEmotionTypeNews];
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        [self showNextEmotionTypeNews];
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        News *tmp = [self nextNews];
        self.coverImage = tmp.newsPicture;
        self.coverTitle = tmp.newsTitle;
        if (self.activeNewsIndex != 0) {
            self.contentView = [[CommonView alloc] initWithNews:tmp];
        } else {
            self.contentView = [[CommonView alloc] initWithNews:tmp];
        }
        [self.view addSubview:self.contentView];
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        News *tmp = [self previousNews];
        self.coverImage = tmp.newsPicture;
        self.coverTitle = tmp.newsTitle;
        if (self.activeNewsIndex != 0) {
            self.contentView = [[CommonView alloc] initWithNews:tmp];
        } else {
            self.contentView = [[CommonView alloc] initWithNews:tmp];
        }
        [self.view addSubview:self.contentView];
    }
}

- (void)handleTap:(UITapGestureRecognizer *)sender {
    [self removeTapGestrueRecofnizers];
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        News *news = self.news[self.activeNewsIndex];
        NewsWebViewController *newsWebViewController = [[NewsWebViewController alloc] initWithNews:news];
        newsWebViewController.delegate = self;
        [self presentViewController:newsWebViewController animated:YES completion:nil];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (News *)nextNews {
    self.activeNewsIndex = (self.activeNewsIndex + 1) % ([self.news count]);
    return self.news[self.activeNewsIndex % ([self.news count])];
}

- (News *)previousNews {
    self.activeNewsIndex = abs(self.activeNewsIndex - 1) % [self.news count];
    return self.news[self.activeNewsIndex];
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}

- (void) clearGestureRecognizers {
    int numberOfGenstureRecognizer = [self.view.gestureRecognizers count];
    for (int i = 0; i < numberOfGenstureRecognizer; i++) {
        [self.view removeGestureRecognizer:self.view.gestureRecognizers[i]];
    }
}

- (void) addUpDownGestrueRecognizers {
    UISwipeGestureRecognizer *swipeDown = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeDown setDirection:UISwipeGestureRecognizerDirectionDown];
    [swipeUp setDirection:UISwipeGestureRecognizerDirectionUp];
    
    [self.view addGestureRecognizer:swipeUp];
    [self.view addGestureRecognizer:swipeDown];
}

- (void) removeUpGestrueRecognizers {
    int numberOfGenstureRecognizer = [self.view.gestureRecognizers count];
    for (int i = 0; i < numberOfGenstureRecognizer; i++) {

        if ([self.view.gestureRecognizers[i] isKindOfClass:[UISwipeGestureRecognizer class]]) {
            UISwipeGestureRecognizer *genstrue = self.view.gestureRecognizers[i];
            if (genstrue.direction == UISwipeGestureRecognizerDirectionUp) {
                [self.view removeGestureRecognizer:self.view.gestureRecognizers[i]];
                numberOfGenstureRecognizer = numberOfGenstureRecognizer - 1;
            }
        }
    }
}

- (void) removeDownGestrueRecognizers {
    int numberOfGenstureRecognizer = [self.view.gestureRecognizers count];
    for (int i = 0; i < numberOfGenstureRecognizer; i++) {

        if ([self.view.gestureRecognizers[i] isKindOfClass:[UISwipeGestureRecognizer class]]) {
            UISwipeGestureRecognizer *genstrue = self.view.gestureRecognizers[i];
            if (genstrue.direction == UISwipeGestureRecognizerDirectionDown) {
                [self.view removeGestureRecognizer:self.view.gestureRecognizers[i]];
                numberOfGenstureRecognizer = numberOfGenstureRecognizer - 1;
            }
        }
    }
}

- (void) removeUpDownGestrueRecognizers {
    int numberOfGenstureRecognizer = [self.view.gestureRecognizers count];
    for (int i = 0; i < numberOfGenstureRecognizer; i++) {

        if ([self.view.gestureRecognizers[i] isKindOfClass:[UISwipeGestureRecognizer class]]) {
            UISwipeGestureRecognizer *genstrue = self.view.gestureRecognizers[i];
            if (genstrue.direction == UISwipeGestureRecognizerDirectionUp || genstrue.direction == UISwipeGestureRecognizerDirectionDown) {
                [self.view removeGestureRecognizer:self.view.gestureRecognizers[i]];
                numberOfGenstureRecognizer = numberOfGenstureRecognizer - 1;
            }
        }
    }
}

- (void) addRightLeftGestrueRecognizers {
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeLeft];
    [self.view addGestureRecognizer:swipeRight];
}

- (void) removeRightLeftGestrueRecognizers {
    int numberOfGenstureRecognizer = [self.view.gestureRecognizers count];
    for (int i = 0; i < numberOfGenstureRecognizer; i++) {
        if ([self.view.gestureRecognizers[i] isKindOfClass:[UISwipeGestureRecognizer class]]) {
            UISwipeGestureRecognizer *genstrue = self.view.gestureRecognizers[i];
            if (genstrue.direction == UISwipeGestureRecognizerDirectionLeft || genstrue.direction == UISwipeGestureRecognizerDirectionRight) {
                [self.view removeGestureRecognizer:self.view.gestureRecognizers[i]];
                numberOfGenstureRecognizer = numberOfGenstureRecognizer - 1;
            }
        }
    }
}
- (void) addTapGestrueRecognizers {
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.view addGestureRecognizer:tap];
}

- (void) removeTapGestrueRecofnizers {
    int numberOfGenstureRecognizer = [self.view.gestureRecognizers count];
    for (int i = 0; i < numberOfGenstureRecognizer; i++) {
        if ([self.view.gestureRecognizers[i] isKindOfClass:[UITapGestureRecognizer class]]) {
            [self.view removeGestureRecognizer:self.view.gestureRecognizers[i]];
            numberOfGenstureRecognizer = numberOfGenstureRecognizer - 1;
        }
    }
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

- (void)newsWebViewControllerSwippedRight:(NewsWebViewController *)newsWebViewController {
    [self dismissViewControllerAnimated:YES completion:nil];
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