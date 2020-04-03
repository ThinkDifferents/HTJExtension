//
//  UIView+Extension.h
//  dolphinHouse
//
//  Created by lifuqing on 2018/8/31.
//  Copyright © 2018年 HTJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)

// 原有的
@property (nonatomic) CGFloat e_left;
@property (nonatomic) CGFloat e_top;
@property (nonatomic) CGFloat e_right;
@property (nonatomic) CGFloat e_bottom;
@property (nonatomic) CGFloat e_width;
@property (nonatomic) CGFloat e_height;
@property (nonatomic) CGFloat e_centerX;
@property (nonatomic) CGFloat e_centerY;
@property (nonatomic) CGPoint e_origin;
@property (nonatomic) CGSize  e_size;

- (void)removeAllSubviews;
- (BOOL)isDisplayedInScreen;

// 新加
@property (nonatomic, readonly) CGFloat e_maxY;         ///<< get CGRectGetMaxY
@property (nonatomic, readonly) CGFloat e_minY;         ///<< get CGRectGetMinY
@property (nonatomic, readonly) CGFloat e_maxX;         ///<< get CGRectGetMaxX
@property (nonatomic, readonly) CGFloat e_minX;         ///<< get CGRectGetMinX

@property (nonatomic, readonly) UIView *e_sibling;          /// 兄弟视图
@property (nonatomic, readonly) UIViewController *e_vc;     /// self Responder UIViewControler

@property (nonatomic, readonly) CGFloat e_safeAreaBottomGap;
@property (nonatomic, readonly) CGFloat e_safeAreaTopGap;
@property (nonatomic, readonly) CGFloat e_safeAreaLeftGap;
@property (nonatomic, readonly) CGFloat e_safeAreaRightGap;


- (UIView * (^)(CGFloat top))e__top;            ///< set frame y
- (UIView * (^)(CGFloat bottom))e__bottom;      ///< set frame y
- (UIView * (^)(CGFloat right))e_flexToBottom;  ///< set frame height
- (UIView * (^)(CGFloat left))e__left;          ///< set frame x
- (UIView * (^)(CGFloat right))e__right;        ///< set frame x
- (UIView * (^)(CGFloat right))e_flexToRight;   ///< set frame width
- (UIView * (^)(CGFloat width))e__width;        ///< set frame width
- (UIView * (^)(CGFloat height))e__height;      ///< set frame height
- (UIView * (^)(CGFloat x))e__centerX;          ///< set center
- (UIView * (^)(CGFloat y))e__centerY;          ///< set center

/// 相对父View
- (UIView * (^)(void))e_center;                 ///< 居中
- (UIView * (^)(void))e_fill;                   ///< 填充

/// 相对与兄弟节点，线性布局
- (UIView * (^)(CGFloat space))e_hstack;        ///< 水平，居中对齐
- (UIView * (^)(CGFloat space))e_vstack;        ///< 垂直，居中对齐

- (UIView * (^)(void))e_sizeToFit;              ///< sizeToFit
- (UIView * (^)(CGFloat w, CGFloat h))e_sizeToFitThan;  ///< sizeToFit, 最小值

@end
