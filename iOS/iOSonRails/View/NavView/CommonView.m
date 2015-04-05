//
//  NewsListCell.m
//  TableViewCell
//
//  Created by huangmh on 1/25/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

#import "CommonView.h"
#import "Macro.h"
#import "MMPlaceHolder.h"
#import "SDWebImage/UIImageView+WebCache.h"


@implementation CommonView

- (id )initWithNews:(News *)news {
    if (self == [super init]) {
        float WIDTH_IMAGE = SCREEN_WIDTH;
        float WIDTH_TITLE = WIDTH_IMAGE;

        float HEIGHT_IMAGE = SCREEN_HEIGHT;
        static float HEIGHT_TITLE = 50;

        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        containerView.layer.backgroundColor = [UIColor whiteColor].CGColor;
        //[containerView showPlaceHolderWithLineColor:[UIColor blueColor]];

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_IMAGE, HEIGHT_IMAGE)];
        if (![news.newsPicture isEqual:[NSNull null]]) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:news.newsPicture]
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                                    if(error != nil) {
                                        NSLog(@"image set error for cover since %@ with %@", [error localizedDescription], imageURL);
                                    }
            }];
        }
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        UILabel *emotionLabel = [[UILabel alloc] initWithFrame:CGRectMake(2,  SCREEN_HEIGHT - 45, 15, 15)];
        emotionLabel.text = news.newsEmotionType;
        emotionLabel.numberOfLines = 4;
        UIFont *fontOfEmotionLabel = [UIFont boldSystemFontOfSize:10.0f];
        emotionLabel.font = fontOfEmotionLabel;
        emotionLabel.layer.masksToBounds = YES;
        emotionLabel.layer.cornerRadius = 8;
        emotionLabel.backgroundColor = [UIColor redColor];

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, HEIGHT_IMAGE - HEIGHT_TITLE, WIDTH_TITLE - 50, HEIGHT_TITLE)];
        titleLabel.text = news.newsTitle;
        titleLabel.numberOfLines = 2;
        UIFont *fontOfTitle = [UIFont boldSystemFontOfSize: 20.0f];
        titleLabel.font = fontOfTitle;
        titleLabel.backgroundColor = [UIColor clearColor];
        titleLabel.textColor = [UIColor whiteColor];
        
        [containerView addSubview:imageView];
        [containerView addSubview:emotionLabel];
        [containerView addSubview:titleLabel];
        [self addSubview:containerView];
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    // Configure the view for the selected state
}

@end
