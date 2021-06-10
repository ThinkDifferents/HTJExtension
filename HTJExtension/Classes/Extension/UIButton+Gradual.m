//
//  UIButton+Gradual.m
//  dolphinHouse
//
//  Created by shiwei on 2020/6/4.
//  Copyright © 2020 HTJ. All rights reserved.
//

#import "UIButton+Gradual.h"
#import <objc/message.h>
#import <ReactiveObjC/ReactiveObjC.h>

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

// Associative reference keys.
static NSString *const kIndicatorViewKey = @"indicatorView";
static NSString *const kButtonTextObjectKey = @"buttonTextObject";

// 上下结构按钮
@interface UIImage (MiddleAligning)

@end

@implementation UIImage (MiddleAligning)

- (UIImage *)MiddleAlignedButtonImageScaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0.0, size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextDrawImage(context, CGRectMake(0.0f, 0.0f, size.width, size.height), self.CGImage);
    
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

@end
// 上下结构按钮 end

// 状态专用
@interface UIButton ()

@property(nonatomic, strong) UIView *modalView;
@property(nonatomic, strong) UIActivityIndicatorView *spinnerView;
@property(nonatomic, strong) UILabel *spinnerTitleLabel;

@end
// 状态专用 end

@implementation UIButton (Extension)

#pragma mark - 显示按钮菊花
- (void) showIndicator {
    
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicator.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    [indicator startAnimating];
    
    NSString *currentButtonText = self.titleLabel.text;
    
    objc_setAssociatedObject(self, &kButtonTextObjectKey, currentButtonText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &kIndicatorViewKey, indicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self setTitle:@"" forState:UIControlStateNormal];
    self.enabled = NO;
    [self addSubview:indicator];
    
    
}

#pragma mark 隐藏按钮菊花
- (void) hideIndicator {
    
    NSString *currentButtonText = (NSString *)objc_getAssociatedObject(self, &kButtonTextObjectKey);
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)objc_getAssociatedObject(self, &kIndicatorViewKey);
    
    [indicator removeFromSuperview];
    [self setTitle:currentButtonText forState:UIControlStateNormal];
    self.enabled = YES;
    
}

#pragma mark - 将按钮改为上下结构
- (void)middleAlignButtonWithSpacing:(CGFloat)spacing
{
    __weak typeof(self) wself = self;
    [[self rac_signalForSelector:@selector(layoutSubviews)] subscribeNext:^(RACTuple * _Nullable x) {
        [wself middleAlignWithSpacing:spacing];
    }];
}

- (void)middleAlignWithSpacing:(CGFloat)spacing {
    
    NSString *titleString = [self titleForState:UIControlStateNormal]?:@"";
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:titleString attributes:@{NSFontAttributeName : self.titleLabel.font}];
    CGSize titleSize = [attributedString boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
    CGSize imageSize = [self imageForState:UIControlStateNormal].size;
    CGFloat maxImageHeight = CGRectGetHeight(self.frame) - titleSize.height - spacing * 2;
    CGFloat maxImageWidth = CGRectGetWidth(self.frame);
    UIImage *newImage = nil;
    if (imageSize.width > ceilf(maxImageWidth)) {
        CGFloat ratio = maxImageWidth / imageSize.width;
        newImage = [self.imageView.image MiddleAlignedButtonImageScaleToSize:CGSizeMake(maxImageWidth, imageSize.height * ratio)];
        imageSize = newImage.size;
    }
    if (imageSize.height > ceilf(maxImageHeight)) {
        CGFloat ratio = maxImageHeight / imageSize.height;
        newImage = [self.imageView.image MiddleAlignedButtonImageScaleToSize:CGSizeMake(imageSize.width * ratio, maxImageHeight)];
        imageSize = newImage.size;
    }
    if (newImage) {
        if ([newImage respondsToSelector:@selector(imageWithRenderingMode:)]) {
            newImage = [newImage imageWithRenderingMode:self.imageView.image.renderingMode];
        }
        [self setImage:newImage forState:UIControlStateNormal];
    }
    
    CGFloat imageVerticalDiff = titleSize.height + spacing;
    CGFloat imageHorizontalDiff = titleSize.width;
    
    self.imageEdgeInsets = UIEdgeInsetsMake(-imageVerticalDiff, 0, 0, -imageHorizontalDiff);
    
    CGFloat titleVerticalDiff = imageSize.height + spacing;
    CGFloat titleHorizontalDiff = imageSize.width;
    
    self.titleEdgeInsets = UIEdgeInsetsMake(0, -titleHorizontalDiff, -titleVerticalDiff, 0);
}

