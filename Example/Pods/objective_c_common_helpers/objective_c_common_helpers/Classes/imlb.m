//
//  imlb.m
//  cameraApplication
//
//  Created by Hitesh Khunt on 30/11/16.
//  Copyright © 2016 Hitesh Khunt. All rights reserved.
//

#import "imlb.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+WebCache.h"
#import "config.h"
#import "session.h"

@interface imlb ()

@end

@implementation imlb

+(float) screenWidth
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    return screenRect.size.width;
}

+(float) screenHeight
{
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    return screenRect.size.height;
}

+(void) actionBarColor:(UIViewController*) vwObj
{
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] >= 7)
    {
        vwObj.navigationController.navigationBar.translucent = NO;
        [vwObj.navigationController.navigationBar setTintColor:[imlb colorFromHexString:themeColor]];
        
    }
    else {
        vwObj.navigationController.navigationBar.tintColor = [imlb colorFromHexString:themeColor];
        [vwObj.navigationController.navigationBar setTintColor:[imlb colorFromHexString:themeColor]];
    }
}

+(void) nvagationTitleColor:(UIViewController*) vwObj
{
    [vwObj.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[imlb colorFromHexString:themeColor],
        NSFontAttributeName:[UIFont fontWithName:@"Montserrat-Regular" size:20]}];

}

+(NSDate*) strToDate:(NSString*) mySqlDate
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    return [dateFormatter dateFromString:mySqlDate];
}

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
+ (UIColor *)colorFromHexString:(NSString *)hexString
{
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

+ (double)radianToDegree:(double )radiun
{
    return 180 / M_PI * radiun;
}

+ (double) DegreesToRadians :(double) degrees
{
    return degrees * M_PI / 180;
}

+(void) showToast:(NSString*) msg withDuration:(int) duration
{
   
    UIAlertView *toast = [[UIAlertView alloc] initWithTitle:nil
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:nil
                                          otherButtonTitles:nil, nil];
    [toast show];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
        [toast dismissWithClickedButtonIndex:0 animated:YES];
    });
}

+ (UIImage *)mergeImagesFromArray: (NSArray *)imageArray
{
    
    if ([imageArray count] == 0) return nil;
    
    UIImage *exampleImage = [imageArray firstObject];
    CGSize imageSize = exampleImage.size;
    CGSize finalSize = CGSizeMake(imageSize.width, imageSize.height * [imageArray count]);
    
    UIGraphicsBeginImageContext(finalSize);
    
    for (UIImage *image in imageArray) {
        [image drawInRect: CGRectMake(0, imageSize.height * [imageArray indexOfObject: image],
                                      imageSize.width, imageSize.height)];
    }
    
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return finalImage;
}

+ (UIImage *)merge2Images: (UIImage *)image1 imageX1:(CGFloat) imageX1 imageY1:(CGFloat) imageY1 image2: (UIImage *)image2 imageX2:(CGFloat) imageX2 imageY2:(CGFloat) imageY2 is_horizontal:(BOOL) is_horizontal
{
  
    CGSize finalSize;
    if( is_horizontal )
    {
        finalSize = CGSizeMake( ( image1.size.width - imageX1) + imageX2, image1.size.height );
    }
    else
    {
        finalSize = CGSizeMake( image1.size.width, ( image1.size.height - imageY1) + imageY2 );
    }
    
    if( is_horizontal )
    {
        //image 1
        UIImage *tmpImg1 = [imlb getSubImageFromImage:image1 imageXStart:imageX1 imageYStart:imageY1 imageXEnd:(image1.size.width - imageX1) imageYEnd:( image1.size.height - imageY1)];
        
        //image 2
        UIImage *tmpImg2 = [imlb getSubImageFromImage:image2 imageXStart:0 imageYStart:imageY2 imageXEnd:imageX2 imageYEnd:( image2.size.height - imageY2)];
        
        
        //
        UIGraphicsBeginImageContext(finalSize);
        
        
        [tmpImg1 drawInRect: CGRectMake(0, 0,
                                        tmpImg1.size.width, tmpImg1.size.height)];
        
        [tmpImg2 drawInRect: CGRectMake( image1.size.width - imageX1, 0,
                                        tmpImg2.size.width, tmpImg2.size.height)];
    }
    else
    {
        
    }
    
    UIImage *finalImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return finalImage;
}

