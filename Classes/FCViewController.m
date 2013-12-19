//
//  FCViewController.m
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

#import "FCViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "WQUtils.h"
#import "JMWhenTapped.h"
#import "UIColor+PHColor.h"

#define kTransitionDuration	0.50

@implementation FCViewController

@synthesize quiz = m_quiz;
@synthesize slideToTheRight;

@synthesize animationImage;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor backgroundColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	
	self.frontView.userInteractionEnabled = YES;
    self.backView.hidden = true;
    [self.frontView whenTapped:^{
		[self flipCard:false];
	}];
    [self.backView whenTapped:^{
		[self flipCard:false];
	}];

	[self.questionCountButton setTitle:@"" forState:UIControlStateNormal];
	[self.answerCountButton setTitle:@"" forState:UIControlStateNormal];
	[self.correctCountButton setTitle:@"" forState:UIControlStateNormal];
	[self.errorCountButton setTitle:@"" forState:UIControlStateNormal];
    
    m_animationLayer = [CALayer layer];
    m_animationLayer.bounds = self.containerView.layer.bounds;
    [self.containerView.layer addSublayer:m_animationLayer];
    
    CGFloat cRadius = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 30.0f : 15.0f;
    self.knowButton.layer.cornerRadius = cRadius;
    self.knowButton.layer.backgroundColor = [UIColor colorWithRed:0.45 green:0.9 blue:0.25 alpha:1.0].CGColor;
	self.knowButton.enabled = NO;
    self.knowButton.titleLabel.textColor = [UIColor whiteColor];

    self.dontKnowButton.layer.cornerRadius = cRadius;
    self.dontKnowButton.layer.backgroundColor = [UIColor colorWithRed:1.0 green:0.45 blue:0.45 alpha:1.0].CGColor;
	self.dontKnowButton.enabled = NO;
    self.dontKnowButton.titleLabel.textColor = [UIColor whiteColor];
    
	self.errorCountButton.enabled = NO;
    [self willRotateToInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation duration:0];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        int width;
        int height;
        if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
            width = CGRectGetHeight([UIScreen mainScreen].applicationFrame);
            self.scoreYPos.constant = 216;
            if (width > 500) { //4" screen
                self.knowButtonXPos.constant = 380;
                self.dontKnowButtonXPos.constant = 380;
                
                self.knowButtonYPos.constant = 56;
                self.dontKnowButtonYPos.constant = 130;
                
                self.cardXPos.constant = 55;
                self.cardYPos.constant = 32;
                
                self.scoreXPos.constant = 80;
            } else {
                self.knowButtonXPos.constant = 330;
                self.dontKnowButtonXPos.constant = 330;
                
                self.knowButtonYPos.constant = 56;
                self.dontKnowButtonYPos.constant = 130;
                
                self.cardXPos.constant = 5;
                self.cardYPos.constant = 32;
                
                self.scoreXPos.constant = 30;
            }
            
        } else {
            height = CGRectGetHeight([UIScreen mainScreen].applicationFrame);
            if (height > 500) {
                self.knowButtonXPos.constant = 20;
                self.dontKnowButtonXPos.constant = 175;
                
                self.knowButtonYPos.constant = 307;
                self.dontKnowButtonYPos.constant = 307;
                
                self.cardXPos.constant = 5;
                self.cardYPos.constant = 82;
                
                self.scoreXPos.constant = 30;
                self.scoreYPos.constant = 387;
            } else {
                self.knowButtonXPos.constant = 20;
                self.dontKnowButtonXPos.constant = 175;
                
                self.knowButtonYPos.constant = 277;
                self.dontKnowButtonYPos.constant = 277;
                
                self.cardXPos.constant = 5;
                self.cardYPos.constant = 52;
                
                self.scoreXPos.constant = 30;
                self.scoreYPos.constant = 357;
            }
        }
    }
    [WQUtils renderCardShadow:self.frontView];
    [WQUtils renderCardShadow:self.backView];
}


- (void) start {
	[self.questionCountButton setTitle:[@([self.quiz questionCount]) stringValue] forState:UIControlStateNormal];
	[self.answerCountButton setTitle:@"" forState:UIControlStateNormal];
	[self.correctCountButton setTitle:@"" forState:UIControlStateNormal];
	[self.errorCountButton setTitle:@"" forState:UIControlStateNormal];
    self.slideToTheRight = false;
    self.frontView.hidden = false;
    self.backView.hidden = true;
	self.knowButton.enabled = YES;
	self.dontKnowButton.enabled = YES;
	self.errorCountButton.enabled = NO;
    self.animationImage = nil;
    m_animationLayer.contents = nil;
	[self updateCard];
}

- (void) restart {
	[self.quiz activateBaseList];
	[self start];
}


- (void) slotCheck {
	//[self updateCard];
	//self.flipNeeded = YES;
}

