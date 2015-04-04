//
//  NewsListCell.m
//  TableViewCell
//
//  Created by huangmh on 1/25/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

#import "NavSubView.h"
#import "Macro.h"
#import "MMPlaceHolder.h"
#import "SDWebImage/UIImageView+WebCache.h"


@implementation NavSubView

+ (id)initWithEmotionCategory:(NSString *)category coverImage:(NSString *)coverImage title:(NSString *)title {
    float WIDTH_IMAGE = SCREEN_WIDTH;
    float WIDTH_TITLE = WIDTH_IMAGE;

    float HEIGHT_IMAGE = SCREEN_HEIGHT;
    static float HEIGHT_TITLE = 50;

    float WIDTH_CONTAINER_VIEW = WIDTH_IMAGE;
    
    float HEIGH_CONTAINER_VIEW = HEIGHT_IMAGE;
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_CONTAINER_VIEW, HEIGH_CONTAINER_VIEW)];
    //containerView.layer.borderWidth = 1.0;
    containerView.layer.backgroundColor = [UIColor whiteColor].CGColor;
    //[containerView showPlaceHolderWithLineColor:[UIColor blueColor]];


    /* ++
     set image
     ++ */
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_IMAGE, HEIGHT_IMAGE)];
    if (![coverImage isEqual:[NSNull null]]) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:coverImage]
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                                if(error != nil) {
                                    NSLog(@"image set error for cover since %@ with %@", [error localizedDescription], imageURL);
                                }
        }];
    }
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    UILabel *emotionLabel = [[UILabel alloc] initWithFrame:CGRectMake(2,  HEIGHT_IMAGE - 45, 15, 15)];
    emotionLabel.text = category;
    emotionLabel.numberOfLines = 4;
    UIFont *fontOfEmotionLabel = [UIFont boldSystemFontOfSize:10.0f];
    emotionLabel.font = fontOfEmotionLabel;
    emotionLabel.layer.masksToBounds = YES;
    emotionLabel.layer.cornerRadius = 8;
    emotionLabel.backgroundColor = [UIColor redColor];

    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, HEIGHT_IMAGE - HEIGHT_TITLE, WIDTH_TITLE - 50, HEIGHT_TITLE)];
    titleLabel.text = title;
    titleLabel.numberOfLines = 2;
    UIFont *fontOfTitle = [UIFont boldSystemFontOfSize: 20.0f];
    titleLabel.font = fontOfTitle;
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    
    [containerView addSubview:imageView];
    [containerView addSubview:emotionLabel];
    [containerView addSubview:titleLabel];
    
    return containerView;
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
    // Configure the view for the selected state
}

@end
