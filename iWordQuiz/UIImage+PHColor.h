//
//  UIImage+PHColor.h
//  PMC Reader
//
//  Created by Peter Hedlund on 9/25/13.
//  Copyright (c) 2013 Peter Hedlund. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (PHColor)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)changeImage:(UIImage*)image toColor:(UIColor*)color;

@end
