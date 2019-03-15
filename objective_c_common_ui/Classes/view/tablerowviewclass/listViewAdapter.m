//
//  listViewAdapter.m
//  XClient
//
//  Created by Hitesh Khunt on 20/06/15.
//  Copyright (c) 2015 XClient. All rights reserved.
//

#import "listViewAdapter.h"

@implementation listViewAdapter

@synthesize infoLabel = _infoLabel;
@synthesize options = _options;

-(void) initializeSimple:(he_Controller*) he_ControllerObj withMode:(NSString*) mode withList:(NSArray*) label withDesc:(NSArray*) desc withImages:(NSArray*) images withHref:(NSArray*) href withParams:(NSArray*) params withLongClick:(BOOL) isLongClick
{
    NSLog(@"rowType : %@",mode);
    self.he_ControllerObj = he_ControllerObj;
    
    self.rowType = mode;
    
    self.label = label;
    self.desc = desc;
    self.images = images;
    self.href = href;
    self.params = params;
    
    self.isLongClick = isLongClick;
    
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
    
    NSLog(@" _tender_list_Cell numberOfRowsInSection %lu " , (unsigned long)[self.label count] );
    
    return [self.label count];
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    return 0;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( [self.rowType isEqualToString:@"is_no_records"] )
    {
    
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
  
    [textField resignFirstResponder];
    return YES;
}

- (void)flashOff:(UIView *)v
{
    [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionAllowUserInteraction animations:^ {
        v.alpha = .01;  //don't animate alpha to 0, otherwise you won't be able to interact with it
    } completion:^(BOOL finished) {
        [self flashOn:v];
    }];
}

- (void)flashOn:(UIView *)v
{
    [UIView animateWithDuration:1 delay:1 options:UIViewAnimationOptionAllowUserInteraction animations:^ {
        v.alpha = 1;
    } completion:^(BOOL finished) {
        [self flashOff:v];
    }];
}

- (void)lbl_flashOff:(UIView *)v
{
    [UIView animateWithDuration:0.5 delay:1 options:UIViewAnimationOptionAllowUserInteraction animations:^ {
        v.alpha = .01;  //don't animate alpha to 0, otherwise you won't be able to interact with it
    } completion:^(BOOL finished) {
        [self lbl_flashOn:v];
    }];
}

- (void)lbl_flashOn:(UIView *)v
{
    [UIView animateWithDuration:0.5 delay:1 options:UIViewAnimationOptionAllowUserInteraction animations:^ {
        v.alpha = 1;
    } completion:^(BOOL finished) {
        [self lbl_flashOff:v];
    }];
}

- (void)blinkAnimation:(UIView *)target
{
    UIButton *random = (UIButton *)target;
    random.alpha = 0;
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [animation setFromValue:[NSNumber numberWithFloat:0.0]];
    [animation setToValue:[NSNumber numberWithFloat:1.0]];
    [animation setDuration:0.2f];
    [animation setRepeatCount:3];
    [animation setAutoreverses:YES];
    [animation setRemovedOnCompletion:NO];
    [random.layer addAnimation:animation forKey:@"animation"];
}

@end
