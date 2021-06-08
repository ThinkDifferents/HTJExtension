//
//  UIButton+Gradual.h
//  dolphinHouse
//
//  Created by shiwei on 2020/6/4.
//  Copyright © 2020 HTJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, UIButtonGradientDirect) {
    UIButtonGradientDirectHorizontal = 0, // 水平方向
    UIButtonGradientDirectVertical        // 垂直方向
};

@interface UIButton (Gradual)

/// 渐变方向
@property (nonatomic, assign) UIButtonGradientDirect gradientDirect;

/// 渐变背景色
@property (nonatomic, strong) NSArray <UIColor *> *gradientBackgroundColors;

/// 根据状态设置渐变背景
/// @param colors colors
/// @param state 状态
- (void)setBackgroundGradualColor:(NSArray <UIColor *> *)colors forState:(UIControlState)state;

@end

NS_ASSUME_NONNULL_END