+ (UIImage*) getSubImageFromImage:(UIImage *)image imageXStart:(CGFloat) imageXStart imageYStart:(CGFloat) imageYStart imageXEnd:(CGFloat) imageXEnd imageYEnd:(CGFloat) imageYEnd
{
    CGRect drawRect = CGRectMake(imageXStart, imageYStart, imageXEnd, imageYEnd);
    
    // Create Image Ref on Image
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], drawRect);
    
    // Get Cropped Image
    UIImage *img = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    
    return img;
}

+(NSString *) filterHrefParamsProductList:(NSString *) hrefParams
{
    NSString *res = @"";
    
    if( [imlb isStr:hrefParams contains:@"__fmID="] )
    {
        res = [NSString stringWithFormat:@"%@__fmID=%@&" , res , [imlb fetchSubStr:hrefParams withStart:@"__fmID=" withEnd:@"&"]];
    }
    
    if( [imlb isStr:hrefParams contains:@"itID="] )
    {
        res = [NSString stringWithFormat:@"%@itID=%@&" , res , [imlb fetchSubStr:hrefParams withStart:@"itID=" withEnd:@"&"]];
    }
    
    if( [imlb isStr:hrefParams contains:@"si="] )
    {
        res = [NSString stringWithFormat:@"%@si=%@&" , res , [imlb fetchSubStr:hrefParams withStart:@"si=" withEnd:@"&"]];
    }
    
    if( [imlb isStr:hrefParams contains:@"IT_KEY="])
    {
        res = [NSString stringWithFormat:@"%@IT_KEY=%@&" , res , [imlb fetchSubStr:hrefParams withStart:@"IT_KEY=" withEnd:@"&"]];
    }
    
    return res;
}


+(NSDictionary*) jsonStrToObj:(RKObjectRequestOperation *) operation
{
    NSDictionary *resObj = [NSJSONSerialization JSONObjectWithData:operation.HTTPRequestOperation.responseData options:NSJSONReadingMutableLeaves error:nil];
    
    return resObj;
}

+(NSDictionary*) jsonStrToObj1:(NSString *) str
{
    
    NSError *err = nil;
    NSArray *array = [NSJSONSerialization JSONObjectWithData:[str dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&err];
    
    NSDictionary *dictionary = [array objectAtIndex:0];
    
    return dictionary;
}

+(NSMutableAttributedString*) strickthrogh:(NSString *) str
{
    NSMutableAttributedString *attString=[[NSMutableAttributedString alloc]initWithString:str];
    [attString addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInt:2] range:NSMakeRange(0,[attString length])];
    
    return attString;
}

+(BOOL) isStr:(NSString *) subject contains:(NSString*) part
{
    return [subject rangeOfString:part].location != NSNotFound;
}

+(BOOL) isStrEmpty:(NSString *) subject
{
    return [subject length] == 0;
}

+(BOOL) isStrEmptyStrict:(NSString *) subject
{
    if( subject != nil )
    return [[NSString stringWithFormat:@"%@", subject] length] == 0;
    else
    return YES;
}

+(int) imc_swap:(int) val
{
    return val + ( val * -2 );
}

+(void) loadImage:(NSString*) url onImageView:(UIImageView*) imageView
{
    [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:url]
                 placeholderImage:[UIImage imageNamed:@"placeholder"]];
}
+(void) loadImageNew:(NSString*) url onImageView:(UIImageView*) imageView
{
    [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:url]
                 placeholderImage:[UIImage imageNamed:@"profile_placeholder"]];
}
+(void) loadImageBanner:(NSString*) url onImageView:(UIImageView*) imageView
{
    [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:url]
                 placeholderImage:[UIImage imageNamed:@"profile_bannerplaceholder"]];
}


