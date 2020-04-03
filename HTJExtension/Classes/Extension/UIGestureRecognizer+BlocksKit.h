//
//  UIGestureRecognizer+BlocksKit.h
//  shiwei
//
//  Created by shiwei on 2017/9/29.
//  Copyright © 2015年 com.shiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIGestureRecognizer (BlocksKit)


+ (id)sw_recognizerWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block delay:(NSTimeInterval)delay;

- (id)sw_initWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block delay:(NSTimeInterval)delay NS_REPLACES_RECEIVER;


+ (id)sw_recognizerWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block;


- (id)sw_initWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block NS_REPLACES_RECEIVER;

@property (nonatomic, copy, setter = sw_setHandler:) void (^sw_handler)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location);

@property (nonatomic, setter = sw_setHandlerDelay:) NSTimeInterval sw_handlerDelay;

- (void)sw_cancel;

@end
