//
//  UIView+BlocksKit.h
//  shiwei
//
//  Created by shiwei on 2017/9/29.
//  Copyright © 2015年 shiwei. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIView (BlocksKit)


- (void)sw_whenTouches:(NSUInteger)numberOfTouches tapped:(NSUInteger)numberOfTaps handler:(void (^)(void))block;

- (void)sw_whenTapped:(void (^)(void))block;
- (void)sw_whenTappedView:(void (^)(UIView *view))block;
- (void)sw_whenDoubleTapped:(void (^)(void))block;
- (void)sw_eachSubview:(void (^)(UIView *subview))block;
- (void)sw_whenLongTapped:(void (^)(void))block;

@end

