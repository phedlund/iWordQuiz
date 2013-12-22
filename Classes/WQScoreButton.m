//
//  WQScoreButton.m
//  iWordQuiz
//

/************************************************************************
 
 Copyright 2012-2013 Peter Hedlund peter.hedlund@me.com
 
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
#import "UIColor+PHColor.h"

@implementation WQScoreButton

@synthesize circleColor;
@synthesize circleLayer;

- (void)awakeFromNib {
    self.opaque = NO;
    self.backgroundColor = [UIColor clearColor];
    [[self layer] addSublayer:self.circleLayer];
    self.titleLabel.textColor = [UIColor iconColor];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event {
    CGFloat radius = self.bounds.size.height / 2;
    CGFloat x = radius - point.x;
    CGFloat y = radius - point.y;
    if (x*x + y*y < radius*radius)
        return [super pointInside:point withEvent:event];
    else
        return NO;
}

- (CALayer*)circleLayer {
    if (!circleLayer) {
        UIColor *color;
        switch ([self.circleColor intValue]) {
            case 0: //blue
                //startColor = [UIColor colorWithRed:0.59 green:0.70 blue:0.78 alpha:1];
                color = [UIColor colorWithRed:0.76 green:0.9 blue:1.0 alpha:1.0];
                break;
            case 1: //yellow
                //startColor = [UIColor colorWithRed:0.78 green:0.78 blue:0.0 alpha:1.0];
                color = [UIColor colorWithRed:1.0 green:1.0 blue:0.29 alpha:1];
                break;
            case 2: //green
                //startColor = [UIColor colorWithRed:0.49 green:0.80 blue:0.22 alpha:1];
                color = [UIColor colorWithRed:0.62 green:1.0 blue:0.27 alpha:1.0];
                break;
            case 3: //red
                //startColor = [UIColor colorWithRed:0.80 green:0.36 blue:0.36 alpha:1];
                color = [UIColor colorWithRed:1.0 green:0.45 blue:0.45 alpha:1.0];
                break;
            default:
                break;
        }
        
        circleLayer = [CAShapeLayer layer];
        circleLayer.bounds = CGRectMake(0.0f, 0.0f, [self bounds].size.width, [self bounds].size.height);
        circleLayer.position = CGPointMake(CGRectGetMidX([self bounds]), CGRectGetMidY([self bounds]));
        
        UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetHeight(self.frame))];
        
        circleLayer.path = path.CGPath;
        circleLayer.strokeColor = [UIColor popoverBorderColor].CGColor;
        circleLayer.lineWidth = 0.3f;
        circleLayer.fillColor = color.CGColor;
        
        // Drop shadow.
        circleLayer.shadowColor = [UIColor popoverBorderColor].CGColor;
        circleLayer.shadowOpacity = 0.9;
        circleLayer.shadowRadius = 1.0;
        circleLayer.shadowOffset = CGSizeMake(0, 0);
        circleLayer.masksToBounds = NO;
        circleLayer.shadowPath = path.CGPath;
    }
    return circleLayer;
}

@end
