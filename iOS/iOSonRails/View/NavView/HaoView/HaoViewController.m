//
//  NavViewController.m
//  iOSonRails
//
//  Created by huangmh on 3/21/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

// * hao -> le -> jing -> ai -> ju -> e -> nu

#import "HaoViewController.h"

@implementation HaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.type = HAO;
    self.from = NU;
    self.to = LE;
    self.activeNewsIndex = 0;
    
    self.motionManager = [[CMMotionManager alloc] init];//一般在viewDidLoad中进行
    self.motionManager.accelerometerUpdateInterval = .1;//加速仪更新频率，以秒为单位
    
    [self loadDataFromCoreData];
}

- (void) loadDataFromCoreData {
    NSArray *newsList = [News MR_findByAttribute:@"newsEmotionType" withValue:@"好"];
    self.news = [[NSMutableArray alloc] initWithArray:newsList];
}

@end
    