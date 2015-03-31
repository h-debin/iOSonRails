//
//  StartViewController.m
//  iOSonRails
//
//  Created by huangmh on 3/31/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

#import "StartViewController.h"
#import "DeviceInfo.h"
#import "Macro.h"
#import "CoreData+MagicalRecord.h"
#import "News.h"
#import "HTTPClient.h"
#import "MMPlaceHolder.h"

@interface StartViewController ()

@property UIActivityIndicatorView *activityView;

@property NSMutableDictionary *news;

@end

@implementation StartViewController

- (void) viewDidLoad {
    [self startLoaderIndicator];
    
    [self loadDataFromServer];
}

- (void) startLoaderIndicator {
    self.activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.activityView.center = self.view.center;
    [self.activityView showPlaceHolderWithLineColor:[UIColor redColor]];
    [self.view addSubview:self.activityView];
    
    [self.activityView startAnimating];
}

- (void) loadDataFromServer {
    self.news = [[NSMutableDictionary alloc] init];
    for(int i = 0; i < 7; i++) {
        NSString *typeKey = [self getNewsKeyWithType:i];
        self.news[typeKey] = [[NSMutableArray alloc] init];
        [self requestNewsWithType:i];
    }
}

- (NSString *) getNewsKeyWithType:(int )type {
    switch (type) {
        case 0:
            return @"好";
        case 1:
            return @"乐";
        case 2:
            return @"惊";
        case 3:
            return @"哀";
        case 4:
            return @"惧";
        case 5:
            return @"恶";
        case 6:
            return @"怒";
        default:
            return @"";
    }
}

- (void) requestNewsWithType:(int )type {
    NSString *typeName = [self getNewsKeyWithType:type];
    [[HTTPClient sharedHTTPClient] get:@"http://api.minghe.me/api/v1/news"
                             parameter:@{@"emotion_type": typeName}
                               success:^(id JSON) {
                                   for(int i = 0; i < [JSON count]; i++) {
                                       if(![News isTitleExist:JSON[i][@"title"]]) {
                                           News *tmpNews = [News MR_createEntity];
                                           tmpNews = [tmpNews initWithDictionary:JSON[i]];
                                           [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreWithCompletion: ^(BOOL success, NSError *error) {
                                               if(success) {
                                                   NSLog(@"saved OK");
                                               } else {
                                                   NSLog(@"saving error -> %@ ", [error localizedDescription]);
                                               }
                                               
                                           }];
                                       } else {
                                           NSLog(@"already have");
                                       }
                                       //News *tmp = [[News alloc] initWithDictionary:JSON[i]];
                                       //[self.news[typeName] addObject:tmp];
                                   }
                               }
                               failure:^(NSError *error){
                                   NSLog(@"%@", [error localizedDescription]);
                               }];
    
}

- (void) viewDidAppear:(BOOL)animated {
    
}

@end
