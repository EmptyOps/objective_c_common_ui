//
//  listViewAdapter.m
//  XClient
//
//  Created by Hitesh Khunt on 20/06/15.
//  Copyright (c) 2015 XClient. All rights reserved.
//

#import "listViewCursorAdapter.h"
#import "sqLiteHelper.h"
#import "config.h"
#import "imlb.h"
#import "imui.h"
#import "lang.h"

@implementation listViewCursorAdapter

-(void) initializeSimple:(he_Controller*) he_ControllerObj withMode:(NSString*) mode withList:(NSArray*) label withDesc:(NSArray*) desc withImages:(NSArray*) images withHref:(NSArray*) href withParams:(NSArray*) params withLongClick:(BOOL) isLongClick is_records:(BOOL) is_records
                   moreC:(NSString*) moreC moreH:(NSString*)moreH moreP:(NSString*) moreP is_local_cursor:(BOOL) is_local_cursor maxPage:(int) maxPage

{
    self.he_ControllerObj = he_ControllerObj;
    
    self.rowType = mode;
    self.label = label;
    self.desc = desc;
    self.images = images;
    self.href = href;
    self.params = params;
    self.maxPages = maxPage;
    self.posts = [[NSMutableArray alloc] init];
    self.currentPage = 0;
    
    [self fillCursorTable:self.he_ControllerObj withList:self.label withDesc:self.desc withImages:self.images withHref:self.href withParams:self.params is_new_adapter:YES mode:self.rowType is_local_cursor:is_local_cursor];
    
    self.isLongClick = isLongClick;
    self.is_local_cursor = is_local_cursor;
    
    //is records
    if( false && [self.label count] == 0 )
    {
        if(!is_local_cursor)
        {
            self.is_no_records = YES;
        }
    }
    else
    {
        self.is_no_records = NO;
    }
    
    //is more records
    if(is_records)
    {
        NSLog(@"loadmore2 moreC: %@ moreH: %@ moreP :%@",moreC,moreH,moreP);
        self.is_more_records = YES;
        self.moreC = moreC;
        self.moreH = moreH;
        self.moreP = moreP;
    }
    else
    {
        self.is_more_records = NO;
    }
    
}

-(void) printMode
{
    NSLog(@"printMode: %@", self.rowType);
}

/**
 *
 */
-(NSMutableDictionary *) processRowDataStructure:(NSArray*) label withDesc:(NSArray*) desc withImages:(NSArray*) images withHref:(NSArray*) href withParams:(NSArray*) params
{
    NSMutableDictionary *tempDict = nil;
    
    return tempDict;
}


/**
 * cursor table filler and updater for ajax kind of loaded data
 */
-(void) fillCursorTable:(he_Controller*) he_ControllerObj withList:(NSArray*) label withDesc:(NSArray*) desc withImages:(NSArray*) images withHref:(NSArray*) href withParams:(NSArray*) params is_new_adapter:(BOOL) is_new_adapter mode:(NSString*) mode is_local_cursor:(BOOL) is_local_cursor
{
    /**
     *
     */
    int j = 0;
    if(!is_local_cursor)
    {
        if( is_new_adapter )
        {
            NSLog(@" fillCursorTable %@ " , mode );
            
            [[sqLiteHelper singleton] query:[NSString stringWithFormat:@"DELETE FROM cur_ada WHERE mode='%@'" ,  mode ] withParam:nil];
        
            /**
             * if it is new adapter and no records then set precautions to display so
             */
            if( (false) && [label count] == 0 )
            {
                label = [NSArray arrayWithObjects:@"No records found!", nil];
                desc = [NSArray arrayWithObjects:@"", nil];
                images = [NSArray arrayWithObjects:@"", nil];
                href = [NSArray arrayWithObjects:@"", nil];
                params = [NSArray arrayWithObjects:@"", nil];
            }
            
            self.cursor_getCount = [label count];
            self.totalrows = self.cursor_getCount;
        }
        else
        {
            j = self.cursor_getCount;
            
            self.cursor_getCount += [label count];
            self.totalrows = self.cursor_getCount;
        }
        
        /**
         * [temp]: required to do multiple inserts at once
         * sqLite transaction
         */
        
        int size = [label count];
        for(int i=0; i < size; i++)
        {
            j++;

            NSString *tmpLbl;
            if([[label objectAtIndex:i] containsString:@"'"])
            {
                tmpLbl = [imlb escapeStr:[label objectAtIndex:i]];
            }
            else
            {
                tmpLbl = [label objectAtIndex:i];
            }

            NSString *tmpParam;
            if([[params objectAtIndex:i] containsString:@"'"])
            {
                tmpParam = [imlb escapeStr:[params objectAtIndex:i]];
            }
            else
            {
                tmpParam = [params objectAtIndex:i];
            }

            [[sqLiteHelper singleton] query:[NSString stringWithFormat:@"INSERT INTO cur_ada( _id, mode, label, desc, image, href, param) VALUES ( %i, '%@', '%@', '%@', '%@', '%@', '%@') ", j, mode, [tmpLbl stringByReplacingOccurrencesOfString:@"'" withString:@"''" ] , [[desc objectAtIndex:i] stringByReplacingOccurrencesOfString:@"'" withString:@"''" ], [images objectAtIndex:i], [href objectAtIndex:i], tmpParam ] withParam:nil];
            
        }
    }
}

