//
//  he_Controller.m
//  XClient
//
//  Created by Hitesh Khunt on 05/06/15.
//  Copyright (c) 2015 XClient. All rights reserved.
//

#import "he_Controller.h"
#import "imlb.h"
#import "session.h"
#import "logWrapper.h"

@interface he_Controller ()

@end

@implementation he_Controller

static he_Controller *he_ControllerSingleton;

+(he_Controller *) singleton
{
    return he_ControllerSingleton;
}

-(void) initCustom
{
    /**
     *  singleton init here added on 27-07-2015
     */
    he_ControllerSingleton = self;
    
}

- (void)viewDidLoad
{
    [self initCustom];
    
    //temporarily unwanted features commented
    
    [super viewDidLoad];
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [self initCustom];
}

-(void)viewDidDisappear:(BOOL)animated
{
    if( self.timerObj != nil )
    {
        [self.timerObj invalidate];
        self.timerObj = nil;
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [logWrapper debug:[NSString stringWithFormat:@"prepare for segue called..."]];
    
    
    /**
     *  set viewHref and hrefParams to the called controller
     * Only set the value if not set to prevent error when prepareForSegue called two times.
     */
    if( [segue.destinationViewController isKindOfClass:[he_Controller class]] &&
       [imlb isStrEmptyStrict: ((he_Controller *)segue.destinationViewController).viewHref] )
    {
        [self prepareForSegueCore:(he_Controller *)segue.destinationViewController sender:sender];
    }
    
    [logWrapper debug:[NSString stringWithFormat:@"prepare for segue done..."]];
}

- (void)prepareForSegueCore:(he_Controller *)he_ControllerObj sender:(id)sender
{
    [logWrapper debug:[NSString stringWithFormat:@"prepareForSegueCore for segue called..."]];
    
    
    /**
     *  set viewHref and hrefParams to the called controller
     * Only set the value if not set to prevent error when prepareForSegue called two times.
     */
    
    [he_ControllerObj setViewHref:self.toViewHref];
    [he_ControllerObj setHrefParams:self.toHrefParams];
    
    [logWrapper debug:[NSString stringWithFormat:@"prepareForSegueCore for segue done..."]];
}

-(void) handleBannerTimer:(id) sender
{
    //save top_banner in session
    NSDictionary *top_banner = [[session singleton] getJSONSession:@"top_banner_"];
    
    
    //fetch index from session, to show banner at index
    NSString *top_banner_indexKey = [NSString stringWithFormat:@"top_banner_index_%@", [top_banner objectForKey:@"__fmID"]];
    NSString *top_bannerKey = [NSString stringWithFormat:@"top_banner_" ];  //[top_banner objectForKey:@"__fmID"]
    int top_banner_index = [imlb strToIntSecure:[[session singleton] userdata:top_banner_indexKey]];
    top_banner_index++;
    
    
    NSArray *image = [top_banner objectForKey:@"image"];
    NSArray *href = [top_banner objectForKey:@"href"];
    NSArray *param = [top_banner objectForKey:@"param"];
    if( [image count] <= top_banner_index )
    {
        //reset index if limit reached
        top_banner_index = 0;
    }
    
    
    if( [image count] > top_banner_index )
    {
        UIScrollView *banner2 = nil;

        if( banner2 == nil )
        {
            return;
        }
        
        // Populate the carousel with items
        CGFloat screenWidth = [imlb screenWidth];
        self.bannerView = nil;
        self.bannerView = [[UIImageView alloc] initWithFrame:CGRectMake( 0 , 0, screenWidth , CGRectGetHeight(banner2.frame))];
        [imlb loadImage:[image objectAtIndex:top_banner_index] onImageView:self.bannerView];
        
        [banner2 addSubview:self.bannerView];
    }
    
    //increase banner_index in session
    [[session singleton] set_userdata: top_banner_indexKey  withValue:[NSString stringWithFormat:@"%d", top_banner_index]];
    
}

@end
