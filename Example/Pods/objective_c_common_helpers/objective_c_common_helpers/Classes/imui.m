//
//  imui.m
//  XClient
//
//  Created by Hitesh Khunt on 05/06/15.
//  Copyright (c) 2015 XClient. All rights reserved.
//

#import "imui.h"
#import "imlb.h"
#import "lang.h"
#import "config.h"

#import "session.h"
#import <sys/sysctl.h>

#import "DGActivityIndicatorView.h"
#import <UIKit/UIKit.h>
@class products_list;

@implementation imui

UIActivityIndicatorView *activityIndicator;


+(imui *) singleton
{
    static imui *imuiSingleton;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        imuiSingleton  = [[imui alloc] init];
    });
    return imuiSingleton;
}

- (id)init
{
    if (self = [super init])
    {
        //do initialzation code
    }
    return self;
}

+(BOOL) is401:(he_Controller*) he_ControllerObj withResponse:(NSDictionary*) response
{
    return YES;
}

/** ( Not Used )
 *
 */
+(BOOL) isVisible:(he_Controller*) he_ControllerObj vw:(NSArray*) vw
{
    
    return NO;
}

+(void) hideEleByObj:(he_Controller*) he_ControllerObj vw:(UIView*) vw
{
    if( vw != nil )
    {
        vw.hidden = YES;
    }
}

/** ( Not Used ) source defination from android
 */
+(void) hideEleByObjInvisible:(he_Controller*) he_ControllerObj vw:(UIView*) vw
{
    if( vw != nil )
    {
        vw.hidden = YES;
    }
}

/** ( Not Used ) source defination from android
 */
+(void) showEleByObj:(he_Controller*) he_ControllerObj vw:(UIView*) vw
{
    if( vw != nil )
    {
        vw.hidden = NO;
    }
}


+(void) updateSessionIdIfApplicable:(NSDictionary *) resObj
{
    //
    @try
    {
        if( [resObj objectForKey:@"is_SID_c"] && [imlb dictionary:resObj valueOfKey:@"is_SID_c" equalToStr:@"1"] )     //[[resObj objectForKey:@"is_SID_c"]  intValue] == 1
        {
            [[session singleton] setSessionId:[resObj objectForKey:@"session_id"]];
        }
    }
    @catch (NSException * e)
    {
        [imui showError:1 forMsg:@"" withException:e];
    }
}

+(void) setFlashMsgFromRes:(NSDictionary*) responseObj
{
    [imui getFlashMsgFromRes: responseObj ];
}

+(NSArray*) getFlashMsgFromRes:(NSDictionary*) responseObj
{
    @try
    {
        NSDictionary *responseObjTemp;
        if( [responseObj objectForKey:@"flash"] )
        {

            if ( [[responseObj objectForKey:@"flash"] count ] == 0 )
            {
                return nil;
            }
            else
            {
                responseObjTemp = [responseObj objectForKey:@"flash"];
            }
        }
        else
        {
            return nil;
        }
        /**
         *
         */
        if( [responseObjTemp objectForKey:@"success"] )
        {
            [imui showToast:[responseObjTemp objectForKey:@"success"] withDuration:3];
            return nil;
        }
        
        if( [responseObjTemp objectForKey:@"upgradem"] )
        {
            [imui showFlashNewVersionMsg:[responseObjTemp objectForKey:@"upgradem"]];
            return nil;
        }
        
        if( [responseObjTemp objectForKey:@"successi"] )	//instant warning
        {
            [imui showFlashInstantMsg:[responseObjTemp objectForKey:@"successi"]];
            return nil;
        }
        
        if( [responseObjTemp objectForKey:@"warning"] )
        {
            [imui showToast:[responseObjTemp objectForKey:@"warning"] withDuration:4];
            return nil;
        }
        
        if( [responseObjTemp objectForKey:@"error"] )
        {
            [imui showToast:[responseObjTemp objectForKey:@"error"] withDuration:4];
            return nil;
        }
    }
    @catch ( NSException *e )
    {
        [imui showError:1 forMsg:@"" withException:e];
    }
    
    return nil;
}

