//
//  UIGestureRecognizer+BlocksKit.m
//  shiwei
//
//  Created by shiwei on 2017/9/29.
//  Copyright © 2015年 com.shiwei. All rights reserved.
//

#import <objc/runtime.h>
#import "UIGestureRecognizer+BlocksKit.h"

static const void *SWGestureRecognizerBlockKey = &SWGestureRecognizerBlockKey;
static const void *SWGestureRecognizerShouldHandleActionKey = &SWGestureRecognizerShouldHandleActionKey;

@interface UIGestureRecognizer (BlocksKitIvar)

@property (nonatomic, copy, setter = sw_setHandler:) void (^sw_handler)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location);
@property (nonatomic, setter = sw_setShouldHandleAction:) BOOL sw_shouldHandleAction;

- (void)sw_handleAction:(UIGestureRecognizer *)recognizer;

@end

@implementation UIGestureRecognizer (BlocksKit)

+ (id)sw_recognizerWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block
{
    return [[[self class] alloc] sw_initWithHandler:block];
}

- (id)sw_initWithHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))block
{
    self = [self initWithTarget:self action:@selector(sw_handleAction:)];
    if (!self) return nil;
    
    self.sw_handler = block;
    
    return self;
}

- (void)sw_handleAction:(UIGestureRecognizer *)recognizer
{
    void (^handler)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location) = recognizer.sw_handler;
    if (!handler) return;
    
    CGPoint location = [self locationInView:self.view];
    void (^block)(void) = ^{
        if (!self.sw_shouldHandleAction) return;
        handler(self, self.state, location);
    };
    
    self.sw_shouldHandleAction = YES;
    
    block();
}

- (void)sw_setHandler:(void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))handler
{
    objc_setAssociatedObject(self, SWGestureRecognizerBlockKey, handler, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (void (^)(UIGestureRecognizer *sender, UIGestureRecognizerState state, CGPoint location))sw_handler
{
    return objc_getAssociatedObject(self, SWGestureRecognizerBlockKey);
}

- (void)sw_setShouldHandleAction:(BOOL)flag
{
    objc_setAssociatedObject(self, SWGestureRecognizerShouldHandleActionKey, @(flag), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)sw_shouldHandleAction
{
    return [objc_getAssociatedObject(self, SWGestureRecognizerShouldHandleActionKey) boolValue];
}

- (void)sw_cancel
{
    self.sw_shouldHandleAction = NO;
}

@end