+(void) loadBannerImage:(NSString*) url onImageView:(UIImageView*) imageView
{
    [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:url]];
}

+(void) loadImageLazy:(NSString*) url onImageView: imageView
{
    [imageView sd_setImageWithURL:[NSURL URLWithString:url]
                 placeholderImage:[UIImage imageNamed:@"ic_launcher.png"]];
}


/** ( Not Used ) source defination from android
 **/

+(NSString*) utf8_String:(NSString*) str
{
    //    try
    //    {
    //        return new String( str.getBytes("ISO-8859-1"), "UTF-8" );
    //    }
    //    catch( Exception e )
    //    {
    //        imui.singleton().errorMsg( ctx, 10, "Stack: " + e.getStackTrace() + " Msg: " + e.getMessage() );
    //    }
    
    return str;
}

+(BOOL) isInternet
{
    return YES;
}

+(float) strToFloatSecure:(NSString*) str
{
    if( str != nil && [str length] > 0 )
    return [str floatValue];
    else
    return 0;
}

+(float) currencyValueToFloatSecure:(NSString*) str
{
    NSLog(@"currencyValueToFloatSecure %@", str);
    if(str == nil)
    {
        return 0;
    }

    NSLog(@"currencyValueToFloatSecure 1 %@", str);
    str = [str stringByReplacingOccurrencesOfString:@"$" withString:@""];
    NSLog(@"currencyValueToFloatSecure 2 %@", str);
    str = [str stringByReplacingOccurrencesOfString:@"," withString:@""];
    
    if( [str length] > 0 )
    {
        NSLog(@"currencyValueToFloatSecure 3 %f", [str floatValue]);
        return [str floatValue];
    }
    else
        return 0;
}


+(int) strToIntSecure:(NSString*) str
{
    if( str != nil )
    {
        if( [str isKindOfClass:[NSString class]] && [str length] > 0 )
            return [str intValue];

        else
            return 0;
    }
    else
        return 0;
}

+(int) strToInt:(NSString*) val
{
    return [val intValue];
}

+(NSString*) fetchSubStr:(NSString*) subject withStart:(NSString*) start withEnd:(NSString*) end
{
    NSRange startRange = [subject rangeOfString:start];
    if (startRange.location != NSNotFound)
    {
        NSRange targetRange;
        targetRange.location = startRange.location + startRange.length;
        targetRange.length = [subject length] - targetRange.location;
        
        NSRange endRange = [subject rangeOfString:end options:0 range:targetRange];
        if (endRange.location != NSNotFound)
        {
            targetRange.length = endRange.location - targetRange.location;
            return [subject substringWithRange:targetRange];
        }
        else
        {
            return [subject substringFromIndex:targetRange.location];
        }
    }
    return @"";
}

+(NSString*) removeFromStr:(NSString*) subject withNeedle:(NSString*) needle
{
    //return subject.substring(0, subject.indexOf( needle ));
    NSRange range = [subject rangeOfString:needle];
    if ( range.length > 0 )
    {
        [subject substringWithRange:NSMakeRange(0, range.location)];
        
    }
    
    return subject;
}

+(BOOL) strContainsItemFromStrArr:(NSString*) inputString inItems:(NSArray*) items
{
    return YES;
}

+(NSString*) lang_lbl_convert:(NSString*) str
{
    NSString* convert = [NSString stringWithUTF8String:[str cStringUsingEncoding:NSUTF8StringEncoding]];
    
    return convert;
}

+(NSString*) timestamp
{
    return [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]];
}

+(void) displayBackStack
{
    
}

+(BOOL) isNetworkAvailable
{
    return YES;
}


+(void) im_sleep:(int) ms
{
    
}

