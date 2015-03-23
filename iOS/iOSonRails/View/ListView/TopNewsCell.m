//
//  NewsListCell.m
//  TableViewCell
//
//  Created by huangmh on 1/25/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

#import "TopNewsCell.h"
#import "MMPlaceHolder.h"
#import "SDWebImage/UIImageView+WebCache.h"

@implementation TopNewsCell

+ (id)initWithNews:(News *)news {
    float WIDTH_IMAGE = [[UIScreen mainScreen] bounds].size.width;
    float WIDTH_PUBDATE = 50;
    float WIDTH_TITLE = WIDTH_IMAGE - WIDTH_PUBDATE;
    
    float HEIGHT_IMAGE = [[UIScreen mainScreen] bounds].size.height * 2 / 5;
    static float HEIGHT_TITLE = 50;
    static float HEIGHT_PUB_DATE = 50;
    
    float WIDTH_CONTAINER_VIEW = WIDTH_IMAGE;
    
    float HEIGH_CONTAINER_VIEW = HEIGHT_IMAGE;
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_CONTAINER_VIEW, HEIGH_CONTAINER_VIEW)];
    containerView.layer.backgroundColor = [UIColor clearColor].CGColor;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_IMAGE, HEIGHT_IMAGE)];
    if (![news.image isEqual:[NSNull null]]) {
        [imageView setImageWithURL:[NSURL URLWithString:news.image]
                  placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    } else {
        [imageView setImageWithURL:[NSURL URLWithString:@"http://g.hiphotos.baidu.com/image/pic/item/9358d109b3de9c825755d3856e81800a19d84383.jpg"]
                  placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
        NSLog(@"image is empty %@ -> %@", news.image, news.title);
    }
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, HEIGHT_IMAGE - HEIGHT_TITLE, WIDTH_TITLE - 50, HEIGHT_TITLE)];
    //titleLabel.backgroundColor = [UIColor redColor];
    titleLabel.text = news.title;
    titleLabel.numberOfLines = 2;
    UIFont *fontOfTitle = [UIFont boldSystemFontOfSize: 20.0f];
    titleLabel.font = fontOfTitle;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    //titleLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *pubDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH_TITLE - 50,  HEIGHT_IMAGE - 50, 15, HEIGHT_TITLE)];
    pubDateLabel.text = news.pubDate;
    pubDateLabel.numberOfLines = 1;
    UIFont *fontOfPubDateLabel = [UIFont boldSystemFontOfSize:10.0f];
    pubDateLabel.font = fontOfPubDateLabel;
    
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"TopNewsCell"];
    
    [containerView addSubview:imageView];
    [containerView addSubview:titleLabel];
    [containerView addSubview:pubDateLabel];
    [cell.contentView addSubview:containerView];
    cell.contentView.backgroundColor = [UIColor colorWithWhite:0.996 alpha:1.000];
    
    return cell;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
