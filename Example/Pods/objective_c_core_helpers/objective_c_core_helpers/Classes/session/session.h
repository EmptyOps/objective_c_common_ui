//
//  session.h
//  XClient
//
//  Created by Hitesh Khunt on 29/04/15.
//  Copyright (c) 2015 XClient. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface session : NSObject

+(session *) singleton;

-(NSString *) getSessionId;

-(void) setSessionId:(NSString *) session_id;

-(NSString *) userdata:(NSString *) key;

-(void) set_userdata:(NSString *) key withValue:(NSString *) val;

-(void) unset_userdata:(NSString *) key;

-(void) setFlashMessage:(NSString *) key withValue:(NSString *) msg;

-(NSString *) getFlashMessage:(NSString *) key;

-(void) _flashdata_sweep:(NSString *) key;

-(void) setLoginSessions:(NSDictionary*) responseObj;

-(void) unsetLoginSessions;

-(void) setShippSessions:() responseObj;

-(void) unsetCheckOutSession;

-(void) updateLangSession:() responseObj withValue:(NSString *) lang;

-(void) setJSONSession:(NSString *) key withValue:(NSDictionary *) jsonObj;

-(NSDictionary *) getJSONSession:(NSString *) key;

-(void) setArray:(NSMutableArray *) saveValue key :(NSString*)arrayKey;

-(NSMutableArray *) getArray: (NSString*)arrayKey;

-(void) setObject:(id) saveValue key :(NSString*)arrayKey;

-(id) getObject: (NSString*)arrayKey;

-(BOOL) isSellerLoggedIn;

-(BOOL) isAdmin;
-(BOOL) isOwner;
-(BOOL) isManager;
-(BOOL) isStaff;

/***************************** location functions *********************************/

- (void) setGeoLocation:(NSString *)last_latitude longitude:(NSString*)last_longitude Text:(NSString*)last_location_text city:(NSString*)city;

-(NSString*) getLocationText;

-(NSString*) getLastLatitude;

-(NSString*) getLastLongitude;

/***************************** location functions ends *********************************/


/***************************** search session functions *********************************/

- (void) setSearchGeoLocation:(NSString *)last_latitude longitude:(NSString*)last_longitude Text:(NSString*)last_location_text city:(NSString*)city;

-(NSString*) getSearchCity;

-(NSString*) getSearchLatitude;

-(NSString*) getSearchLongitude;

-(NSString*) getSearchLocationText;

/***************************** search session functions ends *********************************/

@end
