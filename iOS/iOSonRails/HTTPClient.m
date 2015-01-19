//
//  HTTPClient.m
//  iOSonRails
//
//  Created by huangmh on 1/9/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

#import "HTTPClient.h"
#import "UserManager.h"
#import "Macro.h"


@implementation HTTPClient

+ (id)sharedHTTPClient {
    static HTTPClient *sharedHTTPClient = nil;
    
    @synchronized(self) {
        if (sharedHTTPClient == nil) {
            sharedHTTPClient = [[self alloc] init];
        }
    }
    return sharedHTTPClient;
}

- (void)request:(NSString *)url parameter:(NSDictionary *)params method:(NSString *)method success:(void (^)(id))successHandler failure:(void (^)(NSError *))failureHandler {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[[UserManager sharedUserManager] getUUID] forHTTPHeaderField: @"UUID"];
    [manager.requestSerializer setValue:[[UserManager sharedUserManager] getToken] forHTTPHeaderField: @"Token"];
    if ([method isEqualToString:@"GET"]) {
        [manager GET:url parameters:params
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 successHandler(responseObject);
             }
             failure:^(AFHTTPRequestOperation *operation, NSError  *error) {
                 failureHandler(error);
             }
         ];
    } else if( [method isEqualToString:@"POST"]) {
        [manager POST:url parameters:params
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 successHandler(responseObject);
             }
             failure:^(AFHTTPRequestOperation *operation, NSError  *error) {
                 failureHandler(error);
             }
         ];
    } else {
        NSError *error = [[NSError alloc] initWithDomain:@"HTTPClient"
                                                    code:1
                                                userInfo:@{@"error": @"only GET and POST support"}
                          ];
        failureHandler(error);
    }
}

- (void)get:(NSString *)url parameter:(NSDictionary *)params success:(void (^)(id))successHandler failure:(void (^)(NSError *))failureHandler {
    [self request:url parameter:params method:@"GET" success:successHandler failure:failureHandler];
}

- (void)post:(NSString *)url parameter:(NSDictionary *)params success:(void (^)(id))successHandler failure:(void (^)(NSError *))failureHandler {
    [self request:url parameter:params method:@"POST" success:successHandler failure:failureHandler];
}

- (void)getWithAccessToken:(NSString *)url uuid:(NSString *)uuid token:(NSString *)token parameter:(NSDictionary *)params success:(void (^)(id))successHandler failure:(void (^)(NSError *))failureHandler {
    NSMutableDictionary *paramsWithToken = [[NSMutableDictionary alloc] initWithDictionary:params];
    [paramsWithToken setObject:token forKey:@"token"];
    [paramsWithToken setObject:uuid forKey:@"uuid"];
    [self request:url
        parameter:paramsWithToken
           method:@"GET"
          success:successHandler
          failure:failureHandler
     ];
}

- (void)postWithAccessToken:(NSString *)url uuid:(NSString *)uuid token:(NSString *)token parameter:(NSDictionary *)params success:(void (^)(id))successHandler failure:(void (^)(NSError *))failureHandler {
    NSMutableDictionary *paramsWithToken = [[NSMutableDictionary alloc] initWithDictionary:params];
    [paramsWithToken setObject:token forKey:@"token"];
    [paramsWithToken setObject:uuid forKey:@"uuid"];
    [self request:url
        parameter:paramsWithToken
           method:@"POST"
          success:successHandler
          failure:failureHandler
     ];
}

@end
