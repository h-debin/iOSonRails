//
//  News.h
//  BlockLearning
//
//  Created by huangmh on 1/4/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : NSObject

@property (nonatomic, strong) NSString* (^propertyBlock)(NSString *pubDate);

/**
 *  block as parameter
 */
- (void) showTitle:title decorate:(void (^)(NSString *title))decorateBlock;

- (void) sayHellow:(NSString *(^)(NSString *name))fullName;

@end
