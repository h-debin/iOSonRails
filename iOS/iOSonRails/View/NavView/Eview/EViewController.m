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
    /*
     * TODO: should get from Server via REST API
     */
    self.coverCategory = @"今日最恶";
    self.coverImage = @"http://img.xiaba.cvimage.cn/4cc02705faaa3a507e4e0300.jpg";
    self.coverTitle = @"缅甸总统：果敢冲突是内部事务 中国无法解决";
    
    self.motionManager = [[CMMotionManager alloc] init];//一般在viewDidLoad中进行
    self.motionManager.accelerometerUpdateInterval = .1;//加速仪更新频率，以秒为单位
}

@end