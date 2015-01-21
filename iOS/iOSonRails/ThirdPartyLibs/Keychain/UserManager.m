//
//  UserManager.m
//  iOSonRails
//
//  Created by huangmh on 1/9/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

#import "UserManager.h"
#import "UICKeyChainStore.h"
#import "AFNetworking.h"
#import "Macro.h"

@implementation UserManager

+ (id)sharedUserManager {
    static UserManager *userManager = nil;
    
    @synchronized(self) {
        if (userManager == nil) {
            userManager = [[UserManager alloc] init];
        }
    }
    return userManager;
}

- (NSString *)getUUID {
    NSString *uuid = [self getUUIDFromKeyChain];
    if (uuid) {
        return uuid;
    } else {
        uuid = [self getUUIDFromDevice];
        [self saveUUIDToKeyChain:uuid];
        return uuid;
    }
}

- (NSString *)getToken {
    NSString *token = [self getTokenFromKeyChain];
    if (token == nil) {
        [self requestTokenFromServer];
    }
    return token;
}

- (void)requestTokenFromServer {
    NSDictionary *params = @{ @"uuid": [self getUUID] };
   
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:@TOKEN_REQUEST_URL
       parameters:params
          success:^(AFHTTPRequestOperation *operation, id JSON) {
              [self saveTokenToKeyChain:JSON[@"token"]];
          }
          failure:^(AFHTTPRequestOperation *operation, NSError *error) {
              NSLog(@"Error: cannot requst token %@", [error localizedDescription]);
          }
     ];
}

- (NSString *)getUUIDFromDevice {
    CFUUIDRef puuid = CFUUIDCreate(nil);
    CFStringRef uuidString = CFUUIDCreateString(nil, puuid);
    return (NSString *)CFBridgingRelease(CFStringCreateCopy(NULL, uuidString));
}

- (NSString *)getUUIDFromKeyChain {
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"api.newsi.care"];
    return store[@"uuid"];
}

- (NSString *)getTokenFromKeyChain {
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"api.newsi.care"];
    return store[@"token"];
}

- (void)saveTokenToKeyChain:(NSString *)token {
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"api.newsi.care"];
    [store setString:token forKey:@"token"];
    [store synchronize];
}

- (void)saveUUIDToKeyChain:(NSString *)uuid {
    UICKeyChainStore *store = [UICKeyChainStore keyChainStoreWithService:@"api.newsi.care"];
    [store setString:uuid forKey:@"uuid"];
    [store synchronize];
}

@end