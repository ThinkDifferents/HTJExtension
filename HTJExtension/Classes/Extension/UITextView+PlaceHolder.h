//
//  UITextView+PlaceHolder.h
//  InfrastructureProjects
//
//  Created by shiwei on 2020/6/9.
//  Copyright © 2020 shiwei. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UITextView (PlaceHolder)

@property (nonatomic, copy) NSString *placeHolderString;
@property (nonatomic, strong) UIColor *placeHolderColor;

@end

NS_ASSUME_NONNULL_END
