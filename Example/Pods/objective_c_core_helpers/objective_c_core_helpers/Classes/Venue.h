//
//  Venue.h
//  XClient
//
//  Created by Hitesh Khunt on 13/06/15.
//  Copyright (c) 2015 XClient. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface Venue : NSObject

@property (nonatomic, strong) NSString *name;


+ (RKObjectMapping *)mapping;

+ (RKObjectMapping *)response;

- (NSDictionary*)elementToPropertyMappings;

@end

