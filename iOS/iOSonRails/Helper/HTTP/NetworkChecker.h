//
//  NetworkStatus.h
//  iOSonRails
//
//  Created by huangmh on 4/6/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"

@interface NetworkChecker : NSObject

+ (BOOL) isReachable:(NSString *)host;
+ (BOOL) isWIFI:(NSString *)host;

@end
