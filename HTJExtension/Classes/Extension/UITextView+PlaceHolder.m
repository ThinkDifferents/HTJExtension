//
//  UITextView+PlaceHolder.m
//  InfrastructureProjects
//
//  Created by shiwei on 2020/6/9.
//  Copyright © 2020 shiwei. All rights reserved.
//

#import "UITextView+PlaceHolder.h"
#import <objc/runtime.h>

@interface UITextView () <UITextViewDelegate>

@property (nonatomic, strong) UILabel *placeHolderLabel;

@end

@implementation UITextView (PlaceHolder)

static char *placeHolderStringKey;
static char *placeHolderColorKey;
static char *placeHolderLabelKey;

- (void)setPlaceHolderString:(NSString *)placeHolderString {
    objc_setAssociatedObject(self, &placeHolderStringKey, placeHolderString, OBJC_ASSOCIATION_COPY_NONATOMIC);
}

- (NSString *)placeHolderString {
    return objc_getAssociatedObject(self, &placeHolderStringKey);
}

- (void)setPlaceHolderColor:(UIColor *)placeHolderColor {
    objc_setAssociatedObject(self, &placeHolderColorKey, placeHolderColor, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIColor *)placeHolderColor {
    return objc_getAssociatedObject(self, &placeHolderColorKey);
}

- (UILabel *)placeHolderLabel {
    return (UILabel *)objc_getAssociatedObject(self, &placeHolderLabelKey);
}

- (void)setPlaceHolderLabel:(UIButton *)placeHolderLabel {
    
    objc_setAssociatedObject(self, &placeHolderLabelKey, placeHolderLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)_layoutSubviews {
    [self _layoutSubviews];
    
    if (!self.placeHolderString || !self.placeHolderString.length) {
        return;
    }
    
    if (!self.placeHolderLabel) {
        self.placeHolderLabel = UILabel.new;
        self.placeHolderLabel.text = self.placeHolderString;
        self.placeHolderLabel.textColor = self.placeHolderColor;
        self.placeHolderLabel.font = self.font;
        self.placeHolderLabel.numberOfLines = 0;
        self.placeHolderLabel.frame = CGRectMake(self.textContainerInset.top * 0.5, self.textContainerInset.top, self.bounds.size.width - 8, 0);
        [self.placeHolderLabel sizeToFit];
        [self addSubview:self.placeHolderLabel];
        self.delegate = self;
    } else {
        self.placeHolderLabel.text = self.placeHolderString;
        self.placeHolderLabel.textColor = self.placeHolderColor;
    }
    [self setPlaceHolderIsShow];
}

- (void)setPlaceHolderIsShow {
    self.placeHolderLabel.hidden = self.hasText;
}

- (void)textViewDidChange:(UITextView *)textView {
    [self setPlaceHolderIsShow];
}

+ (void)load {
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(layoutSubviews)), class_getInstanceMethod([self class], @selector(_layoutSubviews)));
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(setText:)), class_getInstanceMethod([self class], @selector(_setText:)));
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(setAttributedText:)), class_getInstanceMethod([self class], @selector(_setAttributedText:)));
}

- (void)_setText:(NSString *)text {
    [self _setText:text];
    [self setPlaceHolderIsShow];
}

-(void)_setAttributedText:(NSAttributedString *)attributedText {
    [self _setAttributedText:attributedText];
    [self setPlaceHolderIsShow];
}

@end
