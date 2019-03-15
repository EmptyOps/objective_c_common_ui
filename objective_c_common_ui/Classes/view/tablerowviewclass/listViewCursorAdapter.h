//
//  listViewAdapter.h
//  XClient
//
//  Created by Hitesh Khunt on 20/06/15.
//  Copyright (c) 2015 XClient. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "he_Controller.h"

@interface listViewCursorAdapter : NSObject

@property (nonatomic,strong) he_Controller *he_ControllerObj;

@property (nonatomic,strong) NSString *rowType;
@property BOOL isLongClick;
@property (nonatomic,strong) NSArray *label;
@property (nonatomic,strong) NSArray *desc;
@property (nonatomic,strong) NSArray *images;
@property (nonatomic,strong) NSArray *href;
@property (nonatomic,strong) NSArray *params;
@property (nonatomic,strong) NSString *status;
@property (nonatomic,strong) NSString *bookingSite;

@property (strong, nonatomic) UILabel *infoLabel;
@property (strong, nonatomic) NSArray *options;
@property (nonatomic, retain) NSMutableArray *posts;
@property (nonatomic,strong) NSString *cat_id;
@property (nonatomic,strong) NSString *pro_id;
@property (nonatomic,strong) NSString *order_idnew;

/**
 * @since 19-05-2015
 * No records row support by default
 */
@property BOOL is_no_records;

/**
 * @since 26-05-2015
 */
@property BOOL is_more_records;
/**
 * @since 18-10-2016
 */
@property BOOL is_local_cursor;
/**
 * @since 27-05-2015
 *
 */

/**
 * @since 26-05-2015
 * more records callback controller
 */
@property (nonatomic,strong) NSString *moreC;

/**
 * @since 26-05-2015
 * more records callback href
 */
@property (nonatomic,strong) NSString *moreH;

/**
 * @since 26-05-2015
 * more records callback hrefParams
 */
@property (nonatomic,strong) NSString *moreP;

/**
 * @since 29-03-2017
 * is load more method call POST?
 */
@property BOOL *isLoadMoreMethodPost;

/**
 * total records count
 */
@property int cursor_getCount;

@property (retain, nonatomic) NSMutableArray *arrayForTableContent;

@property (retain, nonatomic) NSDictionary *collectionViewsDict;

@property bool is_loadMoreItems_in_progress;

@property(nonatomic,retain)UIDocumentInteractionController *docFile;

@property int totalrows;

-(void) cellForRowAtIndexPathPreProcessing:(UITableView *)tableView :(NSIndexPath *)indexPath :(NSString *)label :(NSString *)desc :(NSString *)image :(NSString *)href :(NSString *)param;

-(void) initializeSimple:(he_Controller*) he_ControllerObj withMode:(NSString*) mode withList:(NSArray*) label withDesc:(NSArray*) desc withImages:(NSArray*) images withHref:(NSArray*) href withParams:(NSArray*) params withLongClick:(BOOL) isLongClick is_records:(BOOL) is_records
                   moreC:(NSString*) moreC moreH:(NSString*)moreH moreP:(NSString*) moreP is_local_cursor:(BOOL) is_local_cursor maxPage:(int) maxPage;

@property int maxPages;

-(NSDictionary *) getRowAtNo:(NSInteger) rowNo;

-(NSMutableDictionary *) processRowDataStructure:(NSArray*) label withDesc:(NSArray*) desc withImages:(NSArray*) images withHref:(NSArray*) href withParams:(NSArray*) params;

-(void) fillCursorTable:(he_Controller*) he_ControllerObj withList:(NSArray*) label withDesc:(NSArray*) desc withImages:(NSArray*) images withHref:(NSArray*) href withParams:(NSArray*) params is_new_adapter:(BOOL) is_new_adapter mode:(NSString*) mode is_local_cursor:(BOOL) is_local_cursor;

/**
 * total records count
 */
@property int currentPage;


- (void)didReceiveMemoryWarning;
-(void)printMode;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

-(NSDictionary *) getRow:(NSIndexPath *) indexPath;

@end
