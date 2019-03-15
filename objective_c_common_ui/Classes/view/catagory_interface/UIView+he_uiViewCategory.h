//
//  UIView+objectTagAdditions.h
//  XClient
//
//  Created by Hitesh Khunt on 23/06/15.
//  Copyright (c) 2015 XClient. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (he_uiViewCategory)

@property (nonatomic, retain) id objectTag;

@property (nonatomic, retain) id href;
@property (nonatomic, retain) id param;

- (UIView *)viewWithObjectTag:(id)object;

- (NSMutableArray*) allSubViews;

@end