//
//  lang.m
//  XClient
//
//  Created by Hitesh Khunt on 29/04/15.
//  Copyright (c) 2015 XClient. All rights reserved.
//

#import "lang.h"
#import "session.h"
#import "sqLiteHelper.h"

@implementation lang

static lang *langSingleton;

+(lang *) singleton
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        langSingleton = [[lang alloc] init];
        
        /**
         * update LANG session key
         */
        langSingleton.LANG = [NSString stringWithFormat:@"%@_", [[session singleton] userdata:@"lang"]];

    }
    
    return langSingleton;
}

/**
 *
 */
-(BOOL) islabel:(NSString *) key
{
    NSString *val = [[sqLiteHelper singleton] getConfigKey:key ];
    if( [val length] == 0 )
    {
        return NO;
    }
    else
    {
        return YES;
    }
}

-(void) setLabel:(NSString *) key withValue:(NSString *) label
{
    [[sqLiteHelper singleton] updInsConfigKey: key withValue: label ];
}

-(NSString *) getLabel:(NSString *) key
{
    return [[sqLiteHelper singleton] getConfigKey: key ];
}

+(NSString *) fromLang
{
    if( [[[session singleton] userdata:@"current_lang"] isEqualToString:@"EN"] )
    {
     return @"english";
    }
    else
    {
    return @"french";
    }
}

+(NSString *) toLang
{
    if( [[[session singleton] userdata:@"current_lang"] isEqualToString:@"EN"] )
    {
        return @"french";
    }
    else
    {
        return @"english";
    }

}

+(NSString *) fromLangSound
{
    if( [[[session singleton] userdata:@"current_lang"] isEqualToString:@"EN"] )
    {
        return @"english_sound";
    }
    else
    {
        return @"french_sound";
    }
}

+(NSString *) toLangSound
{
    if( [[[session singleton] userdata:@"current_lang"] isEqualToString:@"EN"] )
    {
        return @"french_sound";
    }
    else
    {
        return @"english_sound";
    }
    
}


+(NSString *) langButtonLabel
{
    if( [[[session singleton] userdata:@"current_lang"] isEqualToString:@"EN"] )
    {
        return @"En --> Fr";
    }
    else
    {
        return @"Fr --> En";
    }
}

+(void) switchLang
{
    if( [[[session singleton] userdata:@"current_lang"] isEqualToString:@"EN"] )
    {
        [[session singleton] set_userdata:@"current_lang" withValue:@"FR"];
    }
    else
    {
        [[session singleton] set_userdata:@"current_lang" withValue:@"EN"];
    }
}


/**
 * de reference all references to object and variable it will help prevent memory leak/massive memory usage 
 */
-(void) do_cleanup
{
    //it seems that due to ARC, releaseing memory is not necessary but needs thought over this
    //lang = null;
}

@end
