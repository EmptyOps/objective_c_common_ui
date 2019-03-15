//
//  listViewAdapter.h
//  XClient
//
//  Created by Hitesh Khunt on 20/06/15.
//  Copyright (c) 2015 XClient. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "he_Controller.h"

@interface listViewAdapter : NSObject
@property (nonatomic,strong) he_Controller *he_ControllerObj;

@property (nonatomic,strong) NSString *rowType;
@property BOOL isLongClick;
@property (nonatomic,strong) NSArray *label;
@property (nonatomic,strong) NSArray *desc;
@property (nonatomic,strong) NSArray *images;
@property (nonatomic,strong) NSArray *href;
@property (nonatomic,strong) NSArray *params;

@property (strong, nonatomic) UILabel *infoLabel;
@property (strong, nonatomic) NSArray *options;

@property (retain, nonatomic) NSDictionary *collectionViewsDict;


@property (nonatomic,strong) NSString *cat_id;

-(void) initializeSimple:(he_Controller*) he_ControllerObj withMode:(NSString*) mode withList:(NSArray*) list withDesc:(NSArray*) desc withImages:(NSArray*) images withHref:(NSArray*) href withParams:(NSArray*) params withLongClick:(BOOL) isLongClick;

- (void)didReceiveMemoryWarning;

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;

@end
