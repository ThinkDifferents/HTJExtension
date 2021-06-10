//
//  UIImage+Extension.h
//  dolphinHouse
//
//  Created by j k m G on 2019/7/1.
//  Copyright © 2019 HTJ. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (Extension)

/**
 图片旋转

 @param orientation
 UIImageOrientationUp,            // 默认方向
 UIImageOrientationDown,          // 让默认方向旋转180度
 UIImageOrientationLeft,          // 让默认方向逆时针旋转90度
 UIImageOrientationRight,         // 让默认方向顺时针旋转90度
 UIImageOrientationUpMirrored,    // 默认方向的竖线镜像
 //（即以原图的左(或右)边的竖线为对称轴，对原图进行对称投影得到的镜像）
 UIImageOrientationDownMirrored,  // 让镜像旋转180度
 UIImageOrientationLeftMirrored,  // 让镜像逆时针旋转90度
 UIImageOrientationRightMirrored, // 让镜像顺时针旋转90度

 @return UIImage
 */
- (UIImage *)rotatingWithOrientation:(UIImageOrientation)orientation;


+ (UIImage *)imageWithRounded:(NSString *)ImageName;
+ (UIImage *)fixOrientation:(UIImage *)aImage ;

//图片改变颜色
- (UIImage*)imageChangeColor:(UIColor*)color;

/**
 图片透明度修改
 
 @param alpha 透明度
 @param image 图片image
 @return 修改透明度之后的图片
 */
+ (UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image;

/**
 *  调用该方法处理图像变清晰
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度以及高度
 */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size;

/// image切圆角
/// @param originalImage 原始图片
+ (UIImage *)imageWithOriginalImage:(UIImage *)originalImage;
@end


@interface UIImage (WithColor)

/**
 Returns a 1x1 image with the single pixel set to the specified color.

 Usage Note: almost all of UIKit will stretch this UIImage when you set
 it as, eg. backgroundImage, hence you often don’t need the size variant.
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 Returns an image of the requested size filled with the provided color.
 */
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;

/**
 Returns a (minimal) resizable image with the requested corner radius and
 filled with the provided color.
 */
+ (UIImage *)resizableImageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius;

+ (instancetype)waterMarkWithImage:(UIImage *)bgImage andMarkImage:(UIImage *)waterImage withRect:(CGRect)rect;


@end


@interface UIImage (Resize)

- (UIImage *)resizeImageWithSizeKB:(NSUInteger)sizeKB;


/// 重设image的尺寸
/// @param size size
- (UIImage *)imageWithscaleSize:(CGSize)size;


/// 自定义尺寸的Image
/// @param name 图片名
/// @param size 尺寸
+ (UIImage *)imageWithName:(NSString *)name size:(CGSize)size;

/// 指定宽度按比例缩放
/// @param sourceImage 原图
/// @param defineWidth 指定宽度
+ (UIImage *)imageCompressForWidthScale:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth;

/// GIF 转帧动画
/// @param data GIF data
+ (NSArray *)imageArrayWithGIFData:(NSData *)data;

@end


NS_ASSUME_NONNULL_END
