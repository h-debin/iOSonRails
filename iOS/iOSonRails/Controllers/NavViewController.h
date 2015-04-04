//
//  NavViewController.h
//  iOSonRails
//
//  Created by huangmh on 3/21/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "NewsWebViewController.h"
#import "HTTPClient.h"
#import "NavSubView.h"
#import "Macro.h"
#import "Emotion.h"
#import "News.h"

@interface NavViewController: UIViewController <UIWebViewDelegate>

@property Emotion *emotion;

@property (strong,nonatomic) CMMotionManager *motionManager;

@property NSString *coverImage;
@property NSString *coverTitle;
@property NSString *coverCategory;

@property NSArray *news;
@property int activeNewsIndex;

- (id ) initWithEmotion:(Emotion *)emotion;

@end
