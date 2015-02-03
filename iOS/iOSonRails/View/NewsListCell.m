//
//  NewsListCell.m
//  TableViewCell
//
//  Created by huangmh on 1/25/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

#import "NewsListCell.h"
#import "News.h"
#import "SDWebImage/UIImageView+WebCache.h"

static float WIDTH_CONTENT = 250;
static float WIDTH_IMAGE = 250;
static float WIDTH_TITLE = 250;
static float WIDTH_PUB_DATE = 250;

static float HEIGHT_IMAGE = 100;
static float HEIGHT_TITLE = 50;
static float HEIGHT_PUB_DATE = 50;

static float WIDTH_SEP_LINE = 200;
static float WIDTH_CONTAINER_VIEW = 250;

@implementation NewsListCell

+ (id)initWithNews:(News *)news {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"Test"];
    
    float width = [[UIScreen mainScreen] bounds].size.width;
    
    float HEIGH_CONTAINER_VIEW = HEIGHT_IMAGE + HEIGHT_TITLE + HEIGHT_PUB_DATE + 1.0;
    UIView *containerView = [[UIView alloc] initWithFrame:CGRectMake(width/2 - WIDTH_CONTAINER_VIEW/2, 0, WIDTH_CONTAINER_VIEW, HEIGH_CONTAINER_VIEW)];
    //containerView.layer.borderWidth = 1.0;
    containerView.layer.backgroundColor = [UIColor whiteColor].CGColor;


    /* ++
     set image
     ++ */
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, WIDTH_IMAGE, HEIGHT_IMAGE)];
    if (![news.image isEqual:[NSNull null]]) {
        [imageView setImageWithURL:[NSURL URLWithString:news.image]
                   placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
     }

//UIImage *image = [UIImage imageNamed:news[@"image"]];
 //   imageView.image = image;
    
    /* ++
     set the shadow effect
     ++ */
    containerView.layer.shadowColor=[[UIColor grayColor] CGColor];
    containerView.layer.cornerRadius = 8;
    containerView.layer.shadowOffset = CGSizeMake(2, 2);
    containerView.layer.shadowOpacity = 4.0;
    containerView.layer.shadowRadius = 4.0;

    /* ++
     set title
     ++ */
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, HEIGHT_IMAGE, WIDTH_TITLE, HEIGHT_TITLE)];
    //titleLabel.backgroundColor = [UIColor redColor];
    titleLabel.text = news.title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    /* ++
     set bottomline of title
     ++ */
    UILabel *titleBottomline = [[UILabel alloc] initWithFrame:CGRectMake(WIDTH_CONTAINER_VIEW/2 - WIDTH_SEP_LINE/2, HEIGHT_IMAGE + HEIGHT_TITLE, WIDTH_SEP_LINE, 1.0)];
    titleBottomline.layer.borderColor = [UIColor purpleColor].CGColor;
    titleBottomline.layer.borderWidth = 1;
    
    /* ++
     set the pubDate
     ++ */
    UILabel *pubDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, HEIGHT_IMAGE + HEIGHT_TITLE + 1.0, WIDTH_PUB_DATE, HEIGHT_PUB_DATE)];
    pubDataLabel.text = news.pubDate;
    pubDataLabel.textAlignment = NSTextAlignmentCenter;
    pubDataLabel.textColor = [UIColor lightGrayColor];
    UIFont *font = [UIFont fontWithName:@"Arial" size:10.0f];
    pubDataLabel.font = font;
    
    titleBottomline.layer.borderWidth = 1;
    [containerView addSubview:titleLabel];
    [containerView addSubview:titleBottomline];
    [containerView addSubview:imageView];
    [containerView addSubview:pubDataLabel];
    [cell.contentView addSubview:containerView];
//    [imageView showPlaceHolderWithLineColor:[UIColor redColor]];
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
