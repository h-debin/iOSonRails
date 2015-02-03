//
//  News.m
//  iOSonRails
//
//  Created by huangmh on 1/18/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

#import "News.h"

@implementation News

- (id)initWithDictionary:(NSDictionary *)aDict {
    self = [super init];
    if (self) {
        self.title = aDict[@"title"];
        self.link = aDict[@"link"];
//        self.image = aDict[@"image"];
        self.image = aDict[@"picture"];
        self.video = aDict[@"video"];
        self.category = aDict[@"category"];
        self.pubDate = aDict[@"pub_date"];
        self.site = aDict[@"from_site"];
    }
    
    return self;
}

@end
