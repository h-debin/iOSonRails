//
//  NewsWebViewController.m
//  iOSonRails
//
//  Created by huangmh on 3/24/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

#import "NewsWebViewController.h"
#import "Macro.h"
#import "MONActivityIndicatorView.h"
#import "MMPlaceHolder.h"

@interface NewsWebViewController () <UIGestureRecognizerDelegate, MONActivityIndicatorViewDelegate>

@property UIWebView *webView;
@property UIButton *backButton;

@property News *news;

@property MONActivityIndicatorView *indicatorView;

@end

@implementation NewsWebViewController

- (id ) initWithNews:(News *)news {
    if (self == [super init]) {
        self.news = news;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addRightGestrureRecognizer];
    [self addLeftGestrureRecognizer];
    
    [self prepareWebView];
    [self prepareIndicator];
}

- (void) prepareWebView {
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.webView.delegate = self;
    
    if (self.news.newsLink) {
        NSURL *url=[NSURL URLWithString:self.news.newsLink];
        NSURLRequest *nsrequest=[NSURLRequest requestWithURL:url];
        [self.webView loadRequest:nsrequest];
        [self.view addSubview:self.webView];
    }
}

- (void) prepareIndicator {
    self.indicatorView = [[MONActivityIndicatorView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2, SCREEN_WIDTH, 20)];
    self.indicatorView.center =CGPointMake(SCREEN_WIDTH/2 + 40, SCREEN_HEIGHT/2);
    self.indicatorView.delegate = self;
    self.indicatorView.numberOfCircles = 3;
    self.indicatorView.radius = 5;
    self.indicatorView.internalSpacing = 3;
    self.indicatorView.duration = 0.5;
    self.indicatorView.delay = 0.5;
    
    [self.webView addSubview:self.indicatorView];
}

- (void) startIndicatorAnimation {
    [self.indicatorView startAnimating];
}

- (void) stopIndicatorAnimation {
    [self.indicatorView stopAnimating];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    NSLog(@"Start Load");
    [self startIndicatorAnimation];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    NSLog(@"Finish Load");
    [self stopIndicatorAnimation];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"Web View loading error: %@", [error localizedDescription]);
    [self stopIndicatorAnimation];
}

- (void)viewWillAppear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

- (void)viewWillDisappear:(BOOL)animated {
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (BOOL)prefersStatusBarHidden {
    return YES;
}

- (void) addRightLeftGestrueRecognizers {
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    [self.view addGestureRecognizer:swipeLeft];
    [self.view addGestureRecognizer:swipeRight];
}

- (void) addRightGestrureRecognizer {
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    swipeRight.delegate = self;
    [self.view addGestureRecognizer:swipeRight];
}

- (void) addLeftGestrureRecognizer {
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    swipeLeft.delegate = self;
    [self.view addGestureRecognizer:swipeLeft];
}

- (void) handleSwipe:(UISwipeGestureRecognizer *)swipe {
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        [self shareToSocial];
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        [self backToNewsList];
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return YES;
}

- (void) shareToSocial {
    NSLog(@"Back to social");
}

- (void ) backToNewsList {
    if (self.delegate && [self.delegate respondsToSelector:@selector(newsWebViewControllerSwippedRight:)]) {
        [self.delegate newsWebViewControllerSwippedRight:self];
    } else {
        NSLog(@"no delegate");
    }
}

#pragma mark -
#pragma mark - Centering Indicator View

- (void)placeAtTheCenterWithView:(UIView *)view {
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0f
                                                           constant:0.0f]];
}

#pragma mark -
#pragma mark - MONActivityIndicatorViewDelegate Methods

- (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView
      circleBackgroundColorAtIndex:(NSUInteger)index {
    CGFloat red   = (arc4random() % 256)/255.0;
    CGFloat green = (arc4random() % 256)/255.0;
    CGFloat blue  = (arc4random() % 256)/255.0;
    CGFloat alpha = 1.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
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
