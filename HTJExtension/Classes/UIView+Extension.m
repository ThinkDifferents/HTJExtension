//
//  UIView+Extension.m
//  dolphinHouse
//
//  Created by lifuqing on 2018/8/31.
//  Copyright © 2018年 HTJ. All rights reserved.
//

#import "UIView+Extension.h"
#import <objc/runtime.h>

@implementation UIView (Extension)

static void *kUIViewLayoutMethodPropertyBottomGap   = &kUIViewLayoutMethodPropertyBottomGap;
static void *kUIViewLayoutMethodPropertyTopGap      = &kUIViewLayoutMethodPropertyTopGap;
static void *kUIViewLayoutMethodPropertyLeftGap     = &kUIViewLayoutMethodPropertyLeftGap;
static void *kUIViewLayoutMethodPropertyRightGap    = &kUIViewLayoutMethodPropertyRightGap;

- (CGFloat)e_left {
    return self.frame.origin.x;
}


- (void)setE_left:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}


- (CGFloat)e_top {
    return self.frame.origin.y;
}


- (void)setE_top:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}


- (CGFloat)e_right {
    return self.frame.origin.x + self.frame.size.width;
}


- (void)setE_right:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}


- (CGFloat)e_bottom {
    return self.frame.origin.y + self.frame.size.height;
}


- (void)setE_bottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}


- (CGFloat)e_centerX {
    return self.center.x;
}


- (void)setE_centerX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}


- (CGFloat)e_centerY {
    return self.center.y;
}


- (void)setE_centerY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


- (CGFloat)e_width {
    return self.bounds.size.width;
}


- (void)setE_width:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}


- (CGFloat)e_height {
    return self.bounds.size.height;
}


- (void)setE_height:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}


- (CGPoint)e_origin {
    return self.frame.origin;
}


- (void)setE_origin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}


- (CGSize)e_size {
    return self.frame.size;
}


- (void)setE_size:(CGSize)size {
    CGRect frame = self.bounds;
    frame.size = size;
    self.frame = frame;
}


- (void)removeAllSubviews {
    [[self.subviews copy] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        UIView* child = self.subviews.lastObject;
        [child removeFromSuperview];
    }];
}

// 判断View是否显示在屏幕上
- (BOOL)isDisplayedInScreen
{
    if (self == nil) {
        return FALSE;
    }
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    
    // 转换view对应window的Rect
    CGRect rect = [self convertRect:self.frame fromView:nil];
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect)) {
        return FALSE;
    }
    
    // 若view 隐藏
    if (self.hidden) {
        return FALSE;
    }
    
    // 若没有superview
    if (self.superview == nil) {
        return FALSE;
    }
    
    // 若size为CGrectZero
    if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
        return  FALSE;
    }
    
    // 获取 该view与window 交叉的 Rect
    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        return FALSE;
    }
    
    return TRUE;

}





- (CGFloat)e_maxY {
    return CGRectGetMaxY(self.frame);
}
- (CGFloat)e_minY {
    return CGRectGetMinY(self.frame);
}
- (CGFloat)e_maxX {
    return CGRectGetMaxX(self.frame);
}
- (CGFloat)e_minX {
    return CGRectGetMinX(self.frame);
}


- (UIView *)e_sibling {
    NSUInteger idx = [self.superview.subviews indexOfObject:self];
    if (idx == 0 || idx == NSNotFound)
        return nil;
    return self.superview.subviews[idx-1];
}