+(BOOL) dictionary:(NSDictionary*) dict valueOfKey:(NSString*) key equalToStr:(NSString*) str
{
    if( [[dict objectForKey:key] isKindOfClass:[NSNumber class]] )
    {
        NSLog(@" dictionary 1 ");
        if( [[[dict objectForKey:key] stringValue] isEqualToString:str] )
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else if( [[dict objectForKey:key] isKindOfClass:[NSString class]] )
    {
        NSLog(@" dictionary 2 ");
        if( [[dict objectForKey:key] isEqualToString:str] )
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        NSLog(@" dictionary 3 %@ | %@ ", [dict objectForKey:key], [[dict objectForKey:key] stringValue]);
        if( [dict objectForKey:key] == nil && [str isEqualToString:@"0"] )
        {
            return YES;
        }
        else
        {
            NSLog(@" dictionary 4 ");
            
            if( [[[dict objectForKey:key] stringValue] isEqualToString:str] )
            {
                return YES;
            }
            else
            {
                return NO;
            }
        }
    }
    
    return NO;
}

+(NSString *) valueStr:(id) dict
{
    NSLog(@" valueStr 1 ");
    if( dict == nil )
    {
        return @"";
    }
    else if( [dict isKindOfClass:[NSNumber class]] )
    {
        NSLog(@" valueStr 2 %@ ", [dict stringValue]);
        NSLog(@" valueStr 2 %@ ", [NSString stringWithFormat:@"%@", dict]);
        return [NSString stringWithFormat:@"%@", dict];
    }
    else if( [dict isKindOfClass:[NSString class]] )
    {
        NSLog(@" valueStr 3 ");
        if( dict == nil )
        {
            NSLog(@" valueStr 6 ");
            return @"";
        }
        else
        {
            return [NSString stringWithFormat:@"%@", dict];
        }
    }
    
    return @"";
}

+(BOOL) str:(id) str isEqualToString:(id) compare
{
    return [[NSString stringWithFormat:@"%@", str] isEqualToString:[NSString stringWithFormat:@"%@", compare]];
}

+(NSString*) trim:(NSString*) str
{
    return [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
}

+(void) dictionary:(NSMutableDictionary *)dictMutable key:(NSString *)key value:(id)value
{
    [dictMutable setObject:value forKey:key];
}

+(void) array:(NSMutableArray *)arrayMutable key:(int)index value:(id)value
{
    [arrayMutable removeObjectAtIndex:index];
    [arrayMutable insertObject:value atIndex:index];
}


+(BOOL) isEmailValid:(NSString*) email
{
    BOOL stricterFilter = NO; 
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

+(NSString *) filterURL:(NSString*) url
{
    if([url containsString:@" "])
    {
        return [url stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    }
    return url;
}

+ (BOOL) validateUrl: (NSString *) candidate
{
    NSString *urlRegEx =
    @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
    NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
    return [urlTest evaluateWithObject:candidate];
}

+ (UIImage *)imageWithImage:(UIImage *)image convertToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return destImage;
}

+(NSString*) sessionAlis_userdata:(NSString*) key
{
    return [[session singleton] userdata:key];
}

+(void) sessionAlis_set_userdata:(NSString*) key withValue:(NSString*) val
{
    return [[session singleton] set_userdata:key withValue:val];
}

/**************************** internet/file functions ****************************/

+(BOOL) isFileExistAtPath:(NSString*) path
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if ([fileManager fileExistsAtPath:path])
    {
        return YES;
    }
    
    return NO;
}

+(BOOL) isFileExist:(NSString*) url
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *path = [imlb fileSavePath:url];
    
    if ([fileManager fileExistsAtPath:path])
    {
        return YES;
    }
    
    return NO;
}

+(NSString*) fileName:(NSString*) url
{
    return [url lastPathComponent];
}

+(NSString*) fileExt:(NSString*) url
{
    return [url pathExtension];
}

+(NSString*) fileMimetypeByExtension:(NSString*) ext
{
    ext = [ext lowercaseString];
    if( [ext isEqualToString:@"jpg"] || [ext isEqualToString:@"jpeg"] )
    {
        return @"image/jpeg";
    }
    else if( [ext isEqualToString:@"png"] )
    {
        return @"image/png";
    }
    else if( [ext isEqualToString:@"gif"] )
    {
        return @"image/gif";
    }
    else if( [ext isEqualToString:@"flv"] )// Flash
    {
        return @"video/x-flv";
    }
    else if( [ext isEqualToString:@"mp4"] )// MPEG-4
    {
        return @"video/mp4";
    }
    else if( [ext isEqualToString:@"mov"]  || [ext isEqualToString:@"moov"] )// QuickTime
    {
        return @"video/quicktime";
    }
    else if( [ext isEqualToString:@"movie"] )// Movie
    {
        return @"video/x-sgi-movie";
    }
    else if( [ext isEqualToString:@"mng"] )
    {
        return @"video/mng";
    }
    else if( [ext isEqualToString:@"x-mng"] )
    {
        return @"video/x-mng";
    }
    else if( [ext isEqualToString:@"avi"] )// A/V Interleave
    {
        return @"video/x-msvideo";
    }
    else if( [ext isEqualToString:@"wmv"] )// Windows Media
    {
        return @"video/x-ms-wmv";
    }
    else if( [ext isEqualToString:@"ogv"] )
    {
        return @"video/ogg";
    }
    else if( [ext isEqualToString:@"ogg"] )
    {
        return @"audio/ogg";
    }
    else if( [ext isEqualToString:@"mpeg"] || [ext isEqualToString:@"mpga"])
    {
        return @"audio/mpeg";
    }
    else if( [ext isEqualToString:@"3gp"] )// 3GP Mobile
    {
        return @"video/3gpp";
    }
    else if( [ext isEqualToString:@"m3u8"] )// iPhone Index
    {
        return @"application/x-mpegURL";
    }
    else if( [ext isEqualToString:@"ts"] )// iPhone Segment
    {
        return @"video/MP2T";
    }
    else if( [ext isEqualToString:@"mjpg"] )
    {
        return @"video/x-motion-jpeg";
    }
    
    return @"";
}

+(NSString*) fileNameWithoutExtension:(NSString*) url
{
    return [[url lastPathComponent] stringByDeletingPathExtension];
}

+(NSString*) fileSavePath:(NSString*) url
{
    NSString *docsDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return [docsDir stringByAppendingPathComponent:[imlb fileName:url]];
}

+(BOOL) copyFile:(NSString*) src dest:(NSString*) dest
{
    if ( [[NSFileManager defaultManager] isReadableFileAtPath:src] )
    {
        [[NSFileManager defaultManager] copyItemAtURL:[NSURL URLWithString:src] toURL:[NSURL URLWithString:dest] error:nil];
        return YES;
    }
    
    return NO;
}

+(void) saveImageToFile:(UIImage*) image toPath:(NSString*) filePath
{
    // Save image.
    [UIImagePNGRepresentation(image) writeToFile:filePath atomically:YES];
}

+(void) saveLocalNSURLToFile:(NSURL*) url toPath:(NSString*) filePath
{
    NSData *urlData = [NSData dataWithContentsOfURL:url];
    if ( urlData )
    {
        [urlData writeToFile:filePath atomically:YES];
        NSLog(@"File Saved !");
    }
}

+ (NSString*) documentDirectoryWithSubpath:(NSString*)subpath
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if (paths.count <= 0)
        return nil;
    
    NSString* dirPath = [paths objectAtIndex:0];
    if (subpath)
        dirPath = [dirPath stringByAppendingFormat:@"/%@", subpath];
    
    return dirPath;
}

