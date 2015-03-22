//
//  NavViewController.m
//  iOSonRails
//
//  Created by huangmh on 3/21/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

#import "NavViewController.h"
#import "NavSubView.h"
#import "News.h"

@interface NavViewController ()

@property NSArray *topNewsList;
@property NSArray *categorys;

@property NSMutableArray *views;
@property int index;

@end

@implementation NavViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    
    News *new0 = [[News alloc] initWithDictionary:@{@"title": @"缅甸总统：果敢冲突是内部事务 中国无法解决",
                                                    @"link": @"http://news.163.com/15/0321/10/AL7N01GH0001121M.html",
                                                    @"picture": @"http://img3.cache.netease.com/cnews/2015/3/21/20150321102847189e4.jpg"
                                                    }];
    News *new1 = [[News alloc] initWithDictionary:@{@"title": @"中缅边境事件进展：缅方赔遇难者7万元消息不实",
                                                    @"link": @"http://news.163.com/15/0320/15/AL5LQ6AS0001124J.html",
                                                    @"picture": @"http://img4.cache.netease.com/photo/0001/2015-03-21/900x600_AL7OUVCN00AP0001.jpg"
                                                    }];
    News *new2 = [[News alloc] initWithDictionary:@{@"title": @"中日韩开外长会 王毅称中韩与日关系严重受干扰",
                                                    @"link": @"http://news.163.com/15/0321/18/AL8HTFMU00014SEH.html",
                                                    @"picture": @"http://img1.cache.netease.com/catchpic/5/53/5348703CF58E09ED100E81DD3938693F.jpg"
                                                    }];
    News *new3 = [[News alloc] initWithDictionary:@{@"title": @"依偎习近平合影女孩长大 其父系感动中国人物",
                                                    @"link": @"http://news.163.com/15/0321/02/AL6SBT3000014AED.html",
                                                    @"picture": @"http://img1.cache.netease.com/catchpic/B/B9/B9381E9677E20EB85799F616D2EDCC78.jpg"
                                                    }];
    News *new4 = [[News alloc] initWithDictionary:@{@"title": @"南京军区原司令员:周永康徐才厚等人可耻可",
                                                    @"link": @"http://news.163.com/15/0321/20/AL8Q86K80001124J.html",
                                                    @"picture": @"http://img4.cache.netease.com/cnews/2015/3/21/20150321204313d0176.jpg"
                                                    }];
    News *new5 = [[News alloc] initWithDictionary:@{@"title": @"昆明人大决定罢免仇和省人大代表职务",
                                                    @"link": @"http://news.163.com/15/0321/15/AL889A8O0001124J.html",
                                                    @"picture": @"http://img4.cache.netease.com/photo/0001/2015-03-15/900x600_AKOPRICE00AN0001.jpg"
                                                    }];
    News *new6 = [[News alloc] initWithDictionary:@{@"title": @"北京市长：北京暂不考虑放开住房限购",
                                                    @"link": @"http://news.163.com/15/0321/19/AL8KCVI600014JB5.html",
                                                    @"picture": @""
                                                    }];
    self.topNewsList = @[new0, new1, new2, new3, new4, new5, new6];
    self.categorys = @[@"今日最好", @"今日最乐", @"今日最哀", @"今日最惧", @"今日最恶", @"今日最怒", @"今日最惊"];
    
    self.views = [[NSMutableArray alloc] init];
    for (int i = 0; i < 7; i++) {
        News *news = self.topNewsList[i];
        NavSubView *view = [NavSubView initWithEmotionCategory: self.categorys[i]
                                                    coverImage: news.image
                                                         title: news.title];
        [self.views addObject:view];
    }
    [self setViewWithIndex:0];
    // Do any additional setup after loading the view.
    
}

- (void)setViewWithIndex:(int)index {
    if ((index >= 0) && (index < 6)) {
        self.view = self.views[index];
        self.index = index;
    }
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];

    [swipeLeft setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRight setDirection:UISwipeGestureRecognizerDirectionRight];
    
    // Adding the swipe gesture on image view
    [self.view addGestureRecognizer:swipeLeft];
    [self.view addGestureRecognizer:swipeRight];
}


- (void) handleSwipe:(UISwipeGestureRecognizer *)swipe {
    if (swipe.direction == UISwipeGestureRecognizerDirectionLeft) {
        if ((self.index >= 0) && (self.index < 6)) {
            int index = self.index - 1;
            [self setViewWithIndex:index];
        }
    }
    
    if (swipe.direction == UISwipeGestureRecognizerDirectionRight) {
        if ((self.index >= 0) && (self.index < 6)) {
            int index = self.index + 1;
            [self setViewWithIndex:index];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
