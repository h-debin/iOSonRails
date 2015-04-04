//
//  Color.h
//  iOSonRails
//
//  Created by huangmh on 3/27/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

@interface Color : NSObject

+ (UIColor *)lighterColorForColor:(UIColor *)color;
+ (UIColor *)darkerColorForColor:(UIColor *)color;

@end
