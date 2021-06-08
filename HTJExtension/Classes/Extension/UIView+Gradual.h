//
//  UIView+Gradual.h
//  InfrastructureProjects
//
//  Created by shiwei on 2020/6/9.
//  Copyright © 2020 shiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, UIViewGradientDirect) {
    UIViewGradientDirectHorizontal = 0, // 水平方向
    UIViewGradientDirectVertical        // 垂直方向
};

@interface UIView (Gradual)

/// 渐变方向
@property (nonatomic, assign) UIViewGradientDirect gradientDirect;

/// 渐变背景色
@property (nonatomic, strong) NSArray <UIColor *> *gradientBackgroundColors;

@end

NS_ASSUME_NONNULL_END
