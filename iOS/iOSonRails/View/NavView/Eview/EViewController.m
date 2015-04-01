//
//  NavViewController.m
//  iOSonRails
//
//  Created by huangmh on 3/21/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

// * hao -> le -> jing -> ai -> ju -> e -> nu
#import "EViewController.h"

@implementation EViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.type = E;
    self.from = JU;
    self.to = NU;
    
    self.motionManager = [[CMMotionManager alloc] init];//一般在viewDidLoad中进行
    self.motionManager.accelerometerUpdateInterval = .1;//加速仪更新频率，以秒为单位
    
    self.news = [[NSArray alloc] initWithArray:[News newsWithEmotionType:self.type]];
}

@end