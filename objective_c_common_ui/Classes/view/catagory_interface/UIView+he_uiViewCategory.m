//
//  UIView+objectTagAdditions.m
//  XClient
//
//  Created by Hitesh Khunt on 23/06/15.
//  Copyright (c) 2015 XClient. All rights reserved.
//

#import "UIView+he_uiViewCategory.h"
#import <objc/runtime.h>

static char const * const ObjectTagKey = "ObjectTag";
static char const * const hrefKey = "href";
static char const * const paramKey = "param";

@implementation UIView (he_uiViewCategory)

@dynamic objectTag;

- (id)objectTag
{
    return objc_getAssociatedObject(self, ObjectTagKey);
}

- (void)setObjectTag:(id)newObjectTag
{
    objc_setAssociatedObject(self, ObjectTagKey, newObjectTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)href
{
    return objc_getAssociatedObject(self, hrefKey);
}

- (void)setHref:(id)newHref
{
    objc_setAssociatedObject(self, hrefKey, newHref, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)param
{
    return objc_getAssociatedObject(self, paramKey);
}

- (void)setParam:(id)param
{
    objc_setAssociatedObject(self, paramKey, param, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)viewWithObjectTag:(id)object
{
    // Raise an exception if object is nil
    if (object == nil)
    {
        [NSException raise:NSInternalInconsistencyException format:@"Argument to -viewWithObjectTag: must not be nil"];
    }
    
    // Recursively search the view hierarchy for the specified objectTag
    if ([self.objectTag isEqual:object])
    {
        return self;
    }
    
    for (UIView *subview in self.subviews)
    {
        UIView *resultView = [subview viewWithObjectTag:object];
        if (resultView != nil)
        {
            return resultView;
        }
    }
    return nil;
}

- (NSMutableArray*)allSubViews
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    [arr addObject:self];
    for (UIView *subview in self.subviews)
    {
        [arr addObjectsFromArray:(NSArray*)[subview allSubViews]];
    }
    return arr;
}

@end
