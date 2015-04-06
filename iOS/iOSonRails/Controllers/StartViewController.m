//
//  StartViewController.m
//  iOSonRails
//
//  Created by huangmh on 3/31/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

#import "StartViewController.h"
#import "Macro.h"
#import "CoreData+MagicalRecord.h"
#import "MainViewController.h"
#import "Reachability.h"
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
    
    Reachability *reach = [Reachability reachabilityWithHostname:@"baidu.com"];
    if ([reach isReachable]) {
        //cleanup the old data
        [self cleanAndResetupDB];
        
        [self prepareIndicator];
        [self startLoaderIndicator];
        [self loadDataFromServer];
        /*
        if ([reach isReachableViaWiFi]) {
            // On WiFi
        }
         */
    } else {
        UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"网络连接出错啦"
                                                          message:@"检查一下你的网络连接是否正常"
                                                         delegate:nil
                                                cancelButtonTitle:@"确认"
                                                otherButtonTitles:nil];
        
        [message show];
        
        [reach setReachableBlock:^(Reachability *reachblock) {
             // Now reachable
         }];
        
        [reach setUnreachableBlock:^(Reachability*reach) {
             // Now unreachable
         }];
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
    for(int i = 0; i < 7; i++) {
        NSString *typeKey = [self getNewsKeyWithType:i];
        self.news[typeKey] = [[NSMutableArray alloc] init];
        [self requestNewsWithType:i];
    }
}

- (NSString *) getNewsKeyWithType:(int )type {
    switch (type) {
        case 0:
            return @"好";
        case 1:
            return @"乐";
        case 2:
            return @"惊";
        case 3:
            return @"哀";
        case 4:
            return @"惧";
        case 5:
            return @"恶";
        case 6:
            return @"怒";
        default:
            return @"";
    }
}

- (void) requestNewsWithType:(int )type {
    NSString *typeName = [self getNewsKeyWithType:type];
    [[HTTPClient sharedHTTPClient] get:@"http://api.minghe.me/api/v1/news"
                             parameter:@{@"emotion_type": typeName}
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

- (void)setupDB
{
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:[self dbStore]];
}

- (NSString *)dbStore
{
    //NSString *bundleID = (NSString *)[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleIdentifierKey];
    return [NSString stringWithFormat:@"%@.sqlite", @"Model"];
}

- (void)cleanAndResetupDB
{
    NSString *dbStore = [self dbStore];
    
    NSError *error = nil;
    
    NSURL *storeURL = [NSPersistentStore MR_urlForStoreName:dbStore];
    
    [MagicalRecord cleanUp];
    
    if([[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error]){
        [self setupDB];
    }
    else{
        NSLog(@"An error has occurred while deleting %@", dbStore);
        NSLog(@"Error description: %@", error.description);
    }
}

@end
