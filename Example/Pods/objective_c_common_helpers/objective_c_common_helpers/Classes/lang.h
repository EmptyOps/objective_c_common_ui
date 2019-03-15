//
//  lang.h
//  XClient
//
//  Created by Hitesh Khunt on 29/04/15.
//  Copyright (c) 2015 XClient. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface lang : NSObject

/**
 * lang session right now in app, it needs to be updated whenever user switches LANG session.
 * Variable is intended to be used whenever each time getLabel function called can use it
 */
@property (nonatomic, strong) NSString *LANG;

    +(lang *) singleton;

//public boolean is_label_synced = false;

    -(BOOL) islabel:(NSString *) key;

    -(void) setLabel:(NSString *) key withValue:(NSString *) label;

    -(NSString *) getLabel:(NSString *) key;

    +(NSString *) fromLang;

    +(NSString *) toLang;

    +(NSString *) fromLangSound;

    +(NSString *) toLangSound;

    +(NSString *) langButtonLabel;

    +(void) switchLang;

    -(void) do_cleanup;

@end
