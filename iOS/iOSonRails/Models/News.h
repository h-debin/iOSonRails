//
//  News.h
//  
//
//  Created by huangmh on 3/31/15.
//
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Emotion.h"
#import "CoreData+MagicalRecord.h"


@interface News : NSManagedObject

@property (nonatomic, retain) NSString * newsTitle;
@property (nonatomic, retain) NSString * newsDescription;
@property (nonatomic, retain) NSString * newsGuid;
@property (nonatomic, retain) NSString * newsLink;
@property (nonatomic, retain) NSDate * newsPubDate;
@property (nonatomic, retain) NSString * newsCategory;
@property (nonatomic, retain) NSString * newsPicture;
@property (nonatomic, retain) NSString * newsEmotionType;
@property (nonatomic, retain) NSNumber * newsMainEmotionValue;

- (id )initWithDictionary:(NSDictionary *)aDict;
+ (BOOL)isTitleExist:(NSString *)title;
+ (NSArray *) newsWithEmotionType:(int )type;
+ (NSArray *) newsWithEmotion:(Emotion *)emotion;

@end