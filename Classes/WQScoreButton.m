//
//  WQScoreButton.m
//  iWordQuiz
//

/************************************************************************
 
 Copyright 2012 Peter Hedlund peter.hedlund@me.com
 
 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions
 are met:
 
 1. Redistributions of source code must retain the above copyright
 notice, this list of conditions and the following disclaimer.
 2. Redistributions in binary form must reproduce the above copyright
 notice, this list of conditions and the following disclaimer in the
 documentation and/or other materials provided with the distribution.
 
 THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR
 IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES
 OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED.
 IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT,
 INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT
 NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
 DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
 THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF
 THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 *************************************************************************/

#import "WQScoreButton.h"

@implementation WQScoreButton

@synthesize stickyColor;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.opaque = NO;
        self.backgroundColor = [UIColor clearColor];
        self.stickyColor = kBlue;
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [[UIColor colorWithRed:0.0f green:0.0f blue:0.0f alpha:0.39f] setFill]; //a dark gray
    [[UIColor blackColor] setStroke];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    //the gray background
	[path moveToPoint:CGPointMake(4, 100-84)];
	[path addQuadCurveToPoint:CGPointMake(34, 100-91) controlPoint:CGPointMake(16, 100-89)];
    [path addLineToPoint:CGPointMake(88, 100-98)];
    [path addLineToPoint:CGPointMake(93, 100-55)];
	[path addQuadCurveToPoint:CGPointMake(104, 100-18) controlPoint:CGPointMake(97, 100-29)];
	[path addQuadCurveToPoint:CGPointMake(56, 100-6) controlPoint:CGPointMake(86, 100-10)];
    [path addLineToPoint:CGPointMake(12, 100)];
    [path addLineToPoint:CGPointMake(2, 100-75)];
    [path addQuadCurveToPoint:CGPointMake(4, 100-84) controlPoint:CGPointMake(0, 100-80)];
    
    [path closePath];
    [path fill];
    
    [path removeAllPoints];
    //the outline    
    [path moveToPoint:CGPointMake(2, 100-86)];
	[path addQuadCurveToPoint:CGPointMake(33, 100-92) controlPoint:CGPointMake(15, 100-90)];
    [path addLineToPoint:CGPointMake(87, 100-99)];
    [path addLineToPoint:CGPointMake(93, 100-55)];
    [path addQuadCurveToPoint:CGPointMake(102, 100-27) controlPoint:CGPointMake(94, 100-38)];
	[path addQuadCurveToPoint:CGPointMake(55, 100-6) controlPoint:CGPointMake(88, 100-9)];
    [path addLineToPoint:CGPointMake(11, 100-1)];
    [path addLineToPoint:CGPointMake(1, 100-75)];
    [path addQuadCurveToPoint:CGPointMake(2, 100-86) controlPoint:CGPointMake(0, 100-82)];
    
    [path closePath];
    path.lineWidth = 2.5f;
    [path stroke];
    
    //the color fill
    CGGradientRef gradient;
    CGColorSpaceRef colorSpace;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGColorRef startColor; 
    CGColorRef endColor;     
    switch (self.stickyColor) {
        case kBlue:
            startColor = [UIColor colorWithRed:0.59 green:0.70 blue:0.78 alpha:1].CGColor;
            endColor = [UIColor colorWithRed:0.76 green:0.9 blue:1.0 alpha:1.0].CGColor;
            break;
        case kYellow:
            startColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.0 alpha:1.0].CGColor;
            endColor = [UIColor colorWithRed:1.0 green:1.0 blue:0.29 alpha:1].CGColor;
            break;
        case kGreen:
            startColor = [UIColor colorWithRed:0.49 green:0.80 blue:0.22 alpha:1].CGColor;
            endColor = [UIColor colorWithRed:0.62 green:1.0 blue:0.27 alpha:1.0].CGColor;
            break;
        case kRed:
            startColor = [UIColor colorWithRed:0.80 green:0.36 blue:0.36 alpha:1].CGColor;
            endColor = [UIColor colorWithRed:1.0 green:0.45 blue:0.45 alpha:1.0].CGColor;
            break;
        default:
            break;
    }
    
    NSArray *colors = [NSArray arrayWithObjects:(id)startColor, (id)endColor, nil];

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    colorSpace = CGColorSpaceCreateDeviceRGB();
    gradient = CGGradientCreateWithColors(colorSpace, (CFArrayRef) colors, locations);
    CGContextAddPath(ctx, path.CGPath);
    CGContextClip(ctx);
    CGContextDrawLinearGradient (ctx, gradient, CGPointMake(7, 100-85), CGPointMake(11, 100-78), kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);    
}

@end
