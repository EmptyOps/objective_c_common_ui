//
//  imui.h
//  XClient
//
//  Created by Hitesh Khunt on 05/06/15.
//  Copyright (c) 2015 XClient. All rights reserved.
//
#import <UIKit/UIKit.h>

@class he_Controller;

@interface imui : NSObject

//singltone
+(imui *) singleton;

/******************* search listeners related globals ******************/
@property BOOL is_search_del_key_pressed;

/**
 * boolean to keep focus state of search inputs to avoid unnecessary hide and margin change events
 */
@property BOOL is_search_focused;

/**
 * boolean to keep track of previous search call, so that it could be aborted
 */
@property BOOL is_search_in_process;

@property (nonatomic, weak) UIActivityIndicatorView *activityIndicator;

/****************** *****************/

+(BOOL) is401:(he_Controller*) he_ControllerObj withResponse:(NSDictionary*) response;

/**
 */
+(BOOL) isVisible:(he_Controller*) he_ControllerObj vw:(NSArray*) vw;

/**
 */
+(void) hideEleByObj:(he_Controller*) he_ControllerObj vw:(UIView*) vw;

/**
 */
+(void) hideEleByObjInvisible:(he_Controller*) he_ControllerObj vw:(UIView*) vw;

/**
 */
+(void) showEleByObj:(he_Controller*) he_ControllerObj vw:(NSArray*) vw;

/**
 * get Flash Msg From REST Response
 */
+(NSArray*) getFlashMsgFromRes:(NSDictionary*) responseObj;

/**
 * Change: From 04-04-2015 flash message flow is set to instant, mean message will be shown to user instantly
 * instead of showing it in next activity so it will not keep any flash session in REST clients.
 */
+(void) setFlashMsgFromRes:(NSDictionary*) responseObj;

/**
 */
+(void) showFlashInstantMsg:(NSString*) msg;

/**
 */
+(void) showFlashNewVersionMsg:(NSString*) msg;

/**
 */
+(void) showFlashMsg;

/**
 * function will update session id if applicable
 */
+(void) updateSessionIdIfApplicable:(NSDictionary *) resObj;


/**
 */
+(void) errorMsg:(int) priority forMsg:(NSString*) msg;

/**
 */
+(void) showToast:(NSString*) msg withDuration:(int) duration;

/**
 */
+(void) showPopUpNotification:(NSString*) type forMsg:(NSString*) msg withButton:(NSString*) buttonTitle;

/**
 */
+(void) dialogMsg:(NSString*) title forMsg:(NSString*) msg withButton:(NSString*) buttonTitle;

-(void) setPadding:(UITextField*)textfield;

/**
 * wrapper around errorMsg to show errors as required
 */
+(void) showError:(int) priority forMsg:(NSString*) msg withException:(NSException*) e;

-(void) openBrowser:(he_Controller*) he_ControllerObj url:(NSString*)url;

/************************************ cart helper functions ********************************/

/**
 * refresh wishlist cart
 */
-(void) refreshWishCart:(he_Controller*) he_ControllerObj;

/************************************ cart helper functions end ****************************/

/**
 * function will replace not allowed chars like "-" in tag to better temporary replacement like config.IM_SSEP
 */
+(NSString*) replaceTagChars:(NSString*) tag;

-(UIColor *) backgroundColor;

-(UIColor *) highlitedColor;

-(void)TopBorder:(UITableViewCell *)view;

-(void)BottomBorder:(UITableViewCell *)view;

-(void)BottomBorder_view:(UIView *)view;

-(float) getTimeZone;

/**
 * function will add prod in cart
 */

- (NSString *)DeviceModel;

-(void)updateCart :(UIButton *)cart_Btn tag :(int) tag;

+(NSMutableDictionary*) setSearchFormForRestCall:(NSMutableDictionary*) dict;

+(NSString*)getLacalDateFromDate:(NSString*)localeDate formatter : (NSString*)dateformatter;

+(NSString*)getLacalDateFromDateBasedSessionTimezone:(NSString*)localeDate formatIn: (NSString*)formatIn outputFormat:(NSString*) outputFormat;

+(NSString *)getUTCFormateDatefromDateBasedSessionTimezone:(NSDate *)localDate dateFormat:(NSString *)dateFormat;

+(NSString *)getUTCFormateDatefromDate:(NSDate *)localDate dateFormat:(NSString *)dateFormat;

+(NSDate *) getDatefromString:(NSString *)dateString strForm : (NSString*)strForm;

+(NSString *)getUTCFormateDateFromString:(NSString *)localDate strForm : (NSString*)strForm;

-(void)showProgressBar:(UIViewController *)tmpController;

-(void) hideProgressBar:(UIViewController *) he_ControllerObj;

@end
