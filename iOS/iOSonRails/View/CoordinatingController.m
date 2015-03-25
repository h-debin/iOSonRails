//
//  CoordinatingController.m
//  iOSonRails
//
//  Created by huangmh on 3/25/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

#import "CoordinatingController.h"
#import "HaoViewController.h"
#import "AiViewController.h"
#import "EViewController.h"
#import "HaoViewController.h"
#import "JingViewController.h"
#import "JuViewController.h"
#import "LeViewController.h"
#import "NuViewController.h"

@interface CoordinatingController()

@property UIViewController *activeViewController;

@property NSArray *viewControllers;

@end

@implementation CoordinatingController

+ (CoordinatingController *) sharedInstance {
    static CoordinatingController *sharedInstance = nil;
    @synchronized(self) {
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc] init];
             //* hao -> le -> jing -> ai -> ju -> e -> nu
        }
    }
    return sharedInstance;
}

- (IBAction) presentViewControllerByType:(int )type fromObject:(id)object {
    id active = self.activeViewController;
    
// * hao -> le -> jing -> ai -> ju -> e -> nu
    UIViewController *targetViewController;
    switch (type) {
        case 0:
            targetViewController = [[HaoViewController alloc] init];
            break;
        case 1:
            targetViewController = [[LeViewController alloc] init];
            break;
        case 2:
            targetViewController = [[JingViewController alloc] init];
            break;
        case 3:
            targetViewController = [[AiViewController alloc] init];
            break;
        case 4:
            targetViewController = [[JuViewController alloc] init];
            break;
        case 5:
            targetViewController = [[EViewController alloc] init];
            break;
        case 6:
            targetViewController = [[NuViewController alloc] init];
            break;
        default:
            break;
    }
    active = self.activeViewController;
    [object presentViewController:targetViewController
                                                animated:YES
                                          completion:^{
                                              NSLog(@"present done%@ -> %@", active, targetViewController);
                                          }];
    //self.activeViewController = targetViewController;
}

@end
