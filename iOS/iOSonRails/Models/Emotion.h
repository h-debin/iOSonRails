//
//  Emotion.h
//  iOSonRails
//
//  Created by huangmh on 4/1/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIKit/UIKit.h"

@interface Emotion : NSObject

@property NSString *type;

+ (NSArray *) allEmotions;
+(Emotion *) haoEmotion;
+(Emotion *) leEmotion;
+(Emotion *) aiEmotion;
+(Emotion *) juEmotion;
+(Emotion *) jingEmotion;
+(Emotion *) nuEmotion;
+(Emotion *) eEmotion;

- (Emotion *) next;
- (Emotion *) previous;

@end
