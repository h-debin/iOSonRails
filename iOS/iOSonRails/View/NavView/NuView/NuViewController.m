//
//  NavViewController.m
//  iOSonRails
//
//  Created by huangmh on 3/21/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

// * hao -> le -> jing -> ai -> ju -> e -> nu
#import "NuViewController.h"

@implementation NuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.type = NU;
    self.from = E;
    self.to = HAO;
    
    self.news = [[NSArray alloc] initWithArray:[News newsWithEmotionType:self.type]];
}

@end