//
//  DeviceInfo.m
//  iOSonRails
//
//  Created by huangmh on 3/31/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

#import "DeviceInfo.h"

@implementation DeviceInfo

+ (float ) height {
    return [[UIScreen mainScreen] bounds].size.height;
}

+ (float )width {
    return [[UIScreen mainScreen] bounds].size.width;
}

@end
