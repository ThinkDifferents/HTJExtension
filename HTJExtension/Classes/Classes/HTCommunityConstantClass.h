//
//  HTCommunityConstantClass.h
//  dolphinHouse
//
//  Created by shiwei on 2020/5/9.
//  Copyright © 2020 HTJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HTCommunityConstantClass : NSObject

UIFont* Light(CGFloat number);
UIFont* System(CGFloat number);
UIFont* Medium(CGFloat number);
UIFont* Semibold(CGFloat number);
UIFont* NumberFont(CGFloat number);

UIFont* LightFont375(CGFloat number);
UIFont* SystemFont375(CGFloat number);
UIFont* MediumFont375(CGFloat number);
UIFont* SemiboldFont375(CGFloat number);
UIFont* NumberFont375(CGFloat number);

CGFloat Float375(CGFloat number);
CGFloat Margin375(CGFloat number);
CGSize Size375(CGSize size);

BOOL IsIPhoneX(void);

CGFloat kNavigationBarH(void);
CGFloat kStatusBarH(void);
CGFloat kSafeNavHeight(void);
CGFloat kSafeAreaBottom(void);

/// 屏幕宽 横竖屏不一致
CGFloat kScreenWidthValue(void);
/// 屏幕宽 横竖屏不一致
CGFloat kScreenHeightValue(void);

/// 屏幕宽 不区分横竖屏
CGFloat kScreenWidth(void);
/// 屏幕高 不区分横竖屏
CGFloat kScreenHeight(void);

/// APP未执行过某操作
BOOL UnExecutedKey(NSString *key);
/// APP今天未执行过某操作
BOOL TodayUnExecutedKey(NSString *key);

/// 快速便利
void EachObject(NSArray *objects, void (^block)(id object));

UIColor * rgba(CGFloat r, CGFloat g, CGFloat b, CGFloat a);
UIColor * kGray(CGFloat r);
UIColor * ColorWithHexString(NSString *color, CGFloat alpha);
UIColor * Hex(NSString *hex);

UIImage * kGetImage(NSString *imageName);

@end

NS_ASSUME_NONNULL_END
