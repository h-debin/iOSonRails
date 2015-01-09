//
//  UserManager.m
//  iOSonRails
//
//  Created by huangmh on 1/9/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

#import "UserManager.h"
#import "UICKeyChainStore.h"

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
        return [self getUUIDFromDevice];
    }
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