+(void) showFlashNewVersionMsg:(NSString*) msg
{
    [imui showToast:msg withDuration: 3];
}

+(void) showFlashInstantMsg:(NSString*) msg
{
    [imui showToast:msg withDuration: 3];
}

+(void) showFlashMsg
{
    return;
    
    //Android code block removed
}

+(void) errorMsg:(int) priority forMsg:(NSString*) msg
{
    if( ENV <= 2 )
    {
        //dialogMsg( ctx, "App Error", msg, "OK" );
        [imui dialogMsg: @"App Error" forMsg: msg withButton: @"OK"];
    }
    else
    {
        if( [msg rangeOfString:@"im_"].location != NSNotFound || [msg rangeOfString:@"java.net.UnknownHostException"].location != NSNotFound )
        {
            if( [msg rangeOfString:@"im_e_nrc"].location != NSNotFound )
            {
                [imui dialogMsg: @"Internet Error" forMsg: [[lang singleton] getLabel: @"im_e_nrc"] withButton: @"OK"];
            }
            else
            {
                [imui dialogMsg: @"Internet Error" forMsg: [[lang singleton] getLabel: @"im_e_nrc"] withButton: @"OK"];
            }
        }
        else
        {
            [imui dialogMsg: @"Error" forMsg: @"Please try again." withButton: @"OK"];
        }
    }
   
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

+(void) showPopUpNotification:(NSString*) type forMsg:(NSString*) msg withButton:(NSString*) buttonTitle
{
    //
    if( [buttonTitle length] == 0 )
    {
        buttonTitle = @"Ok";
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"%@!", type]
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:buttonTitle
                                          otherButtonTitles:nil];
    [alert show];
    
}

+(void) dialogMsg:(NSString*) title forMsg:(NSString*) msg withButton:(NSString*) buttonTitle
{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:buttonTitle
                                          otherButtonTitles:nil];
    [alert show];
    
}

-(void) setPadding:(UITextField*)textfield
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    textfield.leftView = paddingView;
    textfield.leftViewMode = UITextFieldViewModeAlways;
}

-(void)showProgressBar:(UIViewController *)tmpController
{
    DGActivityIndicatorView *activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeBallClipRotate tintColor:[imlb colorFromHexString:themeColor] size:50.0f];
    activityIndicatorView.frame = CGRectMake(([imlb screenWidth]/2)-25.0f, ([imlb screenHeight]/2)-25.0f, 50.0f, 50.0f);
    [tmpController.view addSubview:activityIndicatorView];
    activityIndicatorView.tag = LDR_ID;
    [activityIndicatorView startAnimating];
}

/**
 * function will replace not allowed chars like "-" in tag to better temporary replacement like config.IM_SSEP
 */
+(NSString*) replaceTagChars:(NSString*) tag
{
    return [tag stringByReplacingOccurrencesOfString:@"-" withString:IM_SSEP];
}

/**
 * textcolor change
 */
-(void) textcolor:(he_Controller*) he_ControllerObj btn:(UILabel*)btn
{
    
    UIColor *backgroundColor = [UIColor colorWithRed:0 green:0.2 blue:0.4 alpha:1];
    
    btn.textColor = backgroundColor;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.layer.borderColor=[[UIColor whiteColor] CGColor];

}


/**
 * navigationbar color change
 */
-(UIColor *) backgroundColor
{
    return [UIColor colorWithRed:0 green:0 blue:0.4 alpha:1];
    
}

/**
 * navigationbar color change
 */
-(UIColor *) highlitedColor
{
    return[UIColor colorWithRed:0.047 green:0.678 blue:0.882 alpha:1];
}

