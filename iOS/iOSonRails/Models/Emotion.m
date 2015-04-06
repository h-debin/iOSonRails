//
//  Emotion.m
//  iOSonRails
//
//  Created by huangmh on 4/1/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

#import "Emotion.h"

@interface Emotion()

@end

@implementation Emotion

- (id) initWithType:(NSString *)type {
    if (self == [super init]) {
        self.type = type;
    }
    
    return self;
}

+ (NSArray *) allEmotions {
    return [[NSArray alloc] initWithObjects:
            [self haoEmotion],
            [self leEmotion],
            [self aiEmotion],
            [self juEmotion],
            [self jingEmotion],
            [self nuEmotion],
            [self eEmotion],
            nil];
}

+ (Emotion *) haoEmotion {
    return [[self alloc] initWithType:@"好"];
}

+(Emotion *) leEmotion {
    return [[self alloc] initWithType:@"乐"];
}

+(Emotion *) aiEmotion {
    return [[self alloc] initWithType:@"哀"];
}

+(Emotion *) juEmotion {
    return [[self alloc] initWithType:@"惧"];
}

+(Emotion *) jingEmotion {
    return [[self alloc] initWithType:@"惊"];
}
+(Emotion *) nuEmotion {
    return [[self alloc] initWithType:@"愤"];
}

+(Emotion *) eEmotion {
    return [[self alloc] initWithType:@"恶"];
}

/*
 * the circle of emotion chain
 * 好 -> 乐 -> 惊 -> 哀 -> 惧 -> 恶 -> 怒 -> 好
 */
- (Emotion *)next {
    if ([self.type isEqual:@"好"]) {
        return [[Emotion alloc] initWithType:@"乐"];
    } else if ([self.type isEqual:@"乐"]) {
        return [[Emotion alloc] initWithType:@"惊"];
    } else if ([self.type isEqual:@"惊"]) {
        return [[Emotion alloc] initWithType:@"哀"];
    } else if ([self.type isEqual:@"哀"]) {
        return [[Emotion alloc] initWithType:@"惧"];
    } else if ([self.type isEqual:@"惧"]) {
        return [[Emotion alloc] initWithType:@"恶"];
    } else if ([self.type isEqual:@"恶"]) {
        return [[Emotion alloc] initWithType:@"怒"];
    } else if ([self.type isEqual:@"怒"]) {
        return [[Emotion alloc] initWithType:@"好"];
    } else {
        return [[Emotion alloc] init];
    }
}

- (Emotion *)previous {
    if ([self.type isEqual:@"好"]) {
        return [[Emotion alloc] initWithType:@"怒"];
    } else if ([self.type isEqual:@"怒"]) {
        return [[Emotion alloc] initWithType:@"恶"];
    } else if ([self.type isEqual:@"恶"]){
        return [[Emotion alloc] initWithType:@"惧"];
    } else if ([self.type isEqual:@"惧"]) {
        return [[Emotion alloc] initWithType:@"哀"];
    } else if ([self.type isEqual:@"哀"]) {
        return [[Emotion alloc] initWithType:@"惊"];
    } else if ([self.type isEqual:@"惊"]) {
        return [[Emotion alloc] initWithType:@"乐"];
    } else if ([self.type isEqual:@"乐"]) {
        return [[Emotion alloc] initWithType:@"好"];
    } else {
        return [[Emotion alloc] init];
    }
}

@end
