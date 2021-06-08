//
//  UIButton+Gradual.m
//  dolphinHouse
//
//  Created by shiwei on 2020/6/4.
//  Copyright © 2020 HTJ. All rights reserved.
//

#import "UIButton+Gradual.h"
#import <objc/message.h>

@interface UIButton ()

@property (nonatomic, strong) CAGradientLayer *gradLayer;

@end

@implementation UIButton (Gradual)

static char *colorsArrayKey;
static char *backgroundColorsArrayKey;
static char *buttonGradientLayerKey;
static char *gradientDirectKey;

+ (void)load
{
    Method oldMethod = class_getInstanceMethod([self class], @selector(layoutSubviews));
    Method newMethod = class_getInstanceMethod([self class], @selector(_layoutSubviews));
    method_exchangeImplementations(oldMethod, newMethod);
}

- (NSMutableDictionary *)colorsDictionary {
    return objc_getAssociatedObject(self, &colorsArrayKey);
}

- (CAGradientLayer *)gradLayer {
    return (CAGradientLayer *)objc_getAssociatedObject(self, &buttonGradientLayerKey);
}

- (UIButtonGradientDirect)gradientDirect {
    
    return [objc_getAssociatedObject(self, &gradientDirectKey) integerValue];
}

- (void)setGradientBackgroundColors:(NSArray<UIColor *> *)gradientBackgroundColors {
    objc_setAssociatedObject(self, &backgroundColorsArrayKey, gradientBackgroundColors, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray<UIColor *> *)gradientBackgroundColors {
    return objc_getAssociatedObject(self, &backgroundColorsArrayKey);
}

- (void)setGradientDirect:(UIButtonGradientDirect)gradientDirect {
    objc_setAssociatedObject(self, &gradientDirectKey, @(gradientDirect), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)_layoutSubviews {
    [self _layoutSubviews];
    
    if (self.gradientBackgroundColors && self.gradientBackgroundColors.count) {
        NSMutableArray *results = [NSMutableArray arrayWithCapacity:self.gradientBackgroundColors.count];
        for (UIColor *color in self.gradientBackgroundColors) {
            [results addObject:(__bridge id)color.CGColor];
        }
        if (!self.gradLayer) {
            
            self.gradLayer = [CAGradientLayer layer];
            self.gradLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
            self.gradLayer.colors = results;
            self.gradLayer.startPoint = CGPointMake(0, 0);
            if (self.gradientDirect == UIButtonGradientDirectVertical) {
                self.gradLayer.endPoint = CGPointMake(0, 1.0);
            } else {
                self.gradLayer.endPoint = CGPointMake(1.0, 0);
            }
            self.gradLayer.locations = @[@0, @1];
            
            [self.layer insertSublayer:self.gradLayer atIndex:0];
        } else {
            self.gradLayer.colors = results;
        }
    }
    
    if (!self.colorsDictionary) {
        return;
    }
    NSArray *colors = [self colorsDictionary][[self keyWithState:self.state]];
    if (!colors.count) {
        return;
    }
    
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:colors.count];
    for (UIColor *color in colors) {
        [results addObject:(__bridge id)color.CGColor];
    }
    
    if (!self.gradLayer) {
        
        self.gradLayer = [CAGradientLayer layer];
        self.gradLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        self.gradLayer.colors = results;
        self.gradLayer.startPoint = CGPointMake(0, 0);
        if (self.gradientDirect == UIButtonGradientDirectVertical) {
            self.gradLayer.endPoint = CGPointMake(0, 1.0);
        } else {
            self.gradLayer.endPoint = CGPointMake(1.0, 0);
        }
        self.gradLayer.locations = @[@0, @1];
        
        [self.layer insertSublayer:self.gradLayer atIndex:0];
    } else {
        self.gradLayer.colors = results;
    }
}

- (void)setGradLayer:(CAGradientLayer *)gradLayer {
    
    objc_setAssociatedObject(self, &buttonGradientLayerKey, gradLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

 - (void)setBackgroundGradualColor:(NSArray <UIColor *> *)colors forState:(UIControlState)state {
     [self saveToDicWith:[self keyWithState:state] colors:colors];
}

- (NSString *)keyWithState:(UIControlState)state {
    switch (state) {
        case UIControlStateNormal:
            {
                return @"nomal";
            }
            break;
        case UIControlStateHighlighted:
        {
            return @"highlight";
        }
            break;
        case UIControlStateSelected:
        {
            return @"selected";
        }
            break;
        case UIControlStateDisabled:
        {
            return @"disabled";
        }
            break;
        default:
            return @"";
            break;
    }
}

- (void)saveToDicWith:(NSString *)key colors:(NSArray *)colors {
    
    NSMutableDictionary *dic;
    if (![self colorsDictionary]) {
        dic = [NSMutableDictionary dictionaryWithCapacity:4];
    } else {
        dic = [NSMutableDictionary dictionaryWithDictionary:[self colorsDictionary]];
    }
    dic[key] = colors;
    objc_setAssociatedObject(self, &colorsArrayKey, dic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