// update add to cart icon
-(void)updateCart :(UIButton *)cart_Btn tag :(int) tag
{
    if(![[[session singleton] userdata:@"cart_count"] isEqualToString:@"0"] && ![imlb isStrEmpty:[[session singleton] userdata:@"cart_count"]])
    {
        UILabel *lbl_card_count = [[UILabel alloc]initWithFrame:CGRectMake(23,-8, 18, 18)];
        lbl_card_count.tag = tag;
        lbl_card_count.textColor = [UIColor whiteColor];
        lbl_card_count.textAlignment = NSTextAlignmentCenter;
        lbl_card_count.text = [[session singleton] userdata:@"cart_count"];
        lbl_card_count.layer.borderWidth = 1;
        lbl_card_count.layer.cornerRadius = 8;
        lbl_card_count.layer.masksToBounds = YES;
        lbl_card_count.layer.borderColor =[[UIColor clearColor] CGColor];
        lbl_card_count.layer.shadowColor = [[UIColor clearColor] CGColor];
        lbl_card_count.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        lbl_card_count.layer.shadowOpacity = 0.0;
        lbl_card_count.backgroundColor = [UIColor redColor];//[UIColor colorWithRed:247.0/255.0 green:45.0/255.0 blue:143.0/255.0 alpha:1.0];
        lbl_card_count.font = [UIFont fontWithName:@"ArialMT" size:14];
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

-(void)TopBorder:(UITableViewCell *)view
{
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0 , view.bounds.size.width, 0.5)];
    bottomLineView.backgroundColor = [UIColor grayColor];
    [view.contentView addSubview:bottomLineView];
}

-(void)BottomBorder:(UITableViewCell *)view
{
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, view.bounds.size.height - 5 , view.bounds.size.width , 0.5)];
    bottomLineView.backgroundColor = [UIColor grayColor];
    [view.contentView addSubview:bottomLineView];
}

-(void)BottomBorder_view:(UIView *)view
{
    UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, view.bounds.size.height - 40 , view.bounds.size.width , 0.5)];
    bottomLineView.backgroundColor = [UIColor grayColor];
    [view addSubview:bottomLineView];
}

- (NSString *)platformRawString {
    
    size_t size;
    
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    
    char *machine = malloc(size);
    
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    
    NSString *platform = [NSString stringWithUTF8String:machine];
    
    free(machine);
    
    return platform;
}

- (NSString *)DeviceModel {
    
    NSString *platform = [self platformRawString];
    
    NSLog(@" platform model %@ " , platform );
    
    if ([platform isEqualToString:@"iPhone1,1"])    return @"iPhone 1G";
    
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPhone2,1"])    return @"iPhone 3GS";
    
    if ([platform isEqualToString:@"iPhone3,1"])    return @"iPhone 4";
    
    if ([platform isEqualToString:@"iPhone3,3"])    return @"Verizon iPhone 4";
    
    if ([platform isEqualToString:@"iPhone4,1"])    return @"iPhone 4S";
    
    if ([platform isEqualToString:@"iPhone5,1"])    return @"iPhone 5";
    
    if ([platform isEqualToString:@"iPhone6,1"])    return @"iPhone 5S";
    
    if ([platform isEqualToString:@"iPhone7,2"])    return @"iPhone 6";
    
    if ([platform isEqualToString:@"iPhone7,1"])    return @"iPhone 6 Plus";
    
    if ([platform isEqualToString:@"iPhone8,1"])    return @"iPhone 6s";
    
    if ([platform isEqualToString:@"iPhone8,2"])    return @"iPhone 6s Plus";
    
    if ([platform isEqualToString:@"iPhone1,2"])    return @"iPhone 3G";
    
    if ([platform isEqualToString:@"iPod1,1"])      return @"iPod Touch 1G";
    
    if ([platform isEqualToString:@"iPod2,1"])      return @"iPod Touch 2G";
    
    if ([platform isEqualToString:@"iPod3,1"])      return @"iPod Touch 3G";
    
    if ([platform isEqualToString:@"iPod4,1"])      return @"iPod Touch 4G";
    
    if ([platform isEqualToString:@"iPad1,1"])      return @"iPad 1";
    
    if ([platform isEqualToString:@"iPad2,1"])      return @"iPad 2 (WiFi)";
    
    if ([platform isEqualToString:@"iPad2,2"])      return @"iPad 2 (GSM)";
    
    if ([platform isEqualToString:@"iPad2,3"])      return @"iPad 2 (CDMA)";
    
    if ([platform isEqualToString:@"iPad3,1"])      return @"iPad 3 (WiFi)";
    
    if ([platform isEqualToString:@"iPad3,2"])      return @"iPad 3 (4G,2)";
    
    if ([platform isEqualToString:@"iPad3,3"])      return @"iPad 3 (4G,3)";
    
    if ([platform isEqualToString:@"i386"])         return @"Simulator";
    
    if ([platform isEqualToString:@"x86_64"])       return @"Simulator";
    
    
    return platform;
}

