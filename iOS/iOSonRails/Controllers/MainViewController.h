//
//  MainViewController.h
//  iOSonRails
//
//  Created by huangmh on 3/21/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>
#import "HTTPClient.h"
#import "CommonView.h"
#import "Macro.h"
#import "Emotion.h"
#import "News.h"

@interface MainViewController: UIViewController <UIWebViewDelegate>

@property Emotion *emotion;
@property (strong,nonatomic) CMMotionManager *motionManager;

@property NSArray *news;
@property int activeNewsIndex;

- (id ) initWithEmotion:(Emotion *)emotion;

@end