- (void) keepDiscardCard:(bool)keep
{
	if (!keep) {
		NSLog(@"Tapped Know Button");
		[self.quiz countIncrement:1];
		//todo add notifications
	}
	else {
		NSLog(@"Tapped Do Not Know Button");
		[self.quiz countIncrement:-1];
		[self.quiz checkAnswer:@""];
		//todo add notifications
	}

    self.slideToTheRight = !keep;
    [self flipCard:true];
    
	[self.answerCountButton setTitle:[@([self.quiz correctCount] + [self.quiz errorCount]) stringValue] forState:UIControlStateNormal];
	[self.correctCountButton setTitle:[@([self.quiz correctCount]) stringValue] forState:UIControlStateNormal];
	[self.errorCountButton setTitle:[@([self.quiz errorCount]) stringValue] forState:UIControlStateNormal];
	[self.quiz toNext];
	if ([self.quiz atEnd]) {
		[self.quiz finish];
		self.errorCountButton.enabled = [self.quiz hasErrors];
		self.frontIdentifierLabel.text = @"Summary";
		self.frontText.text = @"";

		self.knowButton.enabled = NO;
		self.dontKnowButton.enabled = NO;
	}
}

- (IBAction) doKnowButton {
    [self keepDiscardCard:false];
}

- (IBAction) doDontKnowButton {
	[self keepDiscardCard:true];
}

- (IBAction) doRestart {
	[self restart];
}

- (IBAction) doRepeat {
	self.errorCountButton.enabled = NO;
	[self.quiz activateErrorList];
	[self start];
}

- (void) flipCard:(BOOL)withSlide {
    BOOL shouldOnlySlide = withSlide & (self.backView.isHidden);
    
    if (shouldOnlySlide) {
        [self slideCard];
    } else {
        BOOL showFront = self.frontView.isHidden;

        [UIView transitionFromView:(showFront ? self.backView : self.frontView)
                            toView:(showFront ? self.frontView : self.backView)
                          duration:kTransitionDuration
                           options:(showFront ? 
                                    UIViewAnimationOptionTransitionFlipFromLeft :
                                    UIViewAnimationOptionTransitionFlipFromRight) | UIViewAnimationOptionShowHideTransitionViews
                        completion:^(BOOL finished) {
                                    if (finished) {
                                        if (withSlide) {
                                            [self slideCard];
                                        }
                                    }
                                }
         ];
	}
}

- (void) updateCard {
    if (![self.quiz atEnd]) {
        self.frontIdentifierLabel.text = [self.quiz langQuestion];
        self.frontText.text = [self.quiz question];
        self.backIdentifierLabel.text = [self.quiz langAnswer];
        self.backText.text = [self.quiz answer];
    }
    
}



- (void) slideCard {
    CGFloat deltaX = 0.0;
    CGFloat deltaY = 0.0;   
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (!self.slideToTheRight) {
            if (([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeLeft) ||
                ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeRight)) {
                deltaY = 400;
            } else {
                deltaX = 600;
            }
        } else {
            deltaX = -400;
        }
    }

   if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
       deltaX = (self.slideToTheRight ? -800 : 800);
   }

    UIGraphicsBeginImageContext(self.containerView.frame.size);
    [self.containerView.layer renderInContext:UIGraphicsGetCurrentContext()];
    self.animationImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(self.animationImage.size);
    [self.animationImage drawAtPoint:CGPointMake(0, 0)]; // handy!

    m_animationLayer.bounds = CGRectMake(0, 0, self.animationImage.size.width, self.animationImage.size.height);
    CGPoint point = CGPointMake(self.containerView.layer.position.x - self.containerView.frame.origin.x, self.containerView.layer.position.y - self.containerView.frame.origin.y);
    m_animationLayer.position =  point;
    m_animationLayer.contentsScale = self.view.layer.contentsScale; // for retina compat. Make sure you've set you view's main layer
    m_animationLayer.contents = (id)UIGraphicsGetImageFromCurrentImageContext().CGImage;
    m_animationLayer.opacity = 1.0;
    UIGraphicsEndImageContext();
    
    // Prepare the animation from the current position to the new position
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.fromValue = [m_animationLayer valueForKey:@"position"];
    animation.toValue = [NSValue valueWithCGPoint:CGPointMake(point.x + deltaX, point.y + deltaY)];
    
    // Update the layer's position so that the layer doesn't snap back when the animation completes.
    m_animationLayer.position = CGPointMake(point.x + deltaX, point.y + deltaY);
    animation.duration = kTransitionDuration;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.delegate = self;
    // Add the animation, overriding the implicit animation.
    [m_animationLayer addAnimation:animation forKey:@"position"];
}


- (void)animationDidStart:(CAAnimation *)theAnimation {
    NSLog(@"Animation delegate");
    [self updateCard];
}

- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    self.animationImage = nil;
    m_animationLayer.contents = nil;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

@end
