//
//  News.m
//  BlockLearning
//
//  Created by huangmh on 1/4/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

#import "News.h"

@implementation News

- (void)showTitle:(id)title decorate: (void (^)(NSString *))decorateBlock {
    decorateBlock(title);
}

- (void)sayHellow:(NSString *(^)(NSString *))fullName {
    NSString *full = fullName(@"Wang");
    NSLog(@"hello %@", full);
}

@end
