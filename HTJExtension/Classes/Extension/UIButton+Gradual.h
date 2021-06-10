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

@interface UIButton (Extension)

/** 显示按钮菊花 */
- (void) showIndicator;

/** 隐藏按钮菊花 */
- (void) hideIndicator;

/** 将按钮布局改为上下结构 spacing : 间距 */
- (void)middleAlignButtonWithSpacing:(CGFloat)spacing;

/** 设置按钮额外热区 */
@property (nonatomic, assign) UIEdgeInsets touchAreaInsets;

/** 按钮点击后，禁用按钮并在按钮上显示 文字 和 加载动画 */
- (void)beginSubmitting:(NSString *)title;

/** 按钮点击后，恢复按钮点击前的状态 */
- (void)endSubmitting;

/** 按钮是否正在提交中 */
@property(nonatomic, readonly, getter=isSubmitting) NSNumber *submitting;

@end

NS_ASSUME_NONNULL_END
