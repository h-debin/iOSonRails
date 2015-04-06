//
//  NetworkStatus.m
//  iOSonRails
//
//  Created by huangmh on 4/6/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

#import "NetworkChecker.h"

@implementation NetworkChecker

+ (BOOL ) isReachable:(NSString *)host {
    Reachability *reach = [Reachability reachabilityWithHostname:host];
    if ([reach isReachable]) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL ) isWIFI:(NSString *)host {
    Reachability *reach = [Reachability reachabilityWithHostname:host];
    if ([reach isReachableViaWiFi]) {
        return YES;
    } else {
        return NO;
    }
}

@end