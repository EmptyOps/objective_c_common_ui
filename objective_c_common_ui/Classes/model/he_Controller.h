//
//  he_Controller.h
//  XClient
//
//  Created by Hitesh Khunt on 05/06/15.
//  Copyright (c) 2015 XClient. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface he_Controller : UIViewController

//singltone
+(he_Controller *) singleton;

/**
 *  current page view href
 */
@property (nonatomic,strong) NSString *viewHref;

/**
 *  current page URI parameters
 */
@property (nonatomic,strong) NSString *hrefParams;

/**
 *  segue being sending to page view href
 */
@property (nonatomic,strong) NSString *toViewHref;

/**
 *  segue being sending to page URI parameters
 */
@property (nonatomic,strong) NSString *toHrefParams;

//
@property (nonatomic,strong) UITextField *txtSearch1;

@property (strong, nonatomic) IBOutlet UITextField *txtSearch;

/**************************************** timer and threading variables *******************************************/

/**
 *  segue being sending to page view href
 */
@property (nonatomic,strong) NSTimer *timerObj;

@property (strong, nonatomic) IBOutlet UIImageView *bannerView;

/**************************************** timer and threading variables end *******************************************/

@end
