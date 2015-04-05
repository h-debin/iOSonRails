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

@property BOOL networkOn;

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
                      uuid:(NSString *)uuid
                     token:(NSString *)token
                 parameter:(NSDictionary *)params
                   success:(void (^)(id JSON))successHandler
                   failure:(void (^)(NSError *error))failureHandler;

- (void)postWithAccessToken:(NSString *)url
                      uuid:(NSString *)uuid
                      token:(NSString *)token
                  parameter:(NSDictionary *)params
                    success:(void (^)(id JSON))successHandler
                    failure:(void (^)(NSError *error))failureHandler;

@end
