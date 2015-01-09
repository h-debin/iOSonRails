//
//  HTTPClient.h
//  iOSonRails
//
//  Created by huangmh on 1/9/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface HTTPClient : NSObject

+ (id)sharedHTTPClient;

- (void)get:(NSString *)url
  parameter:(NSDictionary *)params
    success:(void (^)(id JSON))successHandler
    failure:(void (^)(NSError *error))failureHandler;

- (void)post:(NSString *)url
   parameter:(NSDictionary *)params
     success:(void (^)(id JSON))successHandler
     failure:(void (^)(NSError *error))failureHandler;

- (void)getWithAccessToken:(NSString *)url
                     token:(NSString *)token
                 parameter:(NSDictionary *)params
                   success:(void (^)(id JSON))successHandler
                   failure:(void (^)(NSError *error))failureHandler;

- (void)postWithAccessToken:(NSString *)url
                      token:(NSString *)token
                  parameter:(NSDictionary *)params
                    success:(void (^)(id JSON))successHandler
                    failure:(void (^)(NSError *error))failureHandler;

@end
