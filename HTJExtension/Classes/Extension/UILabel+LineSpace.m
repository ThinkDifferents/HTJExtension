//
//  UILabel+Extension.m
//  InfrastructureProjects
//
//  Created by shiwei on 2020/4/5.
//  Copyright © 2020 shiwei. All rights reserved.
//

#import "UILabel+LineSpace.h"
#import <objc/message.h>

@implementation UILabel (LineSpace)

static char *lineSpaceKey;

+ (void)initialize {
    
    //交换设置文本的方法实现。
    Method oldMethod = class_getInstanceMethod([self class], @selector(setText:));
    Method newMethod = class_getInstanceMethod([self class], @selector(setHasLineSpaceText:));
    method_exchangeImplementations(oldMethod, newMethod);
}

//设置带有行间距的文本。
- (void)setHasLineSpaceText:(NSString *)text {
    
    if (!text.length || self.lineSpace==0) {
        [self setHasLineSpaceText:text];
        return;
    }
    
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineSpacing = self.lineSpace;
    style.lineBreakMode = self.lineBreakMode;
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:text];
    [attrString addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, text.length)];
    self.attributedText = attrString;
}

- (void)setLineSpace:(CGFloat)lineSpace {
    NSString *space = [NSString stringWithFormat:@"%f", lineSpace];
    objc_setAssociatedObject(self, &lineSpaceKey, space, OBJC_ASSOCIATION_COPY_NONATOMIC);
    self.text = self.text;
}

- (CGFloat)lineSpace {
    return [objc_getAssociatedObject(self, &lineSpaceKey) floatValue];
}

@end
