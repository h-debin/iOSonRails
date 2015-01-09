//
//  UserManager.h
//  iOSonRails
//
//  Created by huangmh on 1/9/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserManager : NSObject

+ (id)sharedUserManager;

- (NSString *)getUUID;
- (NSString *)getToken;
- (void)saveUUIDToKeyChain:(NSString *)uuid;
- (void)saveTokenToKeyChain:(NSString *)token;

@end
