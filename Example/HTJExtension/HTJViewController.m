//
//  HTJViewController.m
//  HTJExtension
//
//  Created by ThinkDifferents on 01/04/2020.
//  Copyright (c) 2020 ThinkDifferents. All rights reserved.
//

#import "HTJViewController.h"
#import <Header.h>

@interface HTJViewController ()

@end

@implementation HTJViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view sw_whenTapped:^{
        NSLog(@"单机");
        
        [MBProgressHUD showSuccess:@"success"];
    }];
    [self.view sw_whenDoubleTapped:^{
        
        NSLog(@"双机");
    }];
    
    
}

NSString * kStrFormat(NSString *format, ...) {
//    return str(format, ...);
    return [NSString stringWithFormat:@""];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
