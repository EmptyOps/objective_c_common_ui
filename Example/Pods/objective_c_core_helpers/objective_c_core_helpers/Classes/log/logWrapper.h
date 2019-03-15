//
//  log.h
//  XClient
//
//  Created by Hitesh Khunt on 11/06/15.
//  Copyright (c) 2015 XClient. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface logWrapper : NSObject

/**
 */
+ (void)debug:(NSString *)msg;


/**
 */
+ (void)logError:(NSString *)msg
               trace:(NSString *)trace
           priority:(int)priority;

/**
 */
+ (void)printStackTrace:(NSException *)e;


@end
