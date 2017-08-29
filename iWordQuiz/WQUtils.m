//
//  WQUtils.m
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

#import "WQUtils.h"
#import <QuartzCore/QuartzCore.h>
#include "UIColor+PHColor.h"

@implementation WQUtils

+ (BOOL) isEmpty:(id) thing {
	return thing == nil
	|| ([thing respondsToSelector:@selector(length)]
		&& [(NSData *)thing length] == 0)
	|| ([thing respondsToSelector:@selector(count)]
		&& [(NSArray *)thing count] == 0);
}


+ (BOOL) isOdd:(NSInteger) aNumber {
	return (aNumber % 2);
}

+ (void) renderCardShadow:(UIView*)aView {
    // Rounded corners.
    //aView.layer.cornerRadius = 15;
    
    // A thin border.
    aView.layer.borderColor = [UIColor phPopoverBorderColor].CGColor;
    aView.layer.borderWidth = 0.3;
    
    // Drop shadow.
    aView.layer.shadowColor = [UIColor phPopoverBorderColor].CGColor;
    aView.layer.shadowOpacity = 0.9;
    aView.layer.shadowRadius = 1.0;
    aView.layer.shadowOffset = CGSizeMake(0, 0);
	aView.layer.masksToBounds = NO;
    aView.layer.shadowPath = [UIBezierPath bezierPathWithRect:aView.bounds].CGPath;
}

+ (NSURL*) documentsDirectoryURL {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
