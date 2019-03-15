//
//  he_UITapGestureRecognizer.h
//  XClient
//
//  Created by Hitesh Khunt on 23/06/15.
//  Copyright (c) 2015 XClient. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface he_UITapGestureRecognizer : UITapGestureRecognizer

/**
 *  view href of page to be called on click
 */
@property (nonatomic,strong) NSString *href;

/**
 *  URI parameters of page to be called on click
 */
@property (nonatomic,strong) NSString *hrefParams;

/**
 *  URI parameters of page to be called on click
 */
@property (nonatomic,strong) NSString *desc;

/**
 *  page from which is above page is called
 */
@property (nonatomic,strong) NSString *fromHref;

@end