- (void)didReceiveMemoryWarning
{
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if(!self.is_local_cursor)
    {
        return self.totalrows;
    }
    else
    {
        NSDictionary *row  = [[sqLiteHelper singleton] checkIfRowExist:[NSString stringWithFormat:@" SELECT COUNT(*) as 'Cnt' FROM cur_ada WHERE mode='%@' ", self.rowType]  withParam:nil ];
        if( row )
        {
            return [imlb strToIntSecure:[NSString stringWithFormat:@"%@",[row valueForKey:@"Cnt"]]];
        }
        else
        {
            return 0;
        }
    }
    
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//     return 0;
//}

-(NSDictionary *) getRow:(NSIndexPath *) indexPath
{
    return [self getRowAtNo:indexPath.row];
}

-(void) getRowProcessing
{
    
}

-(NSDictionary *) getRowAtNo:(NSInteger) rowNo
{
    NSDictionary *row  = [[sqLiteHelper singleton] checkIfRowExist:[NSString stringWithFormat:@" SELECT * FROM cur_ada WHERE _id=%ld AND mode='%@' ", (rowNo+1), self.rowType]  withParam:nil ];
    return row;
}

-(void) updateRowAtNo:(NSInteger) rowNo field_name:(NSString*)field_name value:(NSString*)value
{
    [[sqLiteHelper singleton] query:[NSString stringWithFormat:@"UPDATE cur_ada SET %@='%@' WHERE _id=%ld AND mode='%@' ", field_name, value, (rowNo+1), self.rowType] withParam:nil];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if(self.maxPages - 1 > self.currentPage)
    {
        if(
           self.is_more_records
           //&& !self.is_loadMoreItems_in_progress
           && ( section + 1 ) == self.cursor_getCount
           )
        {
            return nil;
        }
    }
    
    NSString *label = @"";
    NSString *desc = @"";
    NSString *image = @"";
    NSString *href = @"";
    NSString *param = @"";
    
    NSDictionary *row;
    
    
    if( ![self.rowType isEqualToString:@"notifications"] )
    {
        row = [self getRowAtNo:section];
        
        
        if( row )
        {
            label = [row valueForKey:@"label"];
            desc = [row valueForKey:@"desc"];
            image = [row valueForKey:@"image"];
            href = [row valueForKey:@"href"];
            param = [row valueForKey:@"param"];
        }
        else
        {
            NSLog(@" inside row 1 ");
        }
    }
    
    
    if( [self.rowType isEqualToString:@"is_no_records"] )
    {
        return nil;
    }

    return nil;
}


-(void) cellForRowAtIndexPathPreProcessing:(UITableView *)tableView :(NSIndexPath *)indexPath :(NSString *)label :(NSString *)desc :(NSString *)image :(NSString *)href :(NSString *)param
{
    int rowAtNo = 0;
    if( [self.rowType containsString:@"item_list_global"] )
    {
        rowAtNo = indexPath.section;
    }
    else
    {
        rowAtNo = indexPath.row;
    }
    
    static NSString *moreCellId = @"moreCell";
    if(self.maxPages - 1 > self.currentPage)
    {
        if( self.is_more_records && !self.is_loadMoreItems_in_progress && ( rowAtNo + 1 ) == self.cursor_getCount )
        {
            self.is_loadMoreItems_in_progress = true;
            /**
             * initiate call to REST server for getting more items, while it is available
             */
//            [self loadMoreItems:self.he_ControllerObj];
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:moreCellId];
            if (true || cell == nil)
            {
                
                cell = [[UITableViewCell alloc]
                        initWithStyle:UITableViewCellStyleDefault
                        reuseIdentifier:moreCellId];
                
                UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                
                [spinner setCenter:CGPointMake( ([imlb screenWidth] - 2) / 2,20)];
                spinner.color = [imlb colorFromHexString:themeColor];
                [cell.contentView addSubview:spinner];
                [spinner startAnimating];
                
            }
            
        }
    }
    
    NSDictionary *row;
    
    if( ![self.rowType isEqualToString:@"notifications"] )
    {
        //if section as row
        row = [self getRowAtNo:rowAtNo];
        
        if( row )
        {
            label = [row valueForKey:@"label"];
            desc = [row valueForKey:@"desc"];
            image = [row valueForKey:@"image"];
            href = [row valueForKey:@"href"];
            param = [row valueForKey:@"param"];
            
        }
        else
        {
            //
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *label = @"";
    NSString *desc = @"";
    NSString *image = @"";
    NSString *href = @"";
    NSString *param = @"";
    
    [self cellForRowAtIndexPathPreProcessing:(UITableView *)tableView :(NSIndexPath *)indexPath :(NSString *)label :(NSString *)desc :(NSString *)image :(NSString *)href :(NSString *)param];
    
    if( [self.rowType isEqualToString:@"is_no_records"] )
    {
        return nil;
    }
    else if( [self.rowType containsString:@"my_row"] )
    {
        //prepare your row cell here
        
        return nil;    //return your cell
    }
    
    return nil;
}

@end