//  Needs CoreImage.framework

+ (UIImage *)blurredImageWithImage:(UIImage *)sourceImage
{
    
    //  Create our blurred image
    CIContext *context = [CIContext contextWithOptions:nil];
    CIImage *inputImage = [CIImage imageWithCGImage:sourceImage.CGImage];
    
    //  Setting up Gaussian Blur
    CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [filter setValue:inputImage forKey:kCIInputImageKey];
    [filter setValue:[NSNumber numberWithFloat:15.0f] forKey:@"inputRadius"];
    CIImage *result = [filter valueForKey:kCIOutputImageKey];
    
    /*  CIGaussianBlur has a tendency to shrink the image a little, this ensures it matches
     *  up exactly to the bounds of our original image */
    CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
    
    UIImage *retVal = [UIImage imageWithCGImage:cgImage];
    return retVal;
}

+ (void)showCalendarOnDate:(NSDate *)date
{
    // calc time interval since 1 January 2001, GMT
    NSInteger interval = [date timeIntervalSinceReferenceDate];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"calshow:%ld", interval]];
    [[UIApplication sharedApplication] openURL:url];
}

+ (void)chngColorSegement:(UISegmentedControl *)sender color:(UIColor *)segmentColor
{
    for (int i=0; i<[sender.subviews count]; i++)
    {
        if ([[sender.subviews objectAtIndex:i]isSelected] )
        {
            [[sender.subviews objectAtIndex:i] setTintColor:segmentColor];
        }
        else
        {
            [[sender.subviews objectAtIndex:i] setTintColor:nil];
        }
    }
}

