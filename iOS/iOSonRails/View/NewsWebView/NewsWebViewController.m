//
//  NewsWebViewController.m
//  iOSonRails
//
//  Created by huangmh on 3/24/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

#import "NewsWebViewController.h"
#import "Macro.h"
#import "MMPlaceHolder.h"

@interface NewsWebViewController ()

@property UIWebView *webView;
@property UIButton *backButton;

@property News *news;
//@property UIWebView *webWView;

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
    
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.webView.delegate = self;
    
    NSString *url= @" ";
    if (self.news.newsLink) {
         url=self.news.newsLink;
    } else {
        url = @"http://www.baidu.com";
    }
    NSURL *nsurl=[NSURL URLWithString:url];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [self.webView loadRequest:nsrequest];
    [self.view addSubview:self.webView];
    
    [self addRightGestrureRecognizer];
    [self addLeftGestrureRecognizer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self.view addGestureRecognizer:swipeRight];
}

- (void) addLeftGestrureRecognizer {
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
