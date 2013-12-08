//
//  UIColor+PHColor.h
//  PMC Reader
//
//  Created by Peter Hedlund on 9/29/13.
//  Copyright (c) 2013 Peter Hedlund. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (PHColor)

+ (UIColor *)backgroundColor;
+ (UIColor *)cellBackgroundColor;
+ (UIColor *)iconColor;
+ (UIColor *)textColor;
+ (UIColor *)linkColor;
+ (UIColor *)popoverBackgroundColor;
+ (UIColor *)popoverButtonColor;
+ (UIColor *)popoverBorderColor;
+ (UIColor *)popoverIconColor;

@end