+(NSMutableDictionary*) setSearchFormForRestCall:(NSMutableDictionary*) dict
{
    //sorting
    [dict setValue:[[session singleton] userdata:@"sort_by"] forKey:@"sort_by"];

    //filter
    if( true )
    {
        [dict setValue:@"" forKey:@"product_name"];
        [dict setValue:[[session singleton] userdata:@"search_propertyid"] forKey:@"product_id"];
        [dict setValue:[NSString stringWithFormat:@"%@|%@",[[session singleton] userdata:@"search_year"],[[session singleton] userdata:@"search_month"]] forKey:@"date_filter"];
        [dict setValue:[[session singleton] userdata:@"search_status"] forKey:@"product_attribute__cst_pcnf1"];
    }

    return dict;
}

+(NSString*)getLacalDateFromDateBasedSessionTimezone:(NSString*)localeDate formatIn: (NSString*)formatIn outputFormat:(NSString*) outputFormat
{
    //get timezone from session
    float hours_diff = [[imui singleton] getTimeZone];
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:formatIn];
    NSDate *date = [dateFormat dateFromString:localeDate];
    
    //add hours diff
    
    int hour = floor(hours_diff);
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];

    NSDateComponents *components = [[NSDateComponents alloc] init];
    [components setHour:hour];
    
    date = [calendar dateByAddingComponents:components toDate:date options:0];
 
    dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:outputFormat];
    
    
    return [dateFormat stringFromDate:date];
}

-(float) getTimeZone
{
    NSString* res = [[session singleton] userdata:@"timezone"];
    
    if( ![imlb isStrEmptyStrict:res] )
    {
        return [imlb strToFloatSecure:res];
    }
    else
    {
        return [imlb strToFloatSecure:@"-8"];
    }
}

+(NSString *)getUTCFormateDatefromDateBasedSessionTimezone:(NSDate *)localDate dateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    
    [dateFormatter setTimeZone:timeZone];
    
    [dateFormatter setDateFormat:dateFormat];
    
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    
    return dateString;
}


+(NSString*)getLacalDateFromDate:(NSString*)localeDate formatter : (NSString*)dateformatter
{
    // create dateFormatter with UTC time format
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:dateformatter];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    NSDate *date = [dateFormatter dateFromString:localeDate]; // create date from string
    
    // change to a readable time format and change to local time zone
    [dateFormatter setDateFormat:dateformatter];
    
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    
    return [dateFormatter stringFromDate:date];
}

+(NSString *)getUTCFormateDatefromDate:(NSDate *)localDate dateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    
    [dateFormatter setTimeZone:timeZone];
    
    [dateFormatter setDateFormat:dateFormat];
    
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    
    return dateString;
}

+(NSDate *) getDatefromString:(NSString *)dateString strForm : (NSString*)strForm
{
    NSDateFormatter* firstDateFormatter = [[NSDateFormatter alloc] init];
    [firstDateFormatter setDateFormat:strForm];
    [firstDateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    return [firstDateFormatter dateFromString:dateString];
}

+(NSString *)getUTCFormateDateFromString:(NSString *)localDate strForm : (NSString*)strForm
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:strForm];
    
    NSDate *dateFormatted = [dateFormatter dateFromString:localDate];
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:strForm];
    
    NSString *dateString = [dateFormatter stringFromDate:dateFormatted];

    return dateString;
}

@end
