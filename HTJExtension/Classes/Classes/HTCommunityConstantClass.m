//
//  HTCommunityConstantClass.m
//  dolphinHouse
//
//  Created by shiwei on 2020/5/9.
//  Copyright © 2020 HTJ. All rights reserved.
//

#import "HTCommunityConstantClass.h"

@implementation HTCommunityConstantClass

Boolean isDevice375(void) {
    return [UIScreen mainScreen].bounds.size.width < 414;
}

UIFont* Light(CGFloat number) {
    if (@available(iOS 8.2, *)) {
        return [UIFont systemFontOfSize:number weight:UIFontWeightLight];
    } else {
        // Fallback on earlier versions
        return [UIFont systemFontOfSize:number];
    }
}
UIFont* System(CGFloat number) {
    if (@available(iOS 8.2, *)) {
        return [UIFont systemFontOfSize:number weight:UIFontWeightRegular];
    } else {
        // Fallback on earlier versions
        return [UIFont systemFontOfSize:number];
    }
}
UIFont* Medium(CGFloat number) {
    if (@available(iOS 8.2, *)) {
        return [UIFont systemFontOfSize:number weight:UIFontWeightMedium];
    } else {
        // Fallback on earlier versions
        return [UIFont systemFontOfSize:number];
    }
}
UIFont* Semibold(CGFloat number) {
    if (@available(iOS 8.2, *)) {
        return [UIFont systemFontOfSize:number weight:UIFontWeightSemibold];
    } else {
        // Fallback on earlier versions
        return [UIFont systemFontOfSize:number];
    }
}
UIFont* NumberFont(CGFloat number) {
    return [UIFont fontWithName:@"DIN Alternate" size:number];
}

UIFont* LightFont375(CGFloat number) {
    return isDevice375() ? Light(number) : Light(number * 1.104);
}
UIFont* SystemFont375(CGFloat number) {
    return isDevice375() ? System(number) : System(number * 1.104);
}
UIFont* MediumFont375(CGFloat number) {
    return isDevice375() ? Medium(number) : Medium(number * 1.104);
}
UIFont* SemiboldFont375(CGFloat number) {
    return isDevice375() ? Semibold(number) : Semibold(number * 1.104);
}
UIFont* NumberFont375(CGFloat number) {
    return isDevice375() ? NumberFont(number) : NumberFont(number * 1.104);
}

CGFloat Float375(CGFloat number) {
    return isDevice375() ? number : number * 1.104;
}
CGFloat Margin375(CGFloat number) {
    return isDevice375() ? number : number * 1.104;
}
CGSize Size375(CGSize size) {
    return isDevice375() ? size : CGSizeMake(size.width * 1.104, size.height * 1.104);
}

UIColor * rgba(CGFloat r, CGFloat g, CGFloat b, CGFloat a) {
    return [UIColor colorWithRed:(r)/255.f green:(g)/255.f blue:(b)/255.f alpha:a];
}

UIColor * kGray(CGFloat r) {
    return rgba(r, r, r, 1);
}

UIColor * Hex(NSString *hex) {
    return ColorWithHexString(hex, 1);
}

//#define StrFormat(format,...)  [NSString stringWithFormat:format,##__VA_ARGS__]
//NSString * kStrFormat(NSString *format, ...) {
//    return StrFormat(format);
//}

UIColor * ColorWithHexString(NSString *color, CGFloat alpha) {
    //删除字符串中的空格
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    if ([cString length] < 6)
    {
        return [UIColor clearColor];
    }
    // strip 0X if it appears
    //如果是0x开头的，那么截取字符串，字符串从索引为2的位置开始，一直到末尾
    if ([cString hasPrefix:@"0X"])
    {
        cString = [cString substringFromIndex:2];
    }
    //如果是#开头的，那么截取字符串，字符串从索引为1的位置开始，一直到末尾
    if ([cString hasPrefix:@"#"])
    {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6)
    {
        return [UIColor clearColor];
    }
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    //r
    NSString *rString = [cString substringWithRange:range];
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    return [UIColor colorWithRed:((float)r / 255.0f) green:((float)g / 255.0f) blue:((float)b / 255.0f) alpha:alpha];
}


