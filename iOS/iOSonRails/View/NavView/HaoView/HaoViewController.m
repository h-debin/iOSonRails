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
    /*
     * TODO: should get from Server via REST API
     */
    self.news = [[NSMutableArray alloc] init];
    News *n1 = [[News alloc] init];
    n1.title = @"马兴瑞兼任深圳书记 级别首次高于省会广州";
    n1.link = @"http://news.163.com/15/0326/20/ALLLMN790001124J.html";
    n1.image = @"http://img1.cache.netease.com/catchpic/B/B8/B860BDDC03916BF1AA3122B825F31ECA.jpg";
    
    News *n2 = [[News alloc] init];
    n2.title = @"杨洁篪前往新加坡驻华使馆吊唁李光耀逝世";
    n2.link = @"http://news.163.com/15/0326/14/ALL23H0S000146BE.html";
    n2.image = @"http://img6.cache.netease.com/cnews/2015/3/26/2015032614573436dc0_550.jpg";
    
    [self.news addObject:n1];
    [self.news addObject:n2];
    
    self.activeNewsIndex = 0;
    
   // self.coverCategory = @"今日最好";
    //self.coverImage = @"http://img3.cache.netease.com/cnews/2015/3/21/20150321102847189e4.jpg";
    //self.coverTitle = @"缅甸总统：果敢冲突是内部事务 中国无法解决";
    
    self.motionManager = [[CMMotionManager alloc] init];//一般在viewDidLoad中进行
    self.motionManager.accelerometerUpdateInterval = .1;//加速仪更新频率，以秒为单位
}

@end
    