//
//  config.m
//  XClient
//
//  Created by Hitesh Khunt on 13/06/15.
//  Copyright (c) 2015 XClient. All rights reserved.
//

#import "config.h"
#import "session.h"

@implementation config

static config *configSingleton;

+(config *) singleton
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        configSingleton = [[config alloc] init];
        
        [configSingleton initialize];
    }
    
    return configSingleton;
}

-(void) initialize
{
    //REST to dev or staging or live server
    if( ENV == 3 )
    {
        self.REST_URL = rest_url_3;

    }
    else if( ENV == 2 )
    {
        /**
         * 10-01-2015: change this with staging server's sub domain <br>
         *
         * 22-01-2015: now since a new sub domain published on each new release of REST Version <br>
         * that sub domain will be considered as staging server and yes also as a production :-) server for that REST Version
         */
        self.REST_URL = rest_url_2;
    }
    else if( ENV == 1 )
    {
        self.REST_URL = rest_url_1;
    }
}


-(NSString *) restUrl:(NSString *) controller
            withQuery:(NSString *)query
{
    return [NSString stringWithFormat:@"%@%@?%@=%@&%@=%f&%@&%@=json", self.REST_URL, controller, sessid_index, [[session singleton] getSessionId], app_key_index, rest_ver, query, out_format_index];
}

-(NSString *) cdnUrl:(NSString *) controller
           withQuery:(NSString *)query
{
    return [NSString stringWithFormat:@"%@%@?%@=%@&%@=%f&%@&%@=json", self.ASSET_URL, controller, sessid_index, [[session singleton] getSessionId], app_key_index, rest_ver, query, out_format_index];
}

-(NSString *) restUri:(NSString *) controller
            withQuery:(NSString *)query
{
    return [NSString stringWithFormat:@"%@?%@=%@&%@=%f&%@&%@=json", controller, sessid_index, [[session singleton] getSessionId], app_key_index, rest_ver, query, out_format_index];
}

-(NSDictionary *) restUrlQueryParams:(NSString *)query
{
    NSDictionary *queryParams = @{sessid_index : [[session singleton] getSessionId],
                                  app_key_index : [NSString stringWithFormat:@"%f", rest_ver],
                                  out_format_index : @"json"};
    
    if( [query length] > 0 )
    {
        NSArray *tempA = [query componentsSeparatedByString:@"&"];
        NSMutableDictionary *tempD = [[NSMutableDictionary alloc] init];
        for (NSString *str in tempA)
        {
            NSArray *tempA1 = [str componentsSeparatedByString:@"="];
            if( [tempA1 count] > 1 )
            {
                [tempD setObject:[tempA1 objectAtIndex:0] forKey:[tempA1 objectAtIndex:1]];
            }
        }
        
        [tempD addEntriesFromDictionary:queryParams];
        
        queryParams = tempD;
    }
    
    
    return queryParams;
}


/**
 * returns user image uploadId key part
 */
-(NSString *) u_imageUploadIdKey
{
    return @"PIU_";
}

@end