BOOL IsIPhoneX(void) {
    if (@available(iOS 11.0, *)) {
        return [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom > 0;
    } else {
        // Fallback on earlier versions
        return false;
    }
}

CGFloat kNavigationBarH() {
    return 44.f;
}

CGFloat kStatusBarH() {
    return IsIPhoneX() ? 44 : 20;
}

CGFloat kSafeNavHeight() {
    return kNavigationBarH() + (IsIPhoneX() ? 44 : 20);
}

CGFloat kSafeAreaBottom() {
    
    if (@available(iOS 11.0, *)) {
        return IsIPhoneX() ? [UIApplication sharedApplication].keyWindow.safeAreaInsets.bottom : 0;
    } else {
        
        return 0;
    }
}

BOOL UnExecutedKey(NSString *key) {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:key] && [[defaults objectForKey:key] isEqualToString:@"true"]) {
        return false;
    } else {
        
        [defaults setObject:@"true" forKey:key];
        [defaults synchronize];
        return true;
    }
}

/// APP今天未执行过某操作
BOOL TodayUnExecutedKey(NSString *key) {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
    
    if ([defaults objectForKey:key] && [[defaults objectForKey:key] isEqualToString:dateString]) {
        return false;
    } else {
        
        [defaults setObject:dateString forKey:key];
        [defaults synchronize];
        return true;
    }
}

void EachObject(NSArray *objects, void (^block)(id object)) {
    for (id obj in objects) {
        block(obj);
    }
}

/// 比较两个版本号的大小 v1 为项目版本
BOOL compareVersion(NSString *v1, NSString *v2) {
    // 任意为空返回审核版本
    if (!v1 && !v2) {
        return true;
    }
    if (!v1 && v2) {
        return true;
    }
    if (v1 && !v2) {
        return true;
    }
    
    
    NSArray *v1Array = [v1 componentsSeparatedByString:@"."];
    NSArray *v2Array = [v2 componentsSeparatedByString:@"."];
    NSInteger bigCount = (v1Array.count > v2Array.count) ? v1Array.count : v2Array.count;
    
    for (int i = 0; i < bigCount; i++) {
        NSInteger value1 = (v1Array.count > i) ? [[v1Array objectAtIndex:i] integerValue] : 0;
        NSInteger value2 = (v2Array.count > i) ? [[v2Array objectAtIndex:i] integerValue] : 0;
        if (value1 > value2) {
            return true;
        } else if (value1 < value2) {
            
            // CMS版本大于项目版本, 认为不是审核版本
            return false;
        }
    }
    // 版本号相等
    return true;
}

UIImage * kGetImage(NSString *imageName) {
    return [UIImage imageNamed:[NSString stringWithFormat:@"%@",imageName]];
}

///// 屏幕宽
//CGFloat kScreenWidth(void) {
//
//    return [UIScreen mainScreen].bounds.size.width;
//}
///// 屏幕高
//CGFloat kScreenHeight(void) {
//
//    return [UIScreen mainScreen].bounds.size.height;
//}


/// 屏幕宽
CGFloat kScreenWidthValue(void) {
    
    return [UIScreen mainScreen].bounds.size.width;
}

/// 屏幕宽
CGFloat kScreenHeightValue(void) {
    
    return [UIScreen mainScreen].bounds.size.height;
}

CGFloat kCurrentScreenWidth(void) {
    
    return kScreenWidthValue() > kScreenHeightValue() ? kScreenHeightValue() : kScreenWidthValue();
}

CGFloat kCurrentScreenHeight(void) {
    
    return kScreenWidthValue() > kScreenHeightValue() ? kScreenWidthValue() : kScreenHeightValue();
}

/// 屏幕宽
CGFloat kScreenWidth(void) {
    
    return kCurrentScreenWidth();
}
/// 屏幕高
CGFloat kScreenHeight(void) {
    
    return kCurrentScreenHeight();
}

@end
