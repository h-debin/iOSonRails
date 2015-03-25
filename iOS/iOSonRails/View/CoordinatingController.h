//
//  CoordinatingController.h
//  iOSonRails
//
//  Created by huangmh on 3/25/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoordinatingController : NSObject

+ (CoordinatingController *) sharedInstance;
- (IBAction) presentViewControllerByType:(int )type fromObject:(id)object;

@end