+(void)copiedtoClipboard:(NSString*)text
{
    [UIPasteboard generalPasteboard].string = text;
}
/**************************** internet/file functions end ****************************/

/**
 *
 */
+(CLLocationDistance) distanceBetwennTwoGeoPoints:(CLLocation*) l1 l2:(CLLocation*) l2
{
    return [l1 distanceFromLocation:l2];
}

/**
 *
 */
+(NSString*) distanceBetwennTwoGeoPointsInMiles:(CLLocation*) l1 l2:(CLLocation*) l2
{
    double mile = [imlb distanceBetwennTwoGeoPoints: l1 l2:l2] / 1609.344; //1 Mile = 1609.344 Meters
    
    {
        NSLog(@"%@ result4", [NSString stringWithFormat:@"%.2f Miles",mile]);
        return [NSString stringWithFormat:@"%.2f Miles",mile];
    }
}

/**
 *
 */
+(NSString*) distanceBetwennCoordinatesInMiles:(double) lat1 lon1:(double) lon1 lat2:(double) lat2 lon2:(double) lon2
{
    CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:lat1 longitude:lon1];
    
    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:lat2 longitude:lon2];
    
    NSLog(@"%@ result5", [imlb distanceBetwennTwoGeoPointsInMiles:loc1 l2:loc2]);
    
    return  [imlb distanceBetwennTwoGeoPointsInMiles:loc1 l2:loc2];
    
}

/**
 *
 */
+(float) distanceBetwennCoordinatesInMilesInFloat:(double) lat1 lon1:(double) lon1 lat2:(double) lat2 lon2:(double) lon2
{
    CLLocation *loc1 = [[CLLocation alloc] initWithLatitude:lat1 longitude:lon1];
    
    CLLocation *loc2 = [[CLLocation alloc] initWithLatitude:lat2 longitude:lon2];
    
    return  [imlb distanceBetwennTwoGeoPoints:loc1 l2:loc2] / 1609.344; //1 Mile = 1609.344 Meters
}


