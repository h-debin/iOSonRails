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

#endif
