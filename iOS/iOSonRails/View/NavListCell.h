//
//  NewsListCell.h
//  TableViewCell
//
//  Created by huangmh on 1/25/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"

@interface NavListCell : UITableViewCell

+ (id)initWithEmotionCategory:(NSString *)category
                   coverImage:(NSString *)coverImage
                        title:(NSString *)title;

@end
