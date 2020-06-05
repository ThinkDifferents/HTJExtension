//
//  UIGestureRecognizer+BlocksKit.h
//  shiwei
//
//  Created by shiwei on 2017/9/29.
//  Copyright © 2015年 com.shiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIGestureRecognizer (BlocksKit)

+ (id)sw_recognizerWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block;
- (id)sw_initWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block NS_REPLACES_RECEIVER;

- (void)sw_cancel;

@end
