#import <Foundation/Foundation.h>
#import "FMDatabase.h"
#import "FMResultSet.h"
#import "Utility.h"

@interface sqLiteHelper : NSObject
{
    
}

    //singltone
    +(sqLiteHelper *) singleton; 

    -(NSMutableArray *) getCustomers;


    //initialization
    -(void) initDb;

/**
 * will check if database is already copied first time to documents folder of app, if YES then
 * it will do nothing otherwise it will copy first time
 */
    -(void) createAndCheckDatabase;

    -(NSDictionary *) getRow:(NSString *) sql withParam: (NSArray *) params;

    -(BOOL) query:(NSString *) sql withParam: (NSArray *) params;

    +(NSString*) escapeString:(NSString*) str;

    -(FMResultSet *) executeQuery:(NSString *) sql withParam: (NSArray *) params;

    -(void) closeExecuteQueryDb;

    -(BOOL) isRowExist:(NSString *) sql withParam: (NSArray *) params;

    -(NSDictionary *) checkIfRowExist:(NSString *) sql withParam: (NSArray *) params;

    -(BOOL) isTableExists:(NSString *) tableName;

    -(void) updInsConfigKey:(NSString *) key withValue:(NSString *) value;

    -(NSString *) getConfigKey:(NSString *) key;

    -(void) deleteConfigKey:(NSString *) key;

-(void) dbInitialUpdate;

-(void) versionUpdate;


@end
