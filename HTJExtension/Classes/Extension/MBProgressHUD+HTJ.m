//
//  MBProgressHUD+HTJ.m
//  dolphinHouse
//
//  Created by shiwei on 2019/9/19.
//  Copyright © 2019 HTJ. All rights reserved.
//

#import "MBProgressHUD+HTJ.h"
#import "HTCommunityConstantClass.h"

@implementation MBProgressHUD (HTJ)

static MBProgressHUD * _hud;

/**
 *  显示信息
 *
 *  @param text 信息内容
 *  @param icon 图标
 *  @param view 显示的视图
 */
 + (void)show:(NSString *)text icon:(NSString *)icon toView:(UIView *)view{
     
     if (view == nil) view = [MBProgressHUD windowView];
     
     dispatch_async(dispatch_get_main_queue(), ^{
         
         // 快速显示一个提示信息
         MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
         hud.label.text = text;
         // 判断是否显示图片
         if (icon == nil) {
             hud.mode = MBProgressHUDModeText;
             hud.label.numberOfLines = 0;
         }else{
             // 设置图片
             NSBundle *current = [NSBundle bundleForClass:[HTCommunityConstantClass class]];
             UIImage *img = [UIImage imageNamed:icon inBundle:current compatibleWithTraitCollection:nil];
             img = img == nil ? [UIImage imageNamed:icon] : img;
             hud.customView = [[UIImageView alloc] initWithImage:img];
             // 再设置模式
             hud.mode = MBProgressHUDModeCustomView;
         }
         // 隐藏时候从父控件中移除
         hud.removeFromSuperViewOnHide = YES;
         hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
         hud.bezelView.backgroundColor = rgba(0, 0, 0, 1);
         hud.contentColor = UIColor.whiteColor;
         // 指定时间之后再消失
         [hud hideAnimated:true afterDelay:1.2];
     });
 }

/**
 *  显示成功信息
 *
 *  @param success 信息内容
 */
+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

/**
 *  显示成功信息
 *
 *  @param success 信息内容
 *  @param view    显示信息的视图
 */
+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"HUD_success" toView:view];
}

/**
 *  显示错误信息
 *
 */
+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

/**
 *  显示错误信息
 *
 *  @param error 错误信息内容
 *  @param view  需要显示信息的视图
 */
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"HUD_error" toView:view];
}

/**
 *  显示错误信息
 *
 *  @param message 信息内容
 *
 *  @return 直接返回一个MBProgressHUD，需要手动关闭
 */
+ (MBProgressHUD *)showNormalLoading:(NSString *)message
{
    return [MBProgressHUD showNormalLoading:message toView:nil];
}
+ (MBProgressHUD *)showNormalLoading:(NSString*)message toView:(UIView *)view{
    if (view == nil) view = [MBProgressHUD windowView];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.label.text = message;
    // 细节文字
    //    hud.detailsLabelText = @"请耐心等待";
    // 再设置模式
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = rgba(0, 0, 0, 1);
    hud.contentColor = UIColor.whiteColor;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:true afterDelay:5.0];
    if (_hud) {
        [_hud hideAnimated:true];
    }
    _hud = hud;
    return hud;
}

+ (void)hideLoading:(UIView *)baseHudView{
    [MBProgressHUD hideHUDForView:baseHudView];
}
                         
+ (UIView *)windowView {
    NSArray * arr = [UIApplication sharedApplication].windows;
    if (arr.count == 1) {
        return arr.lastObject;
    } else {
        UIWindow *win = arr.firstObject;
        for (UIWindow *window in arr) {
            if ([window isMemberOfClass:[UIWindow class]]) {
                win = window;
            }
        }
        return win;
    }
}

/**
 *  手动关闭MBProgressHUD
 */
+ (void)hideHUD
{
    [self hideHUDForView:nil];
}

/**
 *  手动关闭MBProgressHUD
 *
 *  @param view    显示MBProgressHUD的视图
 */
+ (void)hideHUDForView:(UIView *)view
{
    [_hud hideAnimated:true];
}

+ (void)showString:(NSString *)string {
    [MBProgressHUD showString:string toView:nil];
}
+ (void)showString:(NSString *)message toView:(UIView *)view {
    [self show:message icon:nil toView:view];
}

@end

