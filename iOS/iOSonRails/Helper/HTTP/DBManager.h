//
//  DBManager.h
//  iOSonRails
//
//  Created by huangmh on 4/6/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DBManager : NSObject

+ (void) setupDB;
+ (NSString *) dbStore;
+ (void) cleanAndResetupDB;

@end
