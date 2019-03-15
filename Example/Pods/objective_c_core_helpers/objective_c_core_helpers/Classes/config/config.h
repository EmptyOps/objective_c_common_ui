//
//  config.h
//  considerdelivery
//
//  Created by Hitesh Khunt on 15/12/16.
//  Copyright © 2016 Hitesh Khunt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "constants.h"

//
//  config.h
//  XClient
//
//  Created by Hitesh Khunt on 13/06/15.
//  Copyright (c) 2015 XClient. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * version info
 */
static int APP_VERSION = 1;
static int VALUE_COUNT = 1;

/**
 *  1: development , 2: staging, 3: production
 */
static int ENV = 2;

/**
 *  whether to catch runtime exception
 */
static BOOL CATCH_RUNTIME = YES;

/**
 *  REST sessid_index
 */
static NSString *sessid_index = @"APP_KEY";    //PHPSESSID

/**
 *  REST app_key_index
 */
static NSString *app_key_index = @"rest_v";

/**
 *  REST rest_version
 */
static float rest_ver = 1;

/**
 *  REST out_format_index
 */
static NSString *out_format_index = @"format";

/**
 *  REST rest_status_field_name
 */
static NSString *rest_status_field_name = @"type";

/**
 *  REST rest_message_field_name
 */
static NSString *rest_message_field_name = @"msg";

/**
 *  REST rest_response_field_name
 */
static NSString *rest_response_field_name = @"response";

/**
 *  store card id
 */
static NSString *VAPE_OPENCART_STOREID = @"0";

/**
 *  Quick blox initialize
 */
static NSString *href = @"href";
static NSString *hrefParams = @"hrefParams";


/**
 *  quickblox configs
 *  view identifier
 */
static BOOL IS_QUICK_BLOX_CHAT_ENABLED = YES;
static const NSUInteger kApplicationID = 60613;
static NSString *const kAuthKey        = auth_key;
static NSString *const kAuthSecret     = auth_secret;
static NSString *const kAccountKey     = account_key;

/**
 *  theme colors
 */
static NSString *themeColor = @"#009687";//@"#4285f4";
static NSString *secondThemeColor = @"#333333";


/**
 *  name of App
 */
static NSString *appName = @"Tvc Sales";

/**
 *  INTENT/ACTION CONSTANTS
 */
static NSString *SHARE_ACTION = @"share";
static NSString *ACTION_CLEAR_BACK_STACK = @"ALL";
static NSString *ACTION_CLEAR_BACK_STACK_EXCEPT_ROOT = @"KR";   //keep/preserve root

/**
 *  contextual action bar menu button groups and IDs
 */
static int action_all = -1;
static int action_ebl = 1;
static int action_dbl = 5;
static int action_app = 10;
static int action_rej = 15;

/**
 * let family admin, join newly registered fresh user entry with thier existing entry if exists.
 */
static int action_jin = 20;


/**
 * let family admin or authorized user edit the item, right now intended to use for giving edit relationship option.
 */
static int action_edt = 25;
static int action_grp = 30; //view family graph
static int action_vpr = 35; //view full profile
static int action_epr = 40; //edit profile
static int action_cht = 45; //do chat with user


/**
 *  image picker intent
 */
static int img_pick_int_gallery = 1;
static int img_pick_int_camera = 5;

/**
 * imu Graph cache/String parameter  separator character/string
 */
static NSString *IM_SSEP = @"}";

/**
 * special  separator
 */
static NSString *SP_SEP = @"~";

/**
 * IM_: background service queue identifier
 */
static NSString *IM_BQ = @"IM_BQ";

/**
 * directories
 */
static NSString *PICT_DIR = @"Pictures";

/**
 * IM_: network background task tag
 */
static NSString *IM_NBT = @"IM_NBT";

/**
 * ACTION open context menu dialog
 */
static NSString *ACT_CD = @"ACT_CD";

/**
 * ACTION open context menu dialog
 */
static NSString *IS_INDIVIDUAL_FILTER_PAGE = @"IS_INDIVIDUAL_FILTER_PAGE";

/**
 *  global loader ID
 */
static int GLB_LDR_ID = 10013;

/**
 *  loader ID
 */
static int LDR_ID = 10014;
/**
 *  is cart enabled
 */
static BOOL IS_CART = NO;

/**
 *  is wish enabled
 */
static BOOL IS_WISH = NO;

/**
 *  tab indexes
 */
static int LOGICAL_2 = 22;   //tiles
static int LOGICAL_3 = 1;   //auction
//static int LOGICAL_2 = 22;   //tiles

/**
 *  default TAB
 */
static int DEFAULT_TAB = 5;

/**
 * child seller label
 */
static NSString *DSPT = @"Distributor";

/**
 *  rest error retry limit on 500
 */
static int REST_RETRY_LIMIT_FOR_500 = 5;

/**
 *  rest error retry limit on timeout
 */
static int REST_RETRY_LIMIT_FOR_TIMEOUT = 5;
static int REST_RETRY_COUNT = 5;

@interface config : NSObject


/**
 *  returns singleton instance
 *
 *  @return config class instance
 */
+(config *) singleton;


/**
 *  intializes class instance
 */
-(void) initialize;


/**
 * REST URL
 */
@property (nonatomic,strong) NSString *REST_URL;
@property (nonatomic,strong) NSString *REST_URL_NEW;

/**
 * CDN: asset url
 * however to be compliant with CDN always make sure that all REST App calls this URL <br>
 * And yes image upload feature from any app will calls the upload module in CDN <br>
 * so make sure that it will work without any compatibility issue with any version Apps.
 * 20-03-2015: CDN is implemented using FTP so now particular version will talk to it's own version PHP code so no need to use separate
 * php call and so it is expected to compliant with all version of app except first stable release v11.
 */
@property (nonatomic,strong) NSString *ASSET_URL;

/**
 *  constructs uri for REST url to call to
 *
 *  @param controller controller to call to
 *  @param query      query parameters
 *
 *  @return returns uri for REST server url to call to
 */
-(NSString *) restUri:(NSString *) controller   withQuery:(NSString *) query;


/**
 *  constructs REST url to call to
 *
 *  @param controller controller to call to
 *  @param query      query parameters
 *
 *  @return returns REST server url to call to
 */
-(NSString *) restUrl:(NSString *) controller   withQuery:(NSString *) query;


/**
 *  constructs CDN url to call to
 *
 *  @param controller controller to call to
 *  @param query      query parameters
 *
 *  @return returns CDN server url to call to
 */
-(NSString *) cdnUrl:(NSString *) controller    withQuery:(NSString *) query;


/**
 *  constructs query params for REST url to call to
 *
 *  @param query      query parameters
 *
 *  @return returns query params for  REST server url to call to
 
 [temp]: this seems unnecessary since internally RESTKit then constructs url, so spliting them from URL to
 nsdictionary and then into url is unnecessary.
 */
-(NSDictionary *) restUrlQueryParams:(NSString *) query;


/**
 * returns user image uploadId key part
 */
-(NSString *) u_imageUploadIdKey;


@end
