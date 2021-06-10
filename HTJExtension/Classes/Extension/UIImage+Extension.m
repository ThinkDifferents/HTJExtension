//
//  UIImage+Extension.m
//  dolphinHouse
//
//  Created by j k m G on 2019/7/1.
//  Copyright © 2019 HTJ. All rights reserved.
//

#import "UIImage+Extension.h"

@implementation UIImage (Extension)
- (UIImage *)rotatingWithOrientation:(UIImageOrientation)orientation{
    return [UIImage imageWithCGImage:self.CGImage
                        scale:self.scale
                         orientation:orientation];
}
+ (UIImage *)imageWithRounded:(NSString *)ImageName{
    UIImage * image = [UIImage imageNamed:ImageName];
    image = [image stretchableImageWithLeftCapWidth:image.size.width/2 topCapHeight:image.size.height/2];
    return image;
}
+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

//图片改变颜色
- (UIImage*)imageChangeColor:(UIColor*)color{
    //获取画布
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    //画笔沾取颜色
    [color setFill];
    
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    //绘制一次
    [self drawInRect:bounds blendMode:kCGBlendModeOverlay alpha:1.0f];
    //再绘制一次
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    //获取图片
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}
/**
 图片透明度修改
 
 @param alpha 透明度
 @param image 图片image
 @return 修改透明度之后的图片
 */
+ (UIImage *)imageByApplyingAlpha:(CGFloat)alpha  image:(UIImage*)image
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, image.size.width, image.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, image.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}
/**
 *  调用该方法处理图像变清晰
 *  根据CIImage生成指定大小的UIImage
 *
 *  @param image CIImage
 *  @param size  图片宽度以及高度
 */
+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    //1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    //2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}
// 生成圆角图片
+ (UIImage *)imageWithOriginalImage:(UIImage *)originalImage{
    
    CGRect rect = CGRectMake(0, 0, originalImage.size.width, originalImage.size.height);
    
    UIGraphicsBeginImageContextWithOptions(originalImage.size, NO, 0.0);
    
    CGFloat cornerRadius = MIN(originalImage.size.width, originalImage.size.height) * 0.5;
    
    [[UIBezierPath bezierPathWithRoundedRect:rect
                                cornerRadius:cornerRadius] addClip];
    
    [originalImage drawInRect:rect];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}
@end

@implementation UIImage (WithColor)

+ (UIImage *)imageWithColor:(UIColor *)color {
    return [self imageWithColor:color size:CGSizeMake(1,1)];
}

+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size {
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

+ (UIImage *)resizableImageWithColor:(UIColor *)color cornerRadius:(CGFloat)cornerRadius {
    CGFloat minEdgeSize = cornerRadius * 2 + 1;
    CGRect rect = CGRectMake(0, 0, minEdgeSize, minEdgeSize);
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:cornerRadius];
    roundedRect.lineWidth = 0;
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    [color setFill];
    [roundedRect fill];
    [roundedRect stroke];
    [roundedRect addClip];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(cornerRadius, cornerRadius, cornerRadius, cornerRadius)];
}

