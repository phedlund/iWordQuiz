//
//  UIColor+PHColor.m
//  PMC Reader
//
//  Created by Peter Hedlund on 9/29/13.
//  Copyright (c) 2013 Peter Hedlund. All rights reserved.
//

#import "UIColor+PHColor.h"

//Sepia
#define kPHSepiaBackgroundColor        [UIColor colorWithRed:0.96 green:0.94 blue:0.86 alpha:1]
#define kPHSepiaCellBackgroundColor    [UIColor colorWithRed:1.0  green:0.98 blue:0.90 alpha:1]
#define kPHSepiaIconColor              [UIColor colorWithRed:0.36 green:0.24 blue:0.14 alpha:1]
#define kPHSepiaTextColor              [UIColor colorWithRed:0.24 green:0.16 blue:0.10 alpha:1]
#define kPHSepiaLinkColor              [UIColor colorWithRed:0.21 green:0.27 blue:0.35 alpha:1]
#define kPHSepiaPopoverBackgroundColor [UIColor colorWithRed:0.95 green:0.93 blue:0.90 alpha:1]
#define kPHSepiaPopoverButtonColor     [UIColor colorWithRed:0.97 green:0.96 blue:0.94 alpha:1]
#define kPHSepiaPopoverBorderColor     [UIColor colorWithRed:0.74 green:0.71 blue:0.65 alpha:1]

@implementation UIColor (PHColor)

+ (UIColor *)backgroundColor {
    return kPHSepiaBackgroundColor;
}

+ (UIColor *)cellBackgroundColor {
    return kPHSepiaCellBackgroundColor;
}

+ (UIColor *)iconColor {
    return kPHSepiaIconColor;
}

+ (UIColor *)textColor {
    return kPHSepiaTextColor;
}

+ (UIColor *)linkColor {
    return kPHSepiaLinkColor;
}

+ (UIColor *)popoverBackgroundColor {
    return kPHSepiaPopoverBackgroundColor;
}

+ (UIColor *)popoverButtonColor {
    return kPHSepiaPopoverButtonColor;
}

+ (UIColor *)popoverBorderColor {
    return kPHSepiaPopoverBorderColor;
}

+ (UIColor *)popoverIconColor {
    return kPHSepiaIconColor;
}

@end
