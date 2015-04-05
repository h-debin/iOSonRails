//
//  NewsWebViewController.h
//  iOSonRails
//
//  Created by huangmh on 3/24/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "News.h"

@class NewsWebViewController;
@protocol NewsWebViewControllerDelegate <NSObject>
-(void) newsWebViewControllerSwippedRight:(NewsWebViewController *)newsWebViewController;
@end

@interface NewsWebViewController : UIViewController <UIWebViewDelegate>

@property (nonatomic, weak) id<NewsWebViewControllerDelegate> delegate;

@property NSString *link;

- (id ) initWithNews:(News *)news;

@end
