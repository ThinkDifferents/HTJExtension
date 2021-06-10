//
//  HUD.m
//  InfrastructureProjects
//
//  Created by shiwei on 2020/4/23.
//  Copyright © 2020 shiwei. All rights reserved.
//

#import "HUD.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface HUD ()

@property (nonatomic, assign) CGFloat tipDuration;
@property (nonatomic, assign) CGFloat loadingDuration;
@property (nonatomic, weak) UIView *view;

@end

@implementation HUD

static MBProgressHUD *_hud;

+ (instancetype)instance {
    return [[HUD alloc] _init];
}

- (instancetype)_init
{
    self = [super init];
    if (self) {
        self.tipDuration = 1.5;
        self.loadingDuration = 0;
        self.view = [HUD windowView];
    }
    return self;
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

- (HUDToFloat)TipDuration {
    
    return ^(CGFloat duration) {
        
        self.tipDuration = duration;
        return self;
    };
}

- (HUDToFloat)LoadingDuration {
    
    return ^(CGFloat duration) {
        
        self.loadingDuration = duration;
        return self;
    };
}

- (HUDToView)ToView {
    
    return ^(UIView *view) {
        
        self.view = view;
        return self;
    };
}

- (HUDToString)ShowSuccess {
    
    return ^(NSString *success) {
        
        [self show:success icon:@"HUD_success" toView:self.view afterDelay:self.tipDuration];
        return self;
    };
}

- (HUDToString)ShowError {
    
    return ^(NSString *error) {
        
        [self show:error icon:@"HUD_error" toView:self.view afterDelay:self.tipDuration];
        return self;
    };
}

- (HUDToString)ShowText {
    
    return ^(NSString *text) {
        
        [self show:text icon:nil toView:self.view afterDelay:self.tipDuration];
        return self;
    };
}

- (void)show:(NSString *)text icon:(NSString *)icon toView:(UIView *)view afterDelay:(CGFloat)duration {
    
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
            UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]];
            img = img == nil ? [UIImage imageNamed:icon] : img;
            hud.customView = [[UIImageView alloc] initWithImage:img];
            // 再设置模式
            hud.mode = MBProgressHUDModeCustomView;
        }
        // 隐藏时候从父控件中移除
        hud.removeFromSuperViewOnHide = YES;
        hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
        hud.bezelView.backgroundColor = UIColor.blackColor;
        hud.contentColor = UIColor.whiteColor;
        // 指定时间之后再消失
        [hud hideAnimated:true afterDelay:duration];
    });
}


- (HUDToVoid)ShowLoading {
    
    return ^() {
        
        [self showNormalLoadingWithText:@""];
        return self;
    };
}

- (HUDToString)ShowTextLoading {
    
    return ^(NSString *text) {
        
        [self showNormalLoadingWithText:text];
        return self;
    };
}

- (void)showNormalLoadingWithText:(NSString *)text {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.label.text = text;
    // 再设置模式
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = UIColor.blackColor;
    hud.contentColor = UIColor.whiteColor;
    
    if (self.loadingDuration) {
        [hud hideAnimated:true afterDelay:self.loadingDuration];
    } else {
        if (_hud) {
            [_hud hideAnimated:true];
        }
        _hud = hud;
    }
}

- (HUDToVoid)ShowCustomLoading {
    
    return ^() {
        
        [self showHTJLoading];
        return self;
    };
}

- (void)showHTJLoading {
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = UIColor.blackColor;
    hud.contentColor = UIColor.whiteColor;
    hud.square = YES;
    hud.bezelView.color = [UIColor clearColor];
    hud.mode = MBProgressHUDModeCustomView;
    
    UIImage *image = [UIImage imageNamed:@"frame_00"];
    UIImageView *animateGifView = [[UIImageView alloc]initWithImage:image];
    
    NSMutableArray *gifArray = [NSMutableArray array];
    for (int i = 0; i <= 46; i ++) {
        UIImage *images = [UIImage imageNamed:[NSString stringWithFormat:@"frame_%02d",i]];
        if (images) {
            UIImage *temp = [HUD scaleToSize:images size:CGSizeMake(50, 50)];
            [gifArray addObject:temp];
        }
    }
    
    [animateGifView setAnimationImages:gifArray];
    [animateGifView setAnimationDuration:2.5];
    [animateGifView setAnimationRepeatCount:0];
    [animateGifView startAnimating];
    hud.customView = animateGifView;
    
    if (self.loadingDuration) {
        [hud hideAnimated:true afterDelay:self.loadingDuration];
    } else {
        if (_hud) {
            [_hud hideAnimated:true];
        }
        _hud = hud;
    }
}

+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)newsize{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    //原图片尺寸是150*150 当裁剪时会被压缩 所以改成3倍（50*50） 不然图片会不清晰
    UIGraphicsBeginImageContextWithOptions(newsize, NO, 3.0);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

+ (void)hide {
    [_hud hideAnimated:true];
}

@end
