//
//  imlb.h
//  cameraApplication
//
//  Created by Hitesh Khunt on 30/11/16.
//  Copyright © 2016 Hitesh Khunt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objective_c_core_helpers/restKitWrapper.h>
#import <CoreLocation/CoreLocation.h>

@interface imlb : UIViewController

+(float) screenWidth;
+(float) screenHeight;
+(void) actionBarColor:(UIViewController*) vwObj;
+(void) nvagationTitleColor:(UIViewController*) vwObj;
+(NSDate*) strToDate:(NSString*) mySqlDate;
+ (UIImage *)imageWithColor:(UIColor *)color;


+ (UIColor *)colorFromHexString:(NSString *)hexString;
+ (double)radianToDegree:(double )radiun;
+ (double) DegreesToRadians :(double) degrees;
+(void) showToast:(NSString*) msg withDuration:(int) duration;
+(void) loadImageNew:(NSString*) url onImageView:(UIImageView*) imageView;
+ (UIImage *)mergeImagesFromArray: (NSArray *)imageArray;
+ (UIImage *)merge2Images: (UIImage *)image1 imageX1:(CGFloat) imageX1 imageY1:(CGFloat) imageY1 image2: (UIImage *)image2 imageX2:(CGFloat) imageX2 imageY2:(CGFloat) imageY2 is_horizontal:(BOOL) is_horizontal;
+ (UIImage*) getSubImageFromImage:(UIImage *)image imageXStart:(CGFloat) imageXStart imageYStart:(CGFloat) imageYStart imageXEnd:(CGFloat) imageXEnd imageYEnd:(CGFloat) imageYEnd;

/**
 *  parses JSON string response and converts it into NSDictionary
 *
 *  @return NSDictionary
 */
+(NSString *) filterHrefParamsProductList:(NSString *) hrefParams;

+(NSDictionary*) jsonStrToObj:(RKObjectRequestOperation *) operation;

+(NSDictionary*) jsonStrToObj1:(NSString *) str;

+(NSString*) strickthrogh:(NSString *) str;

/**
 *  check if string contains part
 *
 *  @return BOOL
 */
+(BOOL) isStr:(NSString *) subject contains:(NSString*) part;

/**
 *  check if string contains part
 *
 *  @return BOOL
 */
+(BOOL) isStrEmpty:(NSString *) subject;

/**
 *  check if string contains part
 *
 *  @return BOOL
 */
+(BOOL) isStrEmptyStrict:(NSString *) subject;

/**
 * imc_ : swap minus to plus and plus to minus
 */
+(int) imc_swap:(int) val;

/**
 * loads image from server
 */
+(void) loadImage:(NSString*) url onImageView:(UIImageView*) mNetworkImageView;

+(void) loadBannerImage:(NSString*) url onImageView:(UIImageView*) imageView;

+(void) loadImageBanner:(NSString*) url onImageView:(UIImageView*) imageView;
/**
 * loads image from server with lazy loader and hides loader when image is loaded
 */
+(void) loadImageLazy:(NSString*) url onImageView: imageView;

/**
 * loads image from server
 */
+(NSString*) utf8_String:(NSString*) str;

+(BOOL) isInternet;

/**
 * 	 secure version {@link} strToInt, it checks for if string length is 0 then return 0 by default
 */
+(float) strToFloatSecure:(NSString*) str;

+(float) currencyValueToFloatSecure:(NSString*) str;

/**
 * 	 secure version {@link} strToInt, it checks for if string length is 0 then return 0 by default
 */
+(int) strToIntSecure:(NSString*) str;

/**
 * un secure it does not check for empty string, however catches run time error and returns 0 in error case so same at the end
 */
+(int) strToInt:(NSString*) val;


+(NSString*) fetchSubStr:(NSString*) subject withStart:(NSString*) start withEnd:(NSString*) end;

+(NSString*) removeFromStr:(NSString*) subject withNeedle:(NSString*) needle;

/**
 */
+(BOOL) strContainsItemFromStrArr:(NSString*) inputString inItems:(NSArray*) items;

+(NSString*) lang_lbl_convert:(NSString*) str;

+(NSString*) timestamp;

/**
 */
+(void) displayBackStack;

/**
 */
+(BOOL) isNetworkAvailable;

+(void) im_sleep:(int) ms;


+(BOOL) dictionary:(NSDictionary*) dict valueOfKey:(NSString*) key equalToStr:(NSString*) str;

+(NSString *) valueStr:(id) dict;

+(BOOL) str:(id) str isEqualToString:(id) compare;

+(NSString*) trim:(NSString*) str;

+(void) dictionary:(NSMutableDictionary *)dictMutable key:(NSString *)key value:(id)value;

+(void) array:(NSMutableArray *)arrayMutable key:(int)index value:(id)value;

+(BOOL) isEmailValid:(NSString*) email;

+(NSString *) filterURL:(NSString*) url;

+ (BOOL) validateUrl: (NSString *) candidate;

+ (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size;

+(void)updateCart :(UIButton *)cart_Btn tag :(int) tag;

+(void)hideShowFooterview :(UIViewController*) vwObj;

+(NSString*) sessionAlis_userdata:(NSString*) key;

+(void) sessionAlis_set_userdata:(NSString*) key withValue:(NSString*) val;

/**************************** internet/file functions ****************************/

+(BOOL) isFileExistAtPath:(NSString*) path;

+(BOOL) isFileExist:(NSString*) url;

+(NSString*) fileName:(NSString*) url;

+(NSString*) fileExt:(NSString*) url;

+(NSString*) fileMimetypeByExtension:(NSString*) ext;

+(NSString*) fileNameWithoutExtension:(NSString*) url;

+(NSString*) fileSavePath:(NSString*) url;

+(BOOL) copyFile:(NSString*) src dest:(NSString*) dest;

+(void) saveImageToFile:(UIImage*) image toPath:(NSString*) filePath;

+(void) saveLocalNSURLToFile:(NSURL*) url toPath:(NSString*) filePath;

+ (NSString*) documentDirectoryWithSubpath:(NSString*)subpath;

+ (UIImage *)blurredImageWithImage:(UIImage *)sourceImage;

+ (void)showCalendarOnDate:(NSDate *)date;

+ (void)chngColorSegement:(UISegmentedControl *)sender color:(UIColor *)segmentColor;

+(void)copiedtoClipboard:(NSString*)text;
/**************************** internet/file functions end ****************************/

/**
 */
+(NSString*) distanceBetwennTwoGeoPointsInMiles:(CLLocation*) l1 l2:(CLLocation*) l2;

/**
 *
 */
+(NSString*) distanceBetwennCoordinatesInMiles:(double) lat1 lon1:(double) lon1 lat2:(double) lat2 lon2:(double) lon2;

+(float) distanceBetwennCoordinatesInMilesInFloat:(double) lat1 lon1:(double) lon1 lat2:(double) lat2 lon2:(double) lon2;

+(void) setBadgeCntOnButton:(UIButton *)cart_Btn tag :(int) tag cnt:(int)cnt;

+(NSString*) mysqlFormatDate:(NSString*) date format:(NSString*) format;
+(NSString*) mysqlFormatTime:(NSString*) time format:(NSString*) format;
+(NSString*) mysqlDateStrToFormat:(NSString*) dateStr format:(NSString*) format;
+(NSString*)escapeStr:(NSString*)str;

+(void)applyShadow:(UIView *)view;
@end
