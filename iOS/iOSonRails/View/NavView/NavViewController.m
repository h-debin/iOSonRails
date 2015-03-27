//
//  NavViewController.m
//  iOSonRails
//
//  Created by huangmh on 3/21/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

#import "NavViewController.h"
#import "Color.h"
#import "MMPlaceHolder.h"

@interface NavViewController ()

@property UIView *contentView;
@property UIWebView *webView;

@property UIView *navBar;
@property UIButton *backButton;
@property UIButton *shareButton;
@property NSArray *EMOTION_TYPE_TOP;
@property NSArray *EMOTION_TYPE_NORMAL;

@end

@implementation NavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.EMOTION_TYPE_TOP = @[@"今日最好", @"今日最乐", @"今日最惊", @"今日最哀", @"今日最惧", @"今日最恶", @"今日最怒"];
    self.EMOTION_TYPE_NORMAL = @[@"好", @"乐", @"惊", @"哀", @"惧", @"恶", @"怒"];
}

- (void)viewDidAppear:(BOOL)animated {
    News *news = self.news[self.activeNewsIndex];
    self.contentView = [NavSubView initWithEmotionCategory:self.EMOTION_TYPE_TOP[self.type]
                                         coverImage: news.image
                                              title: news.title];
    [self.view addSubview:self.contentView];
    
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
        [[CoordinatingController sharedInstance] presentViewControllerByType:self.from fromObject:self];
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionUp) {
        [[CoordinatingController sharedInstance] presentViewControllerByType:self.to fromObject:self];
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        News *tmp = [self nextNews];
        self.coverImage = tmp.image;
        self.coverTitle = tmp.title;
        if (self.activeNewsIndex != 0) {
            self.contentView = [NavSubView initWithEmotionCategory:self.EMOTION_TYPE_NORMAL[self.type] coverImage:self.coverImage title:self.coverTitle];
        } else {
            self.contentView = [NavSubView initWithEmotionCategory:self.EMOTION_TYPE_TOP[self.type] coverImage:self.coverImage title:self.coverTitle];
        }
        [self.view addSubview:self.contentView];
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        News *tmp = [self previousNews];
        self.coverImage = tmp.image;
        self.coverTitle = tmp.title;
        if (self.activeNewsIndex != 0) {
            self.contentView = [NavSubView initWithEmotionCategory:self.EMOTION_TYPE_NORMAL[self.type] coverImage:self.coverImage title:self.coverTitle];
        } else {
            self.contentView = [NavSubView initWithEmotionCategory:self.EMOTION_TYPE_TOP[self.type] coverImage:self.coverImage title:self.coverTitle];
        }
        [self.view addSubview:self.contentView];
    }
}

- (void) backToNav {
    [self.webView removeFromSuperview];
    [self.navBar removeFromSuperview];
    [self.view addSubview:self.contentView];
    [self addRightLeftGestrueRecognizers];
    NSLog(@"back clicked");
}

- (void)handleTap:(UITapGestureRecognizer *)sender {
    [self removeRightLeftGestrueRecognizers];
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        NewsWebViewController *newsWebViewController = [[NewsWebViewController alloc] init];
        News *news = self.news[self.activeNewsIndex];
        newsWebViewController.link = news.link;
        [self.contentView removeFromSuperview];
        
        
        float deviceWidth = [[UIScreen mainScreen] bounds].size.width;
        float deviceHeight = [[UIScreen mainScreen] bounds].size.height;
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, deviceWidth, deviceHeight)];
        self.webView.delegate = self;
        
        self.navBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, deviceWidth, 50)];
        self.navBar.backgroundColor = [UIColor colorWithRed:0.945 green:0.945 blue:0.945 alpha:1];
        
        self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
        self.backButton.titleLabel.text = @"back";
        self.backButton.backgroundColor = [UIColor colorWithRed:0.945 green:0.945 blue:0.945 alpha:1];;
        [self.backButton addTarget:self action:@selector(backToNav) forControlEvents:UIControlEventTouchUpInside];
        
        self.shareButton = [[UIButton alloc] initWithFrame:CGRectMake(deviceWidth - 50, 0, 50, 50)];
        self.shareButton.titleLabel.text = @"back";
        self.shareButton.backgroundColor = [UIColor colorWithRed:0.945 green:0.945 blue:0.945 alpha:1];
        [self.shareButton addTarget:self action:@selector(backToNav) forControlEvents:UIControlEventTouchUpInside];
        
        
        [self.navBar addSubview:self.backButton];
        [self.navBar addSubview:self.shareButton];
        
        NSString *url= @" ";
        if (news.link) {
             url=news.link;
        } else {
            url = @"http://www.baidu.com";
        }
        NSURL *nsurl=[NSURL URLWithString:url];
        NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
        [self.webView loadRequest:nsrequest];
        [self.view addSubview:self.webView];
        [self.view addSubview:self.navBar];
//        [self.navBar showPlaceHolderWithLineColor:[UIColor redColor]];
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

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"Web View loading start");
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"Web View loading done");
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"Web View loading error: %@", [error localizedDescription]);
}

- (void)viewWillAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
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



/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


@end