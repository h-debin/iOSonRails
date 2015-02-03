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

- (BOOL)networkIsAvailable {
    return [AFNetworkReachabilityManager sharedManager].isReachable ? YES : NO;
}

- (NSString *)getEtag:(NSURLRequest *)request {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSLog(@"Path: %@", paths);
    NSLog(@"Log: %@", request.URL);
    NSString *filename = [[paths objectAtIndex:0] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", request.URL]];
    NSLog(@"Filename: %@", filename);
    NSString *etag = [NSKeyedUnarchiver unarchiveObjectWithFile:filename];
    return etag;
}

- (void)request:(NSString *)url parameter:(NSDictionary *)params method:(NSString *)method success:(void (^)(id))successHandler failure:(void (^)(NSError *))failureHandler {
    NSMutableURLRequest *mutableRequest =[[AFHTTPRequestSerializer serializer]
                                          requestWithMethod:method
                                                  URLString:url
                                                 parameters:params
                                                      error:nil];
    /**
     *  use different cache policy according to network status
     */
    if ([self networkIsAvailable]) {
        [mutableRequest setCachePolicy: NSURLRequestReloadIgnoringCacheData];
    } else {
        [mutableRequest setCachePolicy: NSURLRequestReturnCacheDataElseLoad];
    }
    
    NSLog(@"Etag: %@", [self getEtag:mutableRequest]);

    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:mutableRequest];
    requestOperation.responseSerializer = [AFJSONResponseSerializer serializer];
    [mutableRequest setValue:[[UserManager sharedUserManager] getUUID] forHTTPHeaderField: @"UUID"];
    [mutableRequest setValue:[[UserManager sharedUserManager] getToken] forHTTPHeaderField: @"Token"];
    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self cachedResponseObject:operation];
        successHandler(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        failureHandler(error);
    }];
    [requestOperation start];
}

- (id)cachedResponseObject:(AFHTTPRequestOperation *)operation{
    
    NSCachedURLResponse* cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:operation.request];
    AFHTTPResponseSerializer* serializer = [AFJSONResponseSerializer serializer];
    id responseObject = [serializer responseObjectForResponse:cachedResponse.response data:cachedResponse.data error:nil];
    return responseObject;
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
