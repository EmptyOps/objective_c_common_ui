//
//  session.m
//  XClient
//
#import "session.h"
#import "config.h"

@implementation session

static session *sessionSingleton;

+(session *) singleton
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        sessionSingleton = [[session alloc] init];
    }
    
    return sessionSingleton;
}

-(NSString *) getSessionId
{
    NSString *session_id = [[session singleton] userdata:@"session_id"];
    if( [session_id length] == 0 )
    {
        return @"0";
    }
    else
    {
        return session_id;
    }
}

-(void) setSessionId:(NSString *) session_id
{
    [[session singleton] set_userdata:@"session_id" withValue:session_id];
}

-(NSString *) userdata:(NSString *) key
{
    NSString *val = [[NSUserDefaults standardUserDefaults] valueForKey:key];
    return val == nil ? @"" : val;
}

/**
 * update LANG session key for this class and lang session it self
 */

-(void) updateLangSession:() responseObj withValue:(NSString *) lang
{
    NSString *LANG = [lang stringByAppendingString:@"_"] ;
    
    [self set_userdata:@"lang" withValue:LANG];
}

/************************************ JSON session functions ***************************************/

/**
 *
 */
-(void) setJSONSession:(NSString *) key withValue:(NSDictionary *) jsonObj
{
    //save drawer menu in session
    NSData *plist = [NSPropertyListSerialization
                     dataWithPropertyList:jsonObj
                     format:NSPropertyListXMLFormat_v1_0
                     options:kNilOptions
                     error:NULL];
    NSString *str = [[NSString alloc] initWithData:plist encoding:NSUTF8StringEncoding];
    
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

/**
 *
 */
-(NSDictionary *) getJSONSession:(NSString *) key
{
    NSString *savedValue = [[NSUserDefaults standardUserDefaults]
                            stringForKey:key];
    if( savedValue == nil )
    {
        return nil;
    }
    
    NSDictionary *resObj = [NSPropertyListSerialization
                            propertyListWithData:[savedValue dataUsingEncoding:NSUTF8StringEncoding]
                            options:kNilOptions
                            format:NULL
                            error:NULL];
    
    return resObj;
}

/************************************ JSON session functions END ***********************************/

/**
 * stores string value in session
 */
-(void) set_userdata:(NSString *) key withValue:(NSString *) val
{
    [[NSUserDefaults standardUserDefaults] setValue:val forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void) unset_userdata:(NSString *) key
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 *
 */
-(void) setFlashMessage:(NSString *) key withValue:(NSString *) msg
{
    [self set_userdata:[NSString stringWithFormat:@"flash_/%@", key] withValue:msg];
}

/**
 *
 */
-(NSString *) getFlashMessage:(NSString *) key
{
    return [self userdata: [NSString stringWithFormat:@"flash_/%@", key] ];
}

/**
 * PRIVATE: Internal method - removes "flash" session marked as 'old'
 */
-(void) _flashdata_sweep:(NSString *) key
{
    [self unset_userdata: [NSString stringWithFormat:@"flash_/%@", key] ];
}

/**
    ******* Set login sesion and Unset login session  functions ********
 */

-(void) setLoginSessions:(NSDictionary*) responseObj
{

    [[session singleton] set_userdata:@"customer_id" withValue: [responseObj objectForKey: @"customer_id"]];
    [[session singleton] set_userdata:@"login_from" withValue: [responseObj objectForKey: @"mode"]];   //@"DIRECT"];
    [[session singleton] set_userdata:@"firstname" withValue: [responseObj objectForKey: @"customer_firstname"]];
    [[session singleton] set_userdata:@"email" withValue: [responseObj objectForKey: @"customer_emailid"]];
    [[session singleton] set_userdata:@"su_type" withValue: [responseObj objectForKey: @"su_type"]];
    [[session singleton] set_userdata:@"session_id" withValue: [responseObj objectForKey: @"session_id"]];
    [[session singleton] set_userdata:@"sc_social_id" withValue: [responseObj objectForKey: @"sc_social_id"]];
    [[session singleton] set_userdata:@"seller_plan_id" withValue: [responseObj objectForKey: @"seller_plan_id"]];
    
}

-(void) unsetLoginSessions
{
    
    NSLog(@"unsetLoginSessions..");
    [self setSessionId:@"0" ];
    [self unset_userdata:@"email" ];
    [self unset_userdata:@"firstname" ];
    [self unset_userdata:@"customer_id"];
    [self unset_userdata:@"login_from"];
    [self unset_userdata:@"su_type"];
    [self unset_userdata:@"sf_social_group_id"];
    
}

/**
 ************* set and unset session function End **************
 */

/**
 *
 */
-(BOOL) isSellerLoggedIn
{
    return ( [[self userdata:@"su_type"] isEqualToString:@"S"]  ) ? YES : NO;
}

-(void) setShippSessions:() responseObj
{
    [[session singleton] set_userdata:@"customer_shipping_address_id" withValue: [responseObj objectForKey: @"customer_shipping_address_id"]];
    [[session singleton] set_userdata:@"customer_billing_address_id" withValue: [responseObj objectForKey: @"customer_billing_address_id"]];
    [[session singleton] set_userdata:@"is_shipping_valid" withValue: [responseObj objectForKey: @"is_shipping_valid"]];
}

/**
 * save NSArray in NSUserdefault
 */

-(void) setArray:(NSMutableArray *) saveValue key :(NSString*)arrayKey
{
    [[NSUserDefaults standardUserDefaults] setValue:saveValue forKey:arrayKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 * get NSArray in NSUserdefault
 */

-(NSMutableArray *) getArray: (NSString*)arrayKey
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:arrayKey];
}

/**
 * save NSArray in NSUserdefault
 */
-(void) setObject:(id) saveValue key :(NSString*)arrayKey
{
    [[NSUserDefaults standardUserDefaults] setValue:saveValue forKey:arrayKey];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

/**
 * get NSArray in NSUserdefault
 */

-(id) getObject: (NSString*)arrayKey
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:arrayKey];
}

/**
 *
 */
-(BOOL) isAdmin
{
    return ( [[self userdata:@"seller_plan_id"] isEqualToString:@"1"] ) ? YES : NO;
}

-(BOOL) isOwner
{
    return ( [[self userdata:@"seller_plan_id"] isEqualToString:@"2"] ) ? YES : NO;
}

-(BOOL) isManager
{
    return ( [[self userdata:@"seller_plan_id"] isEqualToString:@"3"] ) ? YES : NO;
}

-(BOOL) isStaff
{
    return ( [[self userdata:@"seller_plan_id"] isEqualToString:@"4"] ) ? YES : NO;
}


/**
 * function will unset check out related all session on completion of order,
 * here it is required to note that on REST client all JavaScript counter part sessions are held in
 * client sessions and not server session. SO Don't confuse it with server session.
 */

-(void) unsetCheckOutSession
{
    /**
     * Well! now it is decided to not flush checkout session after order is placed.
     * So that in future check out it will be easy for users.
     */
    //[temp]: Comment below unset statement, to make checkout process faster
    //in next orders for user by keeping old checkout session. But only do it
    //if it is viable in all terms refer to other app flows as well.
    
    [self unset_userdata:@"is_shipping_valid" ];
    [self unset_userdata:@"customer_shipping_address_id"];
    [self unset_userdata:@"customer_billing_address_id"];
    [self unset_userdata:@"order_id"];
}

/***************************** location functions *********************************/

- (void) setGeoLocation:(NSString *)last_latitude longitude:(NSString*)last_longitude Text:(NSString*)last_location_text city:(NSString*)city
{
    [self set_userdata:@"last_city" withValue: city];
    [self set_userdata:@"last_latitude" withValue: last_latitude];
    [self set_userdata:@"last_longitude" withValue: last_longitude];
    [self set_userdata:@"last_location_text" withValue: last_location_text];
}

-(NSString*) getLocationText
{
    return [self userdata:@"last_location_text"];
}

-(NSString*) getLastLatitude
{
    return [self userdata:@"last_longitude"];
}

-(NSString*) getLastLongitude
{
    return [self userdata:@"last_latitude"];
}


/***************************** location functions ends *********************************/


/***************************** search session functions *********************************/

- (void) setSearchGeoLocation:(NSString *)last_latitude longitude:(NSString*)last_longitude Text:(NSString*)last_location_text city:(NSString*)city
{
    [self set_userdata:@"search_city" withValue: city];
    [self set_userdata:@"search_latitude" withValue: last_latitude];
    [self set_userdata:@"search_longitude" withValue: last_longitude];
    [self set_userdata:@"search_location_text" withValue: last_location_text];
}

-(NSString*) getSearchCity
{
    NSString *search_city = [self userdata:@"search_city"];
    if( [search_city isEqualToString:@""] )
    {
        return [self userdata:@"last_city"];
    }
    else
    {
        return search_city;
    }
}

-(NSString*) getSearchLatitude
{
    NSString *search_latitude = [self userdata:@"search_latitude"];
    if( [search_latitude isEqualToString:@""] )
    {
        return [self userdata:@"last_longitude"];
    }
    else
    {
        return search_latitude;
    }
}

-(NSString*) getSearchLongitude
{
    NSString *search_longitude = [self userdata:@"search_longitude"];
    if( [search_longitude isEqualToString:@""] )
    {
        return [self userdata:@"last_latitude"];
    }
    else
    {
        return search_longitude;
    }
}

-(NSString*) getSearchLocationText
{
    NSString *search_location_text = [self userdata:@"search_location_text"];
    if( [search_location_text isEqualToString:@""] )
    {
        return [self userdata:@"last_location_text"];
    }
    else
    {
        return search_location_text;
    }
}

/***************************** search session functions ends *********************************/

@end
