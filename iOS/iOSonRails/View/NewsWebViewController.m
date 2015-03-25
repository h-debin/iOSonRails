//
//  NewsWebViewController.m
//  iOSonRails
//
//  Created by huangmh on 3/24/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

#import "NewsWebViewController.h"
#import "MMPlaceHolder.h"

@interface NewsWebViewController ()

@property UIWebView *webView;
@property UIButton *backButton;

@end

@implementation NewsWebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    float deviceWidth = [[UIScreen mainScreen] bounds].size.width;
    float deviceHeight = [[UIScreen mainScreen] bounds].size.height;
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, deviceWidth, deviceHeight)];
    self.webView.delegate = self;
    
    self.backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    self.backButton.titleLabel.text = @"back";
    self.backButton.backgroundColor = [UIColor redColor];
    
    NSString *url= @" ";
    if (self.link) {
         url= self.link;
    } else {
        url = @"http://www.baidu.com";
    }
    NSURL *nsurl=[NSURL URLWithString:url];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    [self.webView loadRequest:nsrequest];
    [self.view addSubview:self.webView];
    [self.view addSubview:self.backButton];
    [self.backButton showPlaceHolderWithLineColor:[UIColor redColor]];
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





/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
