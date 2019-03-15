//
//  log.m
//  XClient
//
//  Created by Hitesh Khunt on 11/06/15.
//  Copyright (c) 2015 XClient. All rights reserved.
//

#import "logWrapper.h"

@implementation logWrapper

+ (void)debug:(NSString *)msg
{
    NSLog(@"debug: %@", msg);
}


+ (void)logError:(NSString *)msg
           trace:(NSString *)trace
        priority:(int)priority
{
    NSLog(@"Error log: %@", msg);
}

+ (void)printStackTrace:(NSException *)e
{
    NSLog(@"%@",[NSThread callStackSymbols]);
}
@end
