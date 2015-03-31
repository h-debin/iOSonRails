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
    self.news = [[NSMutableArray alloc] init];
    News *n1 = [[News alloc] init];
    
    News *n2 = [[News alloc] init];
    
    [self.news addObject:n1];
    [self.news addObject:n2];
    
    self.motionManager = [[CMMotionManager alloc] init];//一般在viewDidLoad中进行
    self.motionManager.accelerometerUpdateInterval = .1;//加速仪更新频率，以秒为单位
}

@end