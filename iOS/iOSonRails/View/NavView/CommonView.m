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
#import "MONActivityIndicatorView.h"
#import "SDWebImage/UIImageView+WebCache.h"

@interface CommonView() <MONActivityIndicatorViewDelegate>

@property MONActivityIndicatorView *indicatorView;

@end

@implementation CommonView

- (void) prepareIndicator {
    self.indicatorView = [[MONActivityIndicatorView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT/2, SCREEN_WIDTH, 20)];
    self.indicatorView.center =CGPointMake(SCREEN_WIDTH/2 + 40, SCREEN_HEIGHT/2);
    self.indicatorView.delegate = self;
    self.indicatorView.numberOfCircles = 3;
    self.indicatorView.radius = 5;
    self.indicatorView.internalSpacing = 3;
    self.indicatorView.duration = 0.5;
    self.indicatorView.delay = 0.5;
    
    [self addSubview:self.indicatorView];
}

- (void) startIndicatorAnimation {
    [self.indicatorView startAnimating];
}

- (void) stopIndicatorAnimation {
    [self.indicatorView stopAnimating];
}

- (id )initWithNews:(News *)news {
    if (self == [super init]) {
        float WIDTH_IMAGE = SCREEN_WIDTH;
        float WIDTH_TITLE = WIDTH_IMAGE;

        float HEIGHT_IMAGE = SCREEN_HEIGHT;
        static float HEIGHT_TITLE = 50;

        UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        containerView.layer.backgroundColor = [UIColor whiteColor].CGColor;

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_IMAGE, HEIGHT_IMAGE)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        UILabel *emotionLabel = [[UILabel alloc] initWithFrame:CGRectMake(2,  SCREEN_HEIGHT - 35, 20, 20)];
        emotionLabel.text = news.newsEmotionType;
        emotionLabel.textAlignment = NSTextAlignmentCenter;
        emotionLabel.numberOfLines = 4;
        UIFont *fontOfEmotionLabel = [UIFont boldSystemFontOfSize:10.0f];
        emotionLabel.font = fontOfEmotionLabel;
        emotionLabel.layer.masksToBounds = YES;
        emotionLabel.layer.cornerRadius = 10;
        emotionLabel.backgroundColor = [self randomColor];

        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, HEIGHT_IMAGE - HEIGHT_TITLE, WIDTH_TITLE - 50, HEIGHT_TITLE)];
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
        if (![news.newsPicture isEqual:[NSNull null]]) {
            [self prepareIndicator];
            [self startIndicatorAnimation];
            [imageView sd_setImageWithURL:[NSURL URLWithString:news.newsPicture]
                                completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL){
                                    [self stopIndicatorAnimation];
                                    if(error != nil) {
                                        NSLog(@"image set error for cover since %@ with %@", [error localizedDescription], imageURL);
                                    }
            }];
        }
    }
    
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    // Configure the view for the selected state
}

- (UIColor *) randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

#pragma mark -
#pragma mark - Centering Indicator View

- (void)placeAtTheCenterWithView:(UIView *)view {
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.0f
                                                           constant:0.0f]];
    
    [self addConstraint:[NSLayoutConstraint constraintWithItem:view
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0f
                                                           constant:0.0f]];
}

#pragma mark -
#pragma mark - MONActivityIndicatorViewDelegate Methods

- (UIColor *)activityIndicatorView:(MONActivityIndicatorView *)activityIndicatorView
      circleBackgroundColorAtIndex:(NSUInteger)index {
    CGFloat red   = (arc4random() % 256)/255.0;
    CGFloat green = (arc4random() % 256)/255.0;
    CGFloat blue  = (arc4random() % 256)/255.0;
    CGFloat alpha = 1.0f;
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

@end