#pragma mark - 设置额外热区


- (UIEdgeInsets)touchAreaInsets
{
    return [objc_getAssociatedObject(self, @selector(touchAreaInsets)) UIEdgeInsetsValue];
}

- (void)setTouchAreaInsets:(UIEdgeInsets)touchAreaInsets
{
    NSValue *value = [NSValue valueWithUIEdgeInsets:touchAreaInsets];
    objc_setAssociatedObject(self, @selector(touchAreaInsets), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    UIEdgeInsets touchAreaInsets = self.touchAreaInsets;
    CGRect bounds = self.bounds;
    bounds = CGRectMake(bounds.origin.x - touchAreaInsets.left,
                        bounds.origin.y - touchAreaInsets.top,
                        bounds.size.width + touchAreaInsets.left + touchAreaInsets.right,
                        bounds.size.height + touchAreaInsets.top + touchAreaInsets.bottom);
    return CGRectContainsPoint(bounds, point);
}

#pragma mark - 按钮点击后，禁用按钮并在按钮上显示
- (void)beginSubmitting:(NSString *)title {
    [self endSubmitting];
    
    self.submitting = @YES;
    self.hidden = YES;
    
    self.modalView = [[UIView alloc] initWithFrame:self.frame];
    self.modalView.backgroundColor =
    [self.backgroundColor colorWithAlphaComponent:0.6];
    self.modalView.layer.cornerRadius = self.layer.cornerRadius;
    self.modalView.layer.borderWidth = self.layer.borderWidth;
    self.modalView.layer.borderColor = self.layer.borderColor;
    
    CGRect viewBounds = self.modalView.bounds;
    self.spinnerView = [[UIActivityIndicatorView alloc]
                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    self.spinnerView.tintColor = self.titleLabel.textColor;
    
    CGRect spinnerViewBounds = self.spinnerView.bounds;
    self.spinnerView.frame = CGRectMake(
                                        15, viewBounds.size.height / 2 - spinnerViewBounds.size.height / 2,
                                        spinnerViewBounds.size.width, spinnerViewBounds.size.height);
    self.spinnerTitleLabel = [[UILabel alloc] initWithFrame:viewBounds];
    self.spinnerTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.spinnerTitleLabel.text = title;
    self.spinnerTitleLabel.font = self.titleLabel.font;
    self.spinnerTitleLabel.textColor = self.titleLabel.textColor;
    [self.modalView addSubview:self.spinnerView];
    [self.modalView addSubview:self.spinnerTitleLabel];
    [self.superview addSubview:self.modalView];
    [self.spinnerView startAnimating];
}

#pragma mark 按钮点击后，恢复按钮点击前的状态
- (void)endSubmitting {
    if (!self.isSubmitting.boolValue) {
        return;
    }
    
    self.submitting = @NO;
    self.hidden = NO;
    
    [self.modalView removeFromSuperview];
    self.modalView = nil;
    self.spinnerView = nil;
    self.spinnerTitleLabel = nil;
}

#pragma mark  按钮是否正在提交中
- (NSNumber *)isSubmitting {
    return objc_getAssociatedObject(self, @selector(setSubmitting:));
}

- (void)setSubmitting:(NSNumber *)submitting {
    objc_setAssociatedObject(self, @selector(setSubmitting:), submitting, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
}

- (UIActivityIndicatorView *)spinnerView {
    return objc_getAssociatedObject(self, @selector(setSpinnerView:));
}

- (void)setSpinnerView:(UIActivityIndicatorView *)spinnerView {
    objc_setAssociatedObject(self, @selector(setSpinnerView:), spinnerView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)modalView {
    return objc_getAssociatedObject(self, @selector(setModalView:));
    
}

- (void)setModalView:(UIView *)modalView {
    objc_setAssociatedObject(self, @selector(setModalView:), modalView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UILabel *)spinnerTitleLabel {
    return objc_getAssociatedObject(self, @selector(setSpinnerTitleLabel:));
}

- (void)setSpinnerTitleLabel:(UILabel *)spinnerTitleLabel {
    objc_setAssociatedObject(self, @selector(setSpinnerTitleLabel:), spinnerTitleLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end
