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

- (NSString *)getEtag:(NSURLRequest *)request {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *filename = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", request.URL]];
    NSString *etag = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
    return etag;
}

- (void)request:(NSString *)url parameter:(NSDictionary *)params method:(NSString *)method success:(void (^)(id))successHandler failure:(void (^)(NSError *))failureHandler {
    NSMutableURLRequest *mutableRequest =[[AFHTTPRequestSerializer serializer]
                                          requestWithMethod:method
                                                  URLString:url
                                                 parameters:params
                                                      error:nil];

    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:mutableRequest];
    requestOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    [mutableRequest setValue:[[UserManager sharedUserManager] getUUID] forHTTPHeaderField: @"UUID"];
    [mutableRequest setValue:[[UserManager sharedUserManager] getToken] forHTTPHeaderField: @"Token"];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        successHandler(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureHandler(error);
    }];
    [requestOperation start];
}
/**

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setValue:[[UserManager sharedUserManager] getUUID] forHTTPHeaderField: @"UUID"];
    [manager.requestSerializer setValue:[[UserManager sharedUserManager] getToken] forHTTPHeaderField: @"Token"];
    [manager.requestSerializer setValue:etag forHTTPHeaderField:@"If-None-Match"];
    
    if ([method isEqualToString:@"GET"]) {
        [manager GET:url parameters:params
             success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 successHandler(responseObject);
                 NSLog(@"%@",operation.response.allHeaderFields[@"Etag"]);
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
 */

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
