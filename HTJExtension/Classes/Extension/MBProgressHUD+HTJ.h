//
//  MBProgressHUD+HTJ.h
//  dolphinHouse
//
//  Created by shiwei on 2019/9/19.
//  Copyright © 2019 HTJ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (HTJ)

/// 展示成功信息
+ (void)showSuccess:(NSString *)success;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;

/// 展示错误信息
+ (void)showError:(NSString *)error;
+ (void)showError:(NSString *)error toView:(UIView *)view;

/// 展示普通loading
+ (MBProgressHUD *)showNormalLoading:(NSString*)message;
+ (MBProgressHUD *)showNormalLoading:(NSString*)message toView:(UIView *)view;

/// 隐藏
+ (void)hideHUD;
+ (void)hideHUDForView:(UIView *)view;

/// 展示纯文字
+ (void)showString:(NSString *)string;
+ (void)showString:(NSString *)message toView:(UIView *)view;

+ (UIView *)windowView;


@end
