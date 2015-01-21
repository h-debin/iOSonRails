//
//  NewsListViewController.m
//  iOSonRails
//
//  Created by huangmh on 1/18/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

#import "NewsListViewController.h"
#import "SVPullToRefresh.h"
#import "HTTPClient.h"
#import "UserManager.h"
#import "Macro.h"
#import "News.h"
#import "NewsItemCell.h"

@interface NewsListViewController()

@property UITableView *tableView;
@property NSMutableArray *newsList;

@end

@implementation NewsListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.newsList = [[NSMutableArray alloc] init];
    [self setupTableView];
}

- (void)setupTableView {
    self.tableView = [[UITableView alloc] initWithFrame:
                      CGRectMake(0,
                                 0,
                                 CGRectGetWidth([[UIScreen mainScreen] bounds]),
                                 CGRectGetHeight([[UIScreen mainScreen] bounds]) - 84)
                                                  style:UITableViewStylePlain
                      ];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    //[self.tableView showPlaceHolderWithLineColor:[UIColor redColor]];
    //[self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    /*
    __weak NewsListViewController *weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf requestNews];
    }];
    
    // setup infinite scrolling
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf requestNews];
    }];
    */
    [self requestNews];
}

- (void)requestNews {
    HTTPClient *sharedClient = [HTTPClient sharedHTTPClient];
    [sharedClient get:@NEWS_URL
            parameter:@{}
              success:^(id JSON) {
                  for (int i = 0; i < [JSON count]; i++) {
                      News *news = [[News alloc] initWithDictionary:JSON[i]];
                      [self.newsList addObject:news];
                  }
                  [self.tableView reloadData];
              } failure:^(NSError *error) {
                  NSLog(@"%@", [error localizedDescription]);
              }
     ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.newsList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NewsItemCell *cell = [[NewsItemCell alloc] initWithNews:self.newsList[indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

@end
