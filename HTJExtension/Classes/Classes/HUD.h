//
//  HUD.h
//  InfrastructureProjects
//
//  Created by shiwei on 2020/4/23.
//  Copyright © 2020 shiwei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class HUD;

NS_ASSUME_NONNULL_BEGIN

typedef HUD * _Nonnull (^HUDToVoid) (void);
typedef HUD * _Nonnull (^HUDToString) (NSString *text);
typedef HUD * _Nonnull (^HUDToFloat) (CGFloat duration);
typedef HUD * _Nonnull (^HUDToView) (UIView *view);

@interface HUD : NSObject

/// 提示时间  默认 1.5
@property (nonatomic, copy, readonly) HUDToFloat TipDuration;
/// 等待时间 默认 0 一直持续 需要手动关闭
@property (nonatomic, copy, readonly) HUDToFloat LoadingDuration;
@property (nonatomic, copy, readonly) HUDToView ToView;

@property (nonatomic, copy, readonly) HUDToString ShowSuccess;
@property (nonatomic, copy, readonly) HUDToString ShowError;
@property (nonatomic, copy, readonly) HUDToVoid ShowLoading;
@property (nonatomic, copy, readonly) HUDToString ShowText;
@property (nonatomic, copy, readonly) HUDToString ShowTextLoading;
@property (nonatomic, copy, readonly) HUDToVoid ShowCustomLoading;

+ (instancetype)instance;
+ (void)hide;

@end

NS_ASSUME_NONNULL_END
