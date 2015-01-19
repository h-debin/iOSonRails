//
//  News.h
//  iOSonRails
//
//  Created by huangmh on 1/18/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface News : NSObject

@property NSString *title;
@property NSString *link;
@property NSString *image;
@property NSString *video;
@property NSString *category;
@property NSString *pubDate;
@property NSString *site;

- (id)initWithDictionary:(NSDictionary *)aDict;

@end
