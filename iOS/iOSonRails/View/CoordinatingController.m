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
            sharedInstance.viewControllers = [NSArray arrayWithObjects: [HaoViewController sharedInstance],
                                              [LeViewController sharedInstance],
                                              [JingViewController sharedInstance],
                                              [AiViewController sharedInstance],
                                              [JuViewController sharedInstance],
                                              [EViewController sharedInstance],
                                              [NuViewController sharedInstance],
                                              nil];
            sharedInstance.activeViewController = sharedInstance.viewControllers[0];
        }
    }
    return sharedInstance;
}

- (IBAction) presentViewControllerByType:(int )type {
    int targetControllerIndex;
    for (int i = 0; i < [self.viewControllers count]; i++) {
        if (self.viewControllers[i] == self.activeViewController) {
            if (type == 0) {
                targetControllerIndex = abs((i - 1) %7);
            } else if (type == 1) {
                targetControllerIndex = abs((i + 1) %7);
            }
            break;
        }
    }
    
    id active = self.activeViewController;
    UIViewController *vc = self.viewControllers[targetControllerIndex];
    if (vc.isViewLoaded && vc.view.window) {
        NSLog(@"it loaded already");
    } else {
        NSLog(@"it loaded no");
    }
    UIViewController *targetViewController = self.viewControllers[targetControllerIndex];
        [self.viewControllers[targetControllerIndex] dismissViewControllerAnimated:NO completion:nil];
    if (targetViewController.presentedViewController == nil) {
    [self.activeViewController presentViewController:self.viewControllers[targetControllerIndex]
                                                animated:YES
                                          completion:^{
                                              NSLog(@"present done%@ -> %@", active, self.viewControllers[targetControllerIndex]);
                                          }];
    self.activeViewController = self.viewControllers[targetControllerIndex];
    }
}

@end
