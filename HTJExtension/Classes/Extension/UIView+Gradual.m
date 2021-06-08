//
//  UIView+Gradual.m
//  InfrastructureProjects
//
//  Created by shiwei on 2020/6/9.
//  Copyright © 2020 shiwei. All rights reserved.
//

#import "UIView+Gradual.h"
#import <objc/runtime.h>

@interface UIView ()

@property (nonatomic, strong) CAGradientLayer *gradLayer;

@end

@implementation UIView (Gradual)

static char *colorsArrayKey;
static char *gradientDirectKey;
static char *gradientLayerKey;

- (void)setGradientDirect:(UIViewGradientDirect)gradientDirect {
    objc_setAssociatedObject(self, &gradientDirectKey, @(gradientDirect), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIViewGradientDirect)gradientDirect {
    return [objc_getAssociatedObject(self, &gradientDirectKey) integerValue];
}

- (void)setGradientBackgroundColors:(NSArray<UIColor *> *)gradientBackgroundColors {
    objc_setAssociatedObject(self, &colorsArrayKey, gradientBackgroundColors, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSArray<UIColor *> *)gradientBackgroundColors {
    return objc_getAssociatedObject(self, &colorsArrayKey);
}

- (void)setGradLayer:(CAGradientLayer *)gradLayer {
    
    objc_setAssociatedObject(self, &gradientLayerKey, gradLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (CAGradientLayer *)gradLayer {
    return objc_getAssociatedObject(self, &gradientLayerKey);
}

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(layoutSubviews)), class_getInstanceMethod([self class], @selector(_layoutSubviews)));
}

- (void)_layoutSubviews {
    
    if (!self.gradientBackgroundColors || !self.gradientBackgroundColors.count) {
        return;
    }
    
    NSMutableArray *results = [NSMutableArray arrayWithCapacity:self.gradientBackgroundColors.count];
    for (UIColor *color in self.gradientBackgroundColors) {
        [results addObject:(__bridge id)color.CGColor];
    }
    
    if (!self.gradLayer) {
        
        self.gradLayer = [CAGradientLayer layer];
        self.gradLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
        self.gradLayer.colors = results;
        self.gradLayer.startPoint = CGPointMake(0, 0);
        if (self.gradientDirect == UIViewGradientDirectVertical) {
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

@end