+ (instancetype)waterMarkWithImage:(UIImage *)bgImage andMarkImage:(UIImage *)waterImage withRect:(CGRect)rect {
    
//    UIImage *bgImage = [UIImage imageNamed:image];
    
    UIGraphicsBeginImageContextWithOptions(bgImage.size, NO, 0.0);
    [bgImage drawInRect:CGRectMake(0, 0, bgImage.size.width, bgImage.size.height)];
    
//    UIImage *waterImage = [UIImage imageNamed:markName];
    CGFloat scale = 0.3;
    CGFloat margin = 5;
    CGFloat waterW = waterImage.size.width * scale;
    CGFloat waterH = waterImage.size.height * scale;
    CGFloat waterX = (bgImage.size.width - waterW) / 2;
//    CGFloat waterX = bgImage.size.width - waterW - margin;

    
    CGFloat waterY = bgImage.size.height - waterH - margin;
    
    if (rect.size.width > 1) {
        [waterImage drawInRect:rect];
    } else
        [waterImage drawInRect:CGRectMake(waterX, waterY, waterW, waterH)];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end

@implementation UIImage (Resize)

- (UIImage *)resizeImageWithSizeKB:(NSUInteger)sizeKB {
    UIImage *thumb = [UIImage imageWithData:[self resizeDataWithSizeKB:sizeKB]];
    return thumb;
}

- (NSData *)resizeDataWithSizeKB:(NSUInteger)sizeKB {
    CGFloat compression = 1;
    CGFloat scale = 1;
    UIImage *imageself = self;

    NSData *imageData = [self resizeWithImage:imageself scale:scale compression:compression];
    NSData *nextData;
    // Webchat limit thumb image size is 32kb, so if the image is bigger than that, it will process
    // for resize and compression.
    while ([imageData length] > 1024*sizeKB && compression > 0.001)
    {
        if (compression - 0.1 > 0.000001) {
            compression -= 0.1;
            scale -= 0.1;
        }
        else if (compression - 0.01 > 0.000001) {
            compression -= 0.01;
        }
        else {
            compression -= 0.001;
        }
        @autoreleasepool {
            nextData = [self resizeWithImage:imageself scale:scale compression:compression];

            if (nextData.length > 1024 * sizeKB) {
                imageData = nextData;
            }
            else {
                if ((nextData.length - 1024 * sizeKB) < (imageData.length - 1024 * sizeKB)) {
                    imageData = nextData;
                }
                break;
            }
        }

    }
    return imageData;
}

- (NSData *)resizeWithImage:(UIImage*)image scale:(CGFloat)scale compression:(CGFloat)compression
{
    CGSize newSize = CGSizeMake(image.size.width * scale, image.size.height * scale);

    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return UIImageJPEGRepresentation(newImage, compression);
}


- (UIImage *)imageWithscaleSize:(CGSize)size {
    if (!self) return nil;
    UIImage *thumbnailImage;
    CGRect rect;
    if (size.width / size.height > self.size.width / self.size.height) {
        rect.size.width = size.height * self.size.width / self.size.height;
        rect.size.height = size.height;
        rect.origin.x = (size.width - rect.size.width) / 2;
        rect.origin.y = 0;
    } else {
        rect.size.width = size.width;
        rect.size.height = size.width * self.size.height / self.size.width;
        rect.origin.x = 0;
        rect.origin.y = (size.height - rect.size.height) / 2;
    }
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    [self drawInRect:rect];
    thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return thumbnailImage;
}

+ (UIImage *)imageWithName:(NSString *)name size:(CGSize)size {
    
    UIImage *image = [UIImage imageNamed:name];
    if (!image) return nil;
    UIImage *thumbnailImage;
    CGRect rect;
    if (size.width / size.height > image.size.width / image.size.height) {
        rect.size.width = size.height * image.size.width / image.size.height;
        rect.size.height = size.height;
        rect.origin.x = (size.width - rect.size.width) / 2;
        rect.origin.y = 0;
    } else {
        rect.size.width = size.width;
        rect.size.height = size.width * image.size.height / image.size.width;
        rect.origin.x = 0;
        rect.origin.y = (size.height - rect.size.height) / 2;
    }
    
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [UIColor clearColor].CGColor);
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    [image drawInRect:rect];
    thumbnailImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return thumbnailImage;
}
//指定宽度按比例缩放
+ (UIImage *) imageCompressForWidthScale:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{

    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);

    if(CGSizeEqualToSize(imageSize, size) == NO){

        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;

        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;

        if(widthFactor > heightFactor){

            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;

        }else if(widthFactor < heightFactor){

            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }

    UIGraphicsBeginImageContext(size);

    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;

    [sourceImage drawInRect:thumbnailRect];

    newImage = UIGraphicsGetImageFromCurrentImageContext();

    if(newImage == nil){

        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}
+ (NSArray *)imageArrayWithGIFData:(NSData *)data{
    CFDataRef imgDataRef = (CFDataRef)CFBridgingRetain(data);
    CGImageSourceRef gifDataSource = CGImageSourceCreateWithData(imgDataRef, nil);
    NSInteger gifImageCount = CGImageSourceGetCount(gifDataSource);
    NSMutableArray * images = [NSMutableArray array];
    for (int i = 0; i < gifImageCount; i++) {
        CGImageRef imageref = CGImageSourceCreateImageAtIndex(gifDataSource, i, nil);
        UIImage * image = [UIImage imageWithCGImage:imageref scale:UIScreen.mainScreen.scale orientation:UIImageOrientationUp];
        [images addObject:[self scaleToSize:image size:CGSizeMake(63, 63)]];
    }
    return images;
}
+ (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)newsize{
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    //原图片尺寸是150*150 当裁剪时会被压缩 所以改成3倍（50*50） 不然图片会不清晰
    UIGraphicsBeginImageContextWithOptions(newsize, NO, 3.0);
    // 绘制改变大小的图片
    [img drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}
@end


