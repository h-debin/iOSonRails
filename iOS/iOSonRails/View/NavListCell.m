//
//  NewsListCell.m
//  TableViewCell
//
//  Created by huangmh on 1/25/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

#import "NavListCell.h"
#import "MMPlaceHolder.h"
#import "News.h"
#import "SDWebImage/UIImageView+WebCache.h"


@implementation NavListCell

+ (id)initWithEmotionCategory:(NSString *)category coverImage:(NSString *)coverImage title:(NSString *)title {
    float WIDTH_IMAGE = [[UIScreen mainScreen] bounds].size.width;
    float WIDTH_TITLE = WIDTH_IMAGE;

    float HEIGHT_IMAGE = [[UIScreen mainScreen] bounds].size.height;
    static float HEIGHT_TITLE = 50;
    static float HEIGHT_PUB_DATE = 50;

    float WIDTH_CONTAINER_VIEW = WIDTH_IMAGE;
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Test"];
    
    float width = [[UIScreen mainScreen] bounds].size.width;
    
    float HEIGH_CONTAINER_VIEW = HEIGHT_IMAGE;
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_CONTAINER_VIEW, HEIGH_CONTAINER_VIEW)];
    //containerView.layer.borderWidth = 1.0;
    containerView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    [containerView showPlaceHolderWithLineColor:[UIColor blueColor]];


    /* ++
     set image
     ++ */
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_IMAGE, HEIGHT_IMAGE)];
    if (![coverImage isEqual:[NSNull null]]) {
        [imageView setImageWithURL:[NSURL URLWithString:coverImage]
                   placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
     }
    [imageView showPlaceHolderWithLineColor:[UIColor yellowColor]];
    /*
     * set emotion category label
     */
    UILabel *emotionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,  HEIGHT_IMAGE - 10, 45, HEIGHT_TITLE - 40)];
    emotionLabel.text = category;
    emotionLabel.backgroundColor = [self getEmotionLabelBackgroundColorByCategory:category];
    UIFont *fontOfEmotionLabel = [UIFont boldSystemFontOfSize:10.0f];
    emotionLabel.font = fontOfEmotionLabel;
    [emotionLabel showPlaceHolderWithLineColor:[UIColor redColor]];

    /*
     * set title
     */
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, HEIGHT_IMAGE - HEIGHT_TITLE, WIDTH_TITLE - 50, HEIGHT_TITLE)];
    //titleLabel.backgroundColor = [UIColor redColor];
    titleLabel.text = title;
    titleLabel.numberOfLines = 2;
    UIFont *fontOfTitle = [UIFont boldSystemFontOfSize: 20.0f];
    titleLabel.font = fontOfTitle;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    //titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel showPlaceHolderWithLineColor:[UIColor greenColor]];
    
    [containerView addSubview:imageView];
    [containerView addSubview:emotionLabel];
    [containerView addSubview:titleLabel];
    [cell.contentView addSubview:containerView];
//    [imageView showPlaceHolderWithLineColor:[UIColor redColor]];
    cell.contentView.backgroundColor = [UIColor colorWithWhite:0.996 alpha:1.000];
    
    return cell;
}

+ (UIColor *)getEmotionLabelBackgroundColorByCategory:(NSString *)category {
    if ([category isEqualToString:@"今日最好"]) {
        return [UIColor greenColor];
    } else if ([category isEqualToString:@"今日最乐"]) {
        return [UIColor yellowColor];
    } else if ([category isEqualToString:@"今日最惧"]) {
        return [UIColor grayColor];
    } else if ([category isEqualToString:@"今日最哀"]) {
        return [UIColor lightGrayColor];
    } else if ([category isEqualToString:@"今日最怒"]) {
       return [UIColor redColor];
    } else if ([category isEqualToString:@"今日最惊"]) {
        return [UIColor purpleColor];
    } else if ([category isEqualToString:@"今日最恶"]) {
        return [UIColor blackColor];
    } else {
        return [UIColor clearColor];
    }
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
