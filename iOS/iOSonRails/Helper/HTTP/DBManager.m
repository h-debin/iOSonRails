//
//  DBManager.m
//  iOSonRails
//
//  Created by huangmh on 4/6/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

#import "DBManager.h"
#import "CoreData+MagicalRecord.h"

@implementation DBManager

+ (void)setupDB
{
    [MagicalRecord setupCoreDataStackWithAutoMigratingSqliteStoreNamed:[self dbStore]];
}

+ (NSString *)dbStore
{
    NSString *bundleID = (NSString *)[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleIdentifierKey];
    return [NSString stringWithFormat:@"%@.sqlite", bundleID];
}

+ (void)cleanAndResetupDB
{
    NSString *dbStore = [self dbStore];
    
    NSError *error = nil;
    
    NSURL *storeURL = [NSPersistentStore MR_urlForStoreName:dbStore];
    
    [MagicalRecord cleanUp];
    
    if([[NSFileManager defaultManager] removeItemAtURL:storeURL error:&error]){
        [self setupDB];
    }
    else{
        NSLog(@"An error has occurred while deleting %@", dbStore);
        NSLog(@"Error description: %@", error.description);
    }
}

@end
