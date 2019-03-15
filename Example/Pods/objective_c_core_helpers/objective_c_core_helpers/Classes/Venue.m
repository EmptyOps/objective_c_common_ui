//
//  Venue.m
//  XClient
//
//  Created by Hitesh Khunt on 13/06/15.
//  Copyright (c) 2015 XClient. All rights reserved.
//

#import "Venue.h"
#import "ObjectMapping.h"
#import "RKObjectMapping.h"

@implementation Venue

+ (RKObjectMapping *)mapping
{
    RKObjectMapping *requestMapping = [RKObjectMapping mappingForClass:[self class]];
    [requestMapping addAttributeMappingsFromDictionary:@{
                                                         @"name":     @"name"
                                                         }];
    
    return requestMapping;
}

- (NSDictionary*)elementToPropertyMappings
{
    return [NSDictionary dictionaryWithObjectsAndKeys:
            @"identifier", @"identifier",
            @"name", @"name",
            @"company", @"company",
            nil];
}

+ (RKObjectMapping *)response
{
    RKObjectMapping *requestMapping = [RKObjectMapping mappingForClass:[self class]];
    [requestMapping addAttributeMappingsFromDictionary:@{
                                                         @"response":     @"response"
                                                         }];
    
    return requestMapping;
}

@end
