//
//  form_Controller.m
//  datsy
//
//  Created by Hitesh Khunt on 4/28/17.
//  Copyright © 2017 Hitesh Khunt. All rights reserved.
//

#import "form_Controller.h"

@interface form_Controller ()

@end

@implementation form_Controller

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    // hide keyboard
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                          action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
}

-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}

@end
