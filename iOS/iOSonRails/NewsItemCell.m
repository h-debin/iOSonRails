//
//  NewsItemCell.m
//  iOSonRails
//
//  Created by huangmh on 1/18/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

#import "NewsItemCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface NewsItemCell()

@end

@implementation NewsItemCell

- (id)initWithNews:(News *)news {
    static NSString *newsItemCellIdentifier = @"NewsItemCell";
    self = [super initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:newsItemCellIdentifier];
    if (self) {
        self.textLabel.text = news.title;
        self.detailTextLabel.text = news.pubDate;
    }
    
    return self;
}

@end
