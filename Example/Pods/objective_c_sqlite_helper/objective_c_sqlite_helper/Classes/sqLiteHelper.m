//
//  sqLiteHelper.m
//  fmdbTest
//
//  Created by Hitesh Khunt on 28/04/15.
//  Copyright (c) 2015 Hitesh Khunt. All rights reserved.
//

#import "sqLiteHelper.h"
//#import "config.h"

@implementation sqLiteHelper

static sqLiteHelper *sqLiteHelperSingleton;
FMDatabase *dbClassLcl;

+(sqLiteHelper *) singleton
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        sqLiteHelperSingleton = [[sqLiteHelper alloc] init];
    }
    
    return sqLiteHelperSingleton;
}

// last changed in 23_02_2019 11:03 AM
+(NSString *) getDatabaseName
{
    return @"gj_sqlite.sqlite";
}

+(NSString *) getDatabasePath
{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [documentPaths objectAtIndex:0];
    return [documentDir stringByAppendingPathComponent:[sqLiteHelper getDatabaseName]];
}

/**
 *
 */
-(void) initDb
{
    [self createAndCheckDatabase];
}

/**
 * will check if database is already copied first time to documents folder of app, if YES then 
 * it will do nothing otherwise it will copy first time
 */
-(void) createAndCheckDatabase
{
    BOOL success;
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    success = [fileManager fileExistsAtPath:[sqLiteHelper getDatabasePath]];
    
    NSLog(@" fileManager %@ " , [sqLiteHelper getDatabasePath] );
    if(success)
    {
        //NSLog(@"DB already exist at in App's document directory");
        return;
    }
    
    NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:[sqLiteHelper getDatabaseName]];
    
    [fileManager copyItemAtPath:databasePathFromApp toPath:[sqLiteHelper getDatabasePath] error:nil];
    
    //NSLog(@"DB copied to App's document directory");
}

/**
 * upgrade DATABASE_VERSION by 1 whenever new App or update is released <br>
 * Incremented DATABASE_VERSION will make sure that onUpgrade is called after upgrade of APK and App is launched <br>
 * Also make sure that new release of DB updates is applied to onCreate so the device that install new version directly will have that updates.
 */
//private final static int DATABASE_VERSION = 12;

/**
 * 1 if on create is called, 2 if on upgrade is called, 0 if nothing is called.
 */
//private int is_db_creat_or_upgrade = 0;

//NOTE: You should always use @try-@catch-@finally blocks when working with database connections and make sure the database connection is closed in the @finally block. This will ensure that the connection is closed even when an exception is thrown.
/**
 *
 * @param key
 * @param value
 */
-(NSDictionary *) getRow:(NSString *) sql withParam: (NSArray *) params
{
    NSDictionary *row = nil;
    FMDatabase *db = [FMDatabase databaseWithPath:[sqLiteHelper getDatabasePath]];
    
    if( db )
    {
        [db open];
        
        FMResultSet *results = [db executeQuery:sql];
        
        if( results )
        {
            while([results next])
            {
                row = [results resultDictionary];
                break;
            }
            
            [results close];
        }
        
        
        [db close];
    }
    
    return row;
}

//NOTE: You should always use @try-@catch-@finally blocks when working with database connections and make sure the database connection is closed in the @finally block. This will ensure that the connection is closed even when an exception is thrown.
/**
 *
 * @param key
 * @param value
 */
-(BOOL) query:(NSString *) sql withParam: (NSArray *) params
{
    BOOL success;
    FMDatabase *db = [FMDatabase databaseWithPath:[sqLiteHelper getDatabasePath]];
    
    if( db )
    {
        [db open];
        
        success = [db executeUpdate:sql];
        
        [db close];
    }
    
    return success;
}

+(NSString*) escapeString:(NSString*) str
{
    //str = [str stringByReplacingOccurrencesOfString:@"#" withString:@""];
    str = [str stringByReplacingOccurrencesOfString:@"\"" withString:@"'"];
    //    NSData *temp = [str dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    //    return [[NSString alloc] initWithData:temp encoding:NSASCIIStringEncoding];
    return str;
}

//NOTE: You should always use @try-@catch-@finally blocks when working with database connections and make sure the database connection is closed in the @finally block. This will ensure that the connection is closed even when an exception is thrown.
/**
 *
 * @param key
 * @param value
 */
-(FMResultSet *) executeQuery:(NSString *) sql withParam: (NSArray *) params
{
    FMResultSet *results = nil;
    dbClassLcl = [FMDatabase databaseWithPath:[sqLiteHelper getDatabasePath]];
    
    if( dbClassLcl )
    {
        [dbClassLcl open];
        
        results = [dbClassLcl executeQuery:sql];
        
        //commented on 18-03-2017 and moved inside closeExecuteQueryDb function
        //[db close];
    }
    
    return results;
}

/**
 * added on 18-03-2017
 *
 * close execute query db
 */
-(void) closeExecuteQueryDb
{
    [dbClassLcl close];
}

/**
 *
 * @param key
 * @param value
 */
-(BOOL) isRowExist:(NSString *) sql withParam: (NSArray *) params
{
    NSDictionary *row = [self getRow:sql withParam:params];
    
    if( row )
    {
        return YES;
    }
    else
    {
        return NO;
    }
}

/**
 *
 * @param key
 * @param value
 */
-(NSDictionary *) checkIfRowExist:(NSString *) sql withParam: (NSArray *) params
{
    return [self getRow:sql withParam:params];
}

/**
 * checks if specified table exist in DB
 */
-(BOOL) isTableExists:(NSString *) tableName
{
    return [self checkIfRowExist:@"" withParam:nil];
}

-(void) dbInitialUpdate
{
    
    NSLog(@"dbInitialUpdate called");
    
    //[temp]: need to move it to version update initialized function/class like done in android sqLiteHelper
    [[sqLiteHelper singleton] query:@"CREATE TABLE IF NOT EXISTS config ( c_key TEXT UNIQUE , c_value TEXT )" withParam:nil];
    
    [self query:@"DROP TABLE IF EXISTS cur_ada" withParam:nil];

    [[sqLiteHelper singleton] query:@"CREATE TABLE IF NOT EXISTS cur_ada ( _id INTEGER, mode TEXT , label TEXT , desc TEXT , image TEXT , href TEXT , param TEXT )" withParam:nil];

}

-(void) versionUpdate
{
    NSLog(@"versionUpdate called");
}

/**
 *
 * @param key
 * @param value
 */
-(void) updInsConfigKey:(NSString *) key withValue:(NSString *) value
{
    [self query: [NSString stringWithFormat: @" INSERT OR REPLACE INTO config (c_key, c_value) VALUES ('%@', '%@') ", key, value]  withParam:nil];
}

/**
 *
 * @param key
 */
-(NSString *) getConfigKey:(NSString *) key
{
    //NSArray *param = [NSArray arrayWithObjects:key, nil];
    
    NSDictionary *row  = [self checkIfRowExist:[NSString stringWithFormat:@" SELECT c_value FROM config WHERE c_key='%@' ", key]  withParam:nil ];
    if( row )
    {
        return [row valueForKey:@"c_value"];
    }
    
    return @"";
}

/**
 *
 * @param key
 */
-(void) deleteConfigKey:(NSString *) key
{
    [self query: [NSString stringWithFormat:@" DELETE FROM config WHERE c_key='%@' ", key] withParam:nil];
}

@end
