//
//  main.m
//  BlockLearning
//
//  Created by huangmh on 1/4/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "News.h"

typedef NSString *(^appendString) (NSString *a, NSString *b);


int main(int argc, const char * argv[]) {
    @autoreleasepool {
        /**
         * block as local variable
         */
        int (^localVarBlock)(int, int) = ^int(int a, int b) {
            return a + b;
        };
        
        /**
         * block as property
         */
        News *news = [[News alloc] init];
        news.propertyBlock = ^(NSString *pubDate) {
            return [[NSString alloc] initWithFormat:@"pubDate: %@", pubDate];
        };
       
        /**
         *  block as parameter
         */
        [news showTitle:@"我们是中国人" decorate:^(NSString *a) {
            NSLog(@" title is %@", a);
        }];
        
        NSString *(^parameterBlock)(NSString  *name) = ^NSString* (NSString *name) {
            return [name stringByAppendingString:@"Huang"];
        };
        
        appendString blockAppend = ^NSString *(NSString *a, NSString *b) {
            return [a stringByAppendingString:b];
        };
        
        NSString *a = @"a";
        NSString *b = @"b";
        NSLog(@"%@", blockAppend(a, b));
       
        /**
         *  block as argument
         */
        NSString *(^fullName)(NSString *name) = ^NSString *(NSString *name) {
            return [name stringByAppendingString:@"Huang"];
        };
        
        [news sayHellow:fullName];
        
        NSLog(@"property is  %@", news.propertyBlock(@"2014"));
        NSLog(@"localVar is %d", localVarBlock(2, 2));
        
        /**
         *  inline block without parater
         */
        NSString *ret = ^NSString *{
            return @"ret";
        };
        NSLog(@"%@", ret);
        
        /**
         *  inline block with parameter
         */
        ^(NSString *google) {
            NSLog(@"%@", [google stringByAppendingString:@"http://"]);
        }(@"google");
    }
    return 0;
}