// update add to cart icon
+(void) setBadgeCntOnButton:(UIButton *)cart_Btn tag :(int) tag cnt:(int)cnt
{
    NSLog(@"cart_Btn tag %d",tag);
    
    int cart_cnt = cnt; //[imlb strToInt:[[session singleton] userdata:@"cart_count"]];
    //if(![[[session singleton] userdata:@"cart_count"] isEqualToString:@"0"] && ![imlb isStrEmpty:[[session singleton] userdata:@"cart_count"]])
    if( cart_cnt != 0 )
    {
        NSLog(@"cart count %d",cart_cnt);
        
        UILabel *lbl_card_count = [[UILabel alloc]initWithFrame:CGRectMake(23,-8, 18, 18)];
        lbl_card_count.tag = tag;
        lbl_card_count.textColor = [UIColor whiteColor];
        lbl_card_count.textAlignment = NSTextAlignmentCenter;
        lbl_card_count.text = [NSString stringWithFormat:@"%d", cart_cnt];
        lbl_card_count.layer.borderWidth = 1;
        lbl_card_count.layer.cornerRadius = 9;
        lbl_card_count.layer.masksToBounds = YES;
        lbl_card_count.layer.borderColor =[[UIColor clearColor] CGColor];
        lbl_card_count.layer.shadowColor = [[UIColor clearColor] CGColor];
        lbl_card_count.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        lbl_card_count.layer.shadowOpacity = 0.0;
        lbl_card_count.backgroundColor = [UIColor redColor];//[UIColor colorWithRed:247.0/255.0 green:45.0/255.0 blue:143.0/255.0 alpha:1.0];
        lbl_card_count.font = [UIFont fontWithName:@"ArialMT" size:12];
        [cart_Btn addSubview:lbl_card_count];
    }
    else
    {
        UILabel *lbl_card_count = [cart_Btn viewWithTag:tag];
        if( lbl_card_count != nil )
        {
            [lbl_card_count removeFromSuperview];
        }
    }
}

+(NSString*) mysqlFormatDate:(NSString*) date format:(NSString*) format
{
    NSArray *tmp = [date componentsSeparatedByString:@"-"];
    NSString *res = @"";
    
    if( [tmp count] >= 3 )
    {
        if( [format isEqualToString:@"m-d-Y"] )
        {
            res = [NSString stringWithFormat:@"%@-%@-%@", [tmp objectAtIndex:2], [tmp objectAtIndex:0], [tmp objectAtIndex:1]];
        }
    }
    
    return res;
}

+(NSString*) mysqlFormatTime:(NSString*) time format:(NSString*) format
{
    NSArray *tmp = [time componentsSeparatedByString:@":"];
    NSString *res = @"";
    
    if( [tmp count] >= 2 )
    {
        if( [format isEqualToString:@"h:i z"] )
        {
            NSArray *tmp1 = [[tmp objectAtIndex:1] componentsSeparatedByString:@" "];
            
            if( [tmp1 count] >= 2 )
            {
                if( [[tmp1 objectAtIndex:1] isEqualToString:@"AM"] )
                {
                    res = [NSString stringWithFormat:@"%@", [tmp objectAtIndex:0]];
                }
                else
                {
                    if([imlb strToIntSecure:[tmp objectAtIndex:0]] < 12)
                    {
                        res = [NSString stringWithFormat:@"%d", [imlb strToIntSecure:[tmp objectAtIndex:0]] + 12];
                    }
                    else
                    {
                        res = [NSString stringWithFormat:@"%@", [tmp objectAtIndex:0]];
                    }
                }
                
                res = [NSString stringWithFormat:@"%@:%@:00", res, [tmp1 objectAtIndex:0]];
            }
        }
    }
    
    return res;
}

+(NSString*) dateStrFromFormatToFormat:(NSString*) dateStr fromFormat:(NSString*) fromFormat toFormat:(NSString*) toFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:fromFormat];
    
    NSDate *date = [dateFormatter dateFromString:dateStr];
    [dateFormatter setDateFormat:toFormat];
    
    return [dateFormatter stringFromDate:date];
}

+(NSString*)escapeStr:(NSString*)str
{
    return [str stringByReplacingOccurrencesOfString:@"'" withString:@"%27"];
}

+(void)applyShadow:(UIView *)view
{
    view.layer.shadowRadius  = 1.8f;
    view.layer.shadowColor   = [UIColor blackColor].CGColor;
    view.layer.shadowOffset  = CGSizeMake(0.0f, 0.0f);
    view.layer.shadowOpacity = 0.15f;
    view.layer.masksToBounds = NO;
    
    UIEdgeInsets shadowInsets     = UIEdgeInsetsMake(-2.5f, -2.5f, -2.5f, -2.5f);
    UIBezierPath *shadowPath      = [UIBezierPath bezierPathWithRect:UIEdgeInsetsInsetRect(view.bounds, shadowInsets)];
    view.layer.shadowPath    = shadowPath.CGPath;
}
@end
