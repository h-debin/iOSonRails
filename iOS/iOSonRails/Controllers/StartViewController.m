//
//  StartViewController.m
//  iOSonRails
//
//  Created by huangmh on 3/31/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

#import "StartViewController.h"
#import "Macro.h"
#import "DBManager.h"
#import "MainViewController.h"
#import "NetworkChecker.h"
#import "News.h"
#import "MONActivityIndicatorView.h"
#import "HTTPClient.h"
#import "MMPlaceHolder.h"

@interface StartViewController () <MONActivityIndicatorViewDelegate>

@property UIActivityIndicatorView *activityView;

@property MONActivityIndicatorView *indicatorView;
@property NSMutableDictionary *news;
@property int doneDataRequestCount;

@end

@implementation StartViewController

- (void) viewDidLoad {
    self.doneDataRequestCount = 0;
    [self addObserver:self forKeyPath:@"doneDataRequestCount" options:NSKeyValueObservingOptionNew context:nil];
    
    if ([NetworkChecker isReachable:@SERVER_HOST]) {
        //cleanup the old data
        [DBManager cleanAndResetupDB];
        
        [self prepareIndicator];
        [self startLoaderIndicator];
        [self loadDataFromServer];
    } else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"网络连接出错啦"
                                                          message:@"检查一下你的网络连接是否正常"
                                                         delegate:nil
                                                cancelButtonTitle:@"确认"
                                                otherButtonTitles:nil];
        
        [message show];
    }
}

- (void) prepareIndicator {
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    self.indicatorView = [[MONActivityIndicatorView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2, SCREEN_WIDTH, 20)];
    self.indicatorView.center = CGPointMake(SCREEN_WIDTH/2 + 17, SCREEN_HEIGHT/2);
    self.indicatorView.delegate = self;
    self.indicatorView.numberOfCircles = 7;
    self.indicatorView.radius = 5;
    self.indicatorView.internalSpacing = 3;
    self.indicatorView.duration = 0.5;
    self.indicatorView.delay = 0.5;
    [self.view addSubview:self.indicatorView];
}

- (void) startLoaderIndicator {
    [self.indicatorView startAnimating];
}

- (void) stopLoaderIndicator {
    [self.indicatorView stopAnimating];
}

- (void) loadDataFromServer {
    self.news = [[NSMutableDictionary alloc] init];
    NSArray *emotions = [Emotion allEmotions];
    for(int i = 0; i < [emotions count]; i++) {
        [self requestNewsWithEmotion:emotions[i]];
    }
}

- (void) requestNewsWithEmotion:(Emotion *)emotion {
    [[HTTPClient sharedHTTPClient] get:@"http://api.minghe.me/api/v1/news"
                             parameter:@{@"emotion_type": emotion.type}
                               success:^(id JSON) {
                                   for(int i = 0; i < [JSON count]; i++) {
                                       if(![News isTitleExist:JSON[i][@"title"]]) {
                                           News *tmpNews = [News MR_createEntity];
                                           tmpNews = [tmpNews initWithDictionary:JSON[i]];
                                           [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion: ^(BOOL success, NSError *error) {
                                               if(success) {
                                                   NSLog(@"saved OK");
                                               } else {
                                                   NSLog(@"saving error -> %@ ", [error localizedDescription]);
                                               }
                                           }];
                                       } else {
                                           NSLog(@"already have");
                                       }
                                   }
                                   self.doneDataRequestCount = self.doneDataRequestCount + 1;
                               }
                               failure:^(NSError *error){
                                   self.doneDataRequestCount = self.doneDataRequestCount + 1;
                                   NSLog(@"%@", [error localizedDescription]);
                               }];
    
}

- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqual:@"doneDataRequestCount"]) {
        if (self.doneDataRequestCount == 7) {
            [self stopLoaderIndicator];
            MainViewController *mainViewController = [[MainViewController alloc] initWithEmotion:[Emotion haoEmotion]];
            [self presentViewController:mainViewController
                               animated:YES
                             completion:^() {
                                 NSLog(@"go to nav view already");
                             }];
        }
    }
}

- (void) viewDidAppear:(BOOL)animated {
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

@end
