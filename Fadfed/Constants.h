//
//  Constants.h
//  Fadfed
//
//  Created by Hani Abu Shaer on 7/15/13.
//  Copyright (c) 2013 AlphaApps. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

/* ---------------------------------------------
 ------------- API Connection ----------------
 ---------------------------------------------
 */
// Parse Credentials
#define PARSE_APP_ID                @"Shq3Gmc9X1iyv91YYBwY5WA0FW6CKBr2A5Dnzhdz"
#define PARSE_CLIENT_ID             @"JeEYt01wQKufMfxNDuhpCicqVtWnhHWWCkqUQuw2"

// Feed table
#define PARSE_FEED_TABLE            @"greeting_photo"
#define PARSE_FEED_COL_ID           @"objectId"
#define PARSE_FEED_COL_TITLE        @"photo_caption"
#define PARSE_FEED_COL_IMAGE        @"photo_src"
#define PARSE_FEED_COL_SHARE        @"photo_share_number"
#define PARSE_FEED_COL_DATE         @"createdAt"

// Template table
#define PARSE_TEMPLATE_TABLE        @"greeting_template"
#define PARSE_TEMPLATE_COL_ID       @"objectId"
#define PARSE_TEMPLATE_COL_CATEGORY @"type"
#define PARSE_TEMPLATE_COL_IMAGE    @"template_src"
#define PARSE_TEMPLATE_COL_THUMB    @"template_thumb"
#define PARSE_TEMPLATE_COL_SHARE    @"template_share_number"
#define PARSE_TEMPLATE_COL_DATE     @"createdAt"

// Category table
#define PARSE_CATEGORY_TABLE        @"greeting_category"
#define PARSE_CATEGORY_COL_ID       @"objectId"
#define PARSE_CATEGORY_COL_NAME     @"category_name"

#define BATCH_FEED_SIZE             5

// Caching files
#define CACH_FEED_FOLDER            @"FeedData"
#define CACH_FEED_FILE              @"feed.txt"
#define CACH_TEMPLATE_FOLDER        @"TemplateData"
#define CACH_TEMPLATE_FILE          @"template.txt"
#define CACH_CATEGORY_FOLDER        @"CategoryData"
#define CACH_CATEGORY_FILE          @"category.txt"

/* ---------------------------------------------
 ------------- Application Interface -----------
 -----------------------------------------------
 */
#define LOADIN_MORE_CELL_HEIGHT     44
#define NORMAL_CELL_HEIGHT          416
#define FEED_DATE_FORMATE           @"dd.MM.yyyy"
#define EFFECT_STROKE_WIDTH         -4.0

// Font Size
#define FONT_SIZE_LARGE   36
#define FONT_SIZE_MEDIUM  27
#define FONT_SIZE_SMALL   18

// Server Type
typedef enum
{
    FFActionImageUse = 0,
    FFActionImageCamera = 1,
    FFActionImageLibrary = 2,
    FFActionImageFadfed = 3
} FFActionImageUsage;

#endif