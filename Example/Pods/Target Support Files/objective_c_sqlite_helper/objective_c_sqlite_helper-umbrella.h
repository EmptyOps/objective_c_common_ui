#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "FMDatabase.h"
#import "FMDatabasePool.h"
#import "FMResultSet.h"
#import "sqLiteHelper.h"
#import "Utility.h"

FOUNDATION_EXPORT double objective_c_sqlite_helperVersionNumber;
FOUNDATION_EXPORT const unsigned char objective_c_sqlite_helperVersionString[];

