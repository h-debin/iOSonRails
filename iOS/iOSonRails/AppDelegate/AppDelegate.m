//
//  AppDelegate.m
//  iOSonRails
//
//  Created by huangmh on 12/30/14.
//  Copyright (c) 2014 minghe. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworking.h"
#import "HTTPClient.h"
#import "StartViewController.h"
#import "DBManager.h"
#import "UserManager.h"
#import "Macro.h"
#import "MainViewController.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    /*
     * Google Anal
     */
    // Optional: automatically send uncaught exceptions to Google Analytics.
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = 20;
    
    // Optional: set Logger to VERBOSE for debug information.
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
    
    // Initialize tracker. Replace with your tracking ID.
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-52720212-3"];
    
    /*
     * setup CoreData, we're using MagicalRecord here
     */
    [DBManager setupDB];
    
    
    /**
     init URL Cache
     */
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity: 2 * 1024 * 1024
                                                        diskCapacity:20 * 1024 *1024
                                                             diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    UIViewController *viewController = [[UIViewController alloc] init];
    UIView *view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    UILabel *label = [[UILabel alloc] initWithFrame:
                      CGRectMake(0,
                                 [[UIScreen mainScreen] bounds].size.height / 2 - 22,
                                 [[UIScreen mainScreen] bounds].size.width,
                                 44)
                      ];
    label.backgroundColor = [UIColor whiteColor];
    [label setTextAlignment:NSTextAlignmentCenter];
    [view addSubview:label];
    viewController.view = view;
    
    self.window.rootViewController = [[StartViewController alloc] init];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [MagicalRecord cleanUp];
}

@end
