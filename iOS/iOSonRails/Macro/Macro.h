//
//  Macro.h
//  iOSonRails
//
//  Created by huangmh on 1/9/15.
//  Copyright (c) 2015 minghe. All rights reserved.
//

#ifndef iOSonRails_Macro_h
#define iOSonRails_Macro_h

//#define NEWS_URL "http://127.0.0.1:3000/api/v1/news/"
#define NEWS_URL "http://api.minghe.me/api/v1/news"
#define TOKEN_REQUEST_URL "http://api.minghe.me/api/v1/request_access_token"

typedef enum
{
    HAO,
    LE,
    JING,
    AI,
    JU,
    E,
    NU
} EMOTION_TYPE;

#define HAO_LABEL "今日最好"
#define LE_LABEL "今日最乐"
#define JING_LABEL "今日最惊"
#define AI_LABEL "今日最哀"
#define JU_LABEL "今日最惧"
#define E_LABEL "今日最恶"
#define NU_LABEL "今日最怒"

#ifndef Constants_h
#define Constants_h

// 宽度和高度
#define SCREEN_WIDTH                    [[UIScreen mainScreen] bounds].size.width
#define SCRENN_HEIGHT                   [[UIScreen mainScreen] bounds].size.height
#define STATUS_BAR_HEIGHT               (20.f)
#define NAVIGATION_BAR_HEIGHT           (44.f)
#define TAB_BAR_HEIGHT                  (49.f)
#define CELL_DEFAULT_HEIGHT             (44.f)

// 文件路径
#define PATH_OF_APP_HOME                NSHomeDirectory()
#define PATH_OF_TEMP                    NSTemporaryDirectory()
#define PATH_OF_DOCUMENT                [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define PATH_OF_CACHES                  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]

// 设备信息
#define CURRENT_SYSTEM_VERSION          [[[UIDevice currentDevice] systemVersion] floatValue]
#define CURRENT_LANGUAGE                ([[NSLocale preferredLanguages] objectAtIndex:0])
#define IS_PAD                          (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE                       (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)

//颜色
#define UIColorFromHexWithAlpha(hexValue,a) [UIColor colorWithRed:((float)((hexValue & 0xFF0000) >> 16))/255.0 green:((float)((hexValue & 0xFF00) >> 8))/255.0 blue:((float)(hexValue & 0xFF))/255.0 alpha:a]
#define UIColorFromHex(hexValue)            UIColorFromHexWithAlpha(hexValue,1.0)
#define UIColorFromRGBA(r,g,b,a)            [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define UIColorFromRGB(r,g,b)               UIColorFromRGBA(r,g,b,1.0)

// 打印
#ifdef DEBUG
#   define DLog(fmt, ...)                NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define DLog(...)
#endif

#define LOG_BOUNDS(view)                 DLog(@"%@ bounds: %@", view, NSStringFromRect([view bounds]))
#define LOG_FRAME(view)                  DLog(@"%@ frame: %@", view, NSStringFromRect([view frame]))

#define NSStringFromBool(B)              (B ? @"YES" : @"NO")

// 资源
#define RESOURCE_PATH(name, ext)         [[NSBundle mainBundle] pathForResource:(name) ofType:(ext)]
#define PNG_PATH(name)                   RESOURCE_PATH(name, @"png")
#define JPG_PATH(name)                   RESOURCE_PATH(name, @"jpg")

#define LOAD_IMAGE(name, ext)           [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:ext]]
#define IMAGE_NAMED(name)               [UIImage imageNamed:name]

// 字符串
#define LOCAL_STRING(x)                 NSLocalizedString(x, nil)
#define IS_NULL(x)                      (!x || [x isKindOfClass:[NSNull class]])
#define IS_EMPTY_STRING(x)              (IS_NULL(x) || [x isEqual:@""] || [x isEqual:@"(null)"])
#define NSStringFromInt(int)            [NSString stringWithFormat:@"%d", int]
#define NSStringFromFloat(float)        [NSString stringWithFormat:@"%f", float]

// 字体
#define BOLD_SYSTEM_FONT(size)          [UIFont boldSystemFontOfSize:size]
#define SYSTEM_FONT(size)               [UIFont systemFontOfSize:size]
#define FONT(name, size)                [UIFont fontWithName:(name) size:(size)]

// view 圆角
#define VIEW_RADIUS(view, radius) \
[view.layer setCornerRadius:(radius)]; \
[view.layer setMasksToBounds:YES]

#define VIEW_BORDER_RADIUS(view, radius, width, color) \
VIEW_RADIUS(view, radius); \
[view.layer setBorderWidth:(Width)]; \
[View.layer setBorderColor:[color CGColor]]

#if TARGET_OS_IPHONE
/** iPhone Device */
#endif

#if TARGET_IPHONE_SIMULATOR
/** iPhone Simulator */
#endif

#endif


#endif
