//
//  News.m
//  
//
//  Created by huangmh on 3/31/15.
//
//

#import "News.h"


@implementation News

@dynamic newsTitle;
@dynamic newsDescription;
@dynamic newsGuid;
@dynamic newsLink;
@dynamic newsPubDate;
@dynamic newsCategory;
@dynamic newsPicture;
@dynamic newsEmotionType;
@dynamic newsMainEmotionValue;

- (id )initWithDictionary:(NSDictionary *)aDict {
    if([aDict[@"title"] isKindOfClass:[NSString class]]) {
        self.newsTitle = aDict[@"title"];
    }
    if([aDict[@"description"] isKindOfClass:[NSString class]]) {
        self.newsDescription = aDict[@"description"];
    }
    if([aDict[@"guid" ] isKindOfClass:[NSString class]]) {
        self.newsGuid = aDict[@"guid"];
    }
    if([aDict[@"link"] isKindOfClass:[NSString class]]) {
        self.newsLink = aDict[@"link"];
    }
    if([aDict[@"picture"] isKindOfClass:[NSString class]]) {
        self.newsPicture = aDict[@"picture"];
    }
    if([aDict[@"emotion_type"] isKindOfClass:[NSString class]]) {
        self.newsEmotionType = aDict[@"emotion_type"];
    }
    if([aDict[@"main_emotion_value"] isKindOfClass:[NSString class]]) {
        self.newsMainEmotionValue = aDict[@"main_emotion_value"];
    }
    if([aDict[@"category"] isKindOfClass:[NSString class]]) {
        self.newsCategory = aDict[@"category"];
    }
    if([aDict[@"pub_date"] isKindOfClass:[NSDate class]]) {
        self.newsPubDate = aDict[@"pub_date"];
    }
    
    return self;
}

+ (BOOL)isTitleExist:(NSString *)title {
    NSArray *array = [self MR_findByAttribute:@"newsTitle"withValue:title];
    if([array count] == 0) {
        return NO;
    } else {
        return YES;
    }
}

+ (NSArray *) newsWithEmotionType:(int )type {
    return [News MR_findByAttribute:@"newsEmotionType" withValue:[self getNewsKeyWithType:type]];
}

+ (NSString *) getNewsKeyWithType:(int )type {
    switch (type) {
        case 0:
            return @"好";
        case 1:
            return @"乐";
        case 2:
            return @"惊";
        case 3:
            return @"哀";
        case 4:
            return @"惧";
        case 5:
            return @"恶";
        case 6:
            return @"怒";
        default:
            return @"";
    }
}

@end
