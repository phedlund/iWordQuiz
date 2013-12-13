//
//  UIImage+PHColor.m
//  PMC Reader
//
//  Created by Peter Hedlund on 9/25/13.
//  Copyright (c) 2013 Peter Hedlund. All rights reserved.
//

#import "UIImage+PHColor.h"

@implementation UIImage (PHColor)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 27);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [color setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
   
    return image;
}


+ (UIImage *)changeImage:(UIImage*)image toColor:(UIColor*)color {
    CGRect rect = CGRectMake(0, 0, image.size.width, image.size.height);
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextClipToMask(context, rect, image.CGImage);
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return [UIImage imageWithCGImage:img.CGImage scale:1.0 orientation: UIImageOrientationUp];
}


@end