- (UIViewController *)e_vc {
    UIView *view = self;
    while (view) {
        UIResponder *nextResponder = [view nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
        view = view.superview;
      }
    return nil;
}


- (CGFloat)e_safeAreaBottomGap
{
    NSNumber *gap = objc_getAssociatedObject(self, kUIViewLayoutMethodPropertyBottomGap);
    if (gap == nil) {
        if (@available(iOS 11, *)) {
            if (self.superview.safeAreaLayoutGuide.layoutFrame.size.height > 0) {
                gap = @((self.superview.e_height - self.superview.safeAreaLayoutGuide.layoutFrame.origin.y - self.superview.safeAreaLayoutGuide.layoutFrame.size.height));
            } else {
                gap = nil;
            }
        } else {
            gap = @(0);
        }
        objc_setAssociatedObject(self, kUIViewLayoutMethodPropertyBottomGap, gap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return gap.floatValue;
}

- (CGFloat)e_safeAreaTopGap
{
    NSNumber *gap = objc_getAssociatedObject(self, kUIViewLayoutMethodPropertyTopGap);
    if (gap == nil) {
        if (@available(iOS 11, *)) {
            gap = @(self.superview.safeAreaLayoutGuide.layoutFrame.origin.y);
        } else {
            gap = @(0);
        }
        objc_setAssociatedObject(self, kUIViewLayoutMethodPropertyTopGap, gap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return gap.floatValue;
}

- (CGFloat)e_safeAreaLeftGap
{
    NSNumber *gap = objc_getAssociatedObject(self, kUIViewLayoutMethodPropertyLeftGap);
    if (gap == nil) {
        if (@available(iOS 11, *)) {
            gap = @(self.superview.safeAreaLayoutGuide.layoutFrame.origin.x);
        } else {
            gap = @(0);
        }
        objc_setAssociatedObject(self, kUIViewLayoutMethodPropertyLeftGap, gap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return gap.floatValue;
}

- (CGFloat)e_safeAreaRightGap
{
    NSNumber *gap = objc_getAssociatedObject(self, kUIViewLayoutMethodPropertyRightGap);
    if (gap == nil) {
        if (@available(iOS 11, *)) {
            gap = @((self.superview.e_width - self.superview.safeAreaLayoutGuide.layoutFrame.origin.x - self.superview.safeAreaLayoutGuide.layoutFrame.size.width));
        } else {
            gap = @(0);
        }
        objc_setAssociatedObject(self, kUIViewLayoutMethodPropertyRightGap, gap, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return gap.floatValue;
}


-(UIView *(^)(CGFloat))e__top {
    @weakify(self);
    return ^(CGFloat e_top){
        @strongify(self);
        self.e_top = e_top;
        return self;
    };
}

-(UIView *(^)(CGFloat))e__bottom {
    @weakify(self);
    return ^(CGFloat e_bottom){
        @strongify(self);
        self.e_bottom = e_bottom;
        return self;
    };
}
-(UIView *(^)(CGFloat))e_flexToBottom {
    @weakify(self);
    return ^(CGFloat e_flexToBottom){
        @strongify(self);
        self.e_height += self.e_bottom - e_flexToBottom;
        return self;
    };
}
-(UIView *(^)(CGFloat))e__left {
    @weakify(self);
    return ^(CGFloat e_left){
        @strongify(self);
        self.e_left = e_left;
        return self;
    };
}

-(UIView *(^)(CGFloat))e__right {
    @weakify(self);
    return ^(CGFloat e_right){
        @strongify(self);
        self.e_right = e_right;
        return self;
    };
}
-(UIView *(^)(CGFloat))e_flexToRight {
    @weakify(self);
    return ^(CGFloat e_flexToRight){
        @strongify(self);
        self.e_width += self.e_right - e_flexToRight;
        return self;
    };
}

-(UIView *(^)(CGFloat))e__width {
    @weakify(self);
    return ^(CGFloat e_width){
        @strongify(self);
        self.e_width = e_width;
        return self;
    };
}
-(UIView *(^)(CGFloat))e__height {
    @weakify(self);
    return ^(CGFloat e_height){
        @strongify(self);
        self.e_height = e_height;
        return self;
    };
}

- (UIView *(^)(CGFloat))e__centerX {
    @weakify(self);
    return ^(CGFloat x){
        @strongify(self);
        NSAssert(self.e_width, @"请先设置宽");
        self.e_centerX = x;
        return self;
    };
}

- (UIView *(^)(CGFloat))e__centerY {
    @weakify(self);
    return ^(CGFloat y){
        @strongify(self);
        NSAssert(self.e_height, @"请先设置高");
        self.e_centerY = y;
        return self;
    };
}


-(UIView *(^)(void))e_center {
    @weakify(self);
    return ^{
        @strongify(self);
        if (self.superview) {
            self.e_centerX = self.superview.e_width / 2;
            self.e_centerY = self.superview.e_height / 2;
        }
        return self;
    };
}

-(UIView *(^)(void))e_fill {
    @weakify(self);
    return ^{
        @strongify(self);
        if (self.superview) {
            self.e_left = self.e_top = 0;
            self.e_width = self.superview.e_width;
            self.e_height = self.superview.e_height;
        }
        return self;
    };
}

-(UIView *(^)(void))e_sizeToFit {
    @weakify(self);
    return ^{
        @strongify(self);
        [self sizeToFit];
        return self;
    };
}
-(UIView *(^)(CGFloat w, CGFloat h))e_sizeToFitThan {
    @weakify(self);
    return ^(CGFloat w, CGFloat h){
        @strongify(self);
        [self sizeToFit];
        if (self.e_width < w)
            self.e_width = w;
        if (self.e_height < h)
            self.e_height = h;
        return self;
    };
}

- (UIView * (^)(CGFloat space))e_hstack {
    @weakify(self);
    return ^(CGFloat space) {
        @strongify(self);
        if (self.e_sibling) {
            self.e__centerY(self.e_sibling.e_centerY).e__left(self.e_sibling.e_maxX+space);
        }
        return self;
    };
}

- (UIView * (^)(CGFloat space))e_vstack {
    @weakify(self);
    return ^(CGFloat space) {
        @strongify(self);
        if (self.e_sibling) {
            self.e__centerX(self.e_sibling.e_centerX).e__top(self.e_sibling.e_maxY+space);
        }
        return self;
    };
}

@end
