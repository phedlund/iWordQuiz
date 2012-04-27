//
//  FCViewController.m
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

#import "FCViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "WQUtils.h"
#import "JMWhenTapped.h"

#define kCardHeight		    422.0
#define kCardWidth			663.0
#define kTransitionDuration	0.50
#define kTopPlacement		55.0	// y coord for the images

@implementation FCViewController

@synthesize quiz = m_quiz;
@synthesize slideToTheRight;

@synthesize frontIdentifierLabel;
@synthesize backIdentifierLabel;
@synthesize frontText;
@synthesize backText;
@synthesize questionCountButton, answerCountButton, correctCountButton, errorCountButton;
@synthesize knowButton, dontKnowButton;
@synthesize containerView, previousView, frontView, backView;
@synthesize badgeQuestionCount;
@synthesize badgeAnswerCount;
@synthesize badgeCorrectCount;
@synthesize badgeErrorCount;
@synthesize animationImage;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
	
	frontView.userInteractionEnabled = YES;
    backView.hidden = true;
    [frontView whenTapped:^{
		[self flipCard:false];
	}];
    [backView whenTapped:^{
		[self flipCard:false];
	}];
	/*UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
	tgr.delegate = self;
	tgr.numberOfTapsRequired = 1;
	[frontView addGestureRecognizer:tgr];
	[tgr release];
    
    UITapGestureRecognizer *tgr2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
	tgr2.delegate = self;
	tgr2.numberOfTapsRequired = 1;
    [backView addGestureRecognizer:tgr2];
	[tgr2 release];*/
	
	[questionCountButton setTitle:@"" forState:UIControlStateNormal];
	[answerCountButton setTitle:@"" forState:UIControlStateNormal];
	[correctCountButton setTitle:@"" forState:UIControlStateNormal];
	[errorCountButton setTitle:@"" forState:UIControlStateNormal];
    
    questionCountButton.stickyColor = kBlue;
    answerCountButton.stickyColor = kYellow;
    correctCountButton.stickyColor = kGreen;
    errorCountButton.stickyColor = kRed;
    
    badgeQuestionCount.fillColor = [UIColor blueColor];
    badgeAnswerCount.fillColor = [UIColor colorWithRed:0.95 green:0.76 blue:0.21 alpha:1.0];
    badgeCorrectCount.fillColor = [UIColor greenColor];
    badgeErrorCount.fillColor = [UIColor redColor];
    [badgeQuestionCount whenTapped:^{
		[self doRestart];
	}];
    [badgeErrorCount whenTapped:^{
		[self doRepeat];
	}];
    
    m_animationLayer = [CALayer layer];
    m_animationLayer.bounds = containerView.layer.bounds;
    [containerView.layer addSublayer:m_animationLayer];
    
	knowButton.enabled = NO;
	dontKnowButton.enabled = NO;
	self.errorCountButton.enabled = NO;
    [badgeErrorCount setUserInteractionEnabled:NO];
    [self willRotateToInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation duration:0];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if ((toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)) {
            self.containerView.frame = CGRectMake(20, 20, 535, 340);
            self.previousView.frame = CGRectMake(41, 315, 505, 310);
            
            questionCountButton.frame = CGRectMake(580, 45, 104, 100);
            answerCountButton.frame = CGRectMake(580, 175, 104, 100);
            correctCountButton.frame = CGRectMake(580, 305, 104, 100);
            errorCountButton.frame = CGRectMake(580, 440, 104, 100);
            
        } else {
            self.containerView.frame = CGRectMake(122, 60, 535, 340);
            self.previousView.frame = CGRectMake(146, 368, 505, 310);
            
            questionCountButton.frame = CGRectMake(134, 760, 104, 100);
            answerCountButton.frame = CGRectMake(266, 760, 104, 100);
            correctCountButton.frame = CGRectMake(398, 760, 104, 100);
            errorCountButton.frame = CGRectMake(530, 760, 104, 100);
        }
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if ((toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)) {
            self.containerView.frame = CGRectMake(5, 15, 310, 185);
            
            knowButton.frame = CGRectMake(330, 25, 125, 56);
            dontKnowButton.frame = CGRectMake(330, 80, 125, 56);
            
            badgeQuestionCount.frame = CGRectMake(330, 130, 50, 50);
            badgeAnswerCount.frame = CGRectMake(400, 130, 50, 50);
            badgeCorrectCount.frame = CGRectMake(330, 170, 50, 50);
            badgeErrorCount.frame = CGRectMake(400, 170, 50, 50);
            
        } else {
            self.containerView.frame = CGRectMake(5, 5, 310, 185);
            
            knowButton.frame = CGRectMake(20, 225, 125, 56);
            dontKnowButton.frame = CGRectMake(175, 225, 125, 56);
            
            badgeQuestionCount.frame = CGRectMake(20, 300, 50, 50);
            badgeAnswerCount.frame = CGRectMake(90, 300, 50, 50);
            badgeCorrectCount.frame = CGRectMake(170, 300, 50, 50);
            badgeErrorCount.frame = CGRectMake(240, 300, 50, 50);
        }
    }
    [WQUtils renderCardShadow:previousView];
    [WQUtils renderCardShadow:frontView];
    [WQUtils renderCardShadow:backView];
}


- (void) start {
	[questionCountButton setTitle:[[NSNumber numberWithInt:[self.quiz questionCount]] stringValue] forState:UIControlStateNormal];
	[answerCountButton setTitle:@"" forState:UIControlStateNormal];
	[correctCountButton setTitle:@"" forState:UIControlStateNormal];
	[errorCountButton setTitle:@"" forState:UIControlStateNormal];
    badgeQuestionCount.value = self.quiz.questionCount;
    badgeAnswerCount.value = 0;
    badgeCorrectCount.value = 0;
    badgeErrorCount.value = 0;
    self.slideToTheRight = false;
    self.frontView.hidden = false;
    self.backView.hidden = true;
	self.knowButton.enabled = YES;
	self.dontKnowButton.enabled = YES;
	self.errorCountButton.enabled = NO;
    [badgeErrorCount setUserInteractionEnabled:NO];
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
    
	[answerCountButton setTitle:[[NSNumber numberWithInt:([self.quiz correctCount] + [self.quiz errorCount])] stringValue] forState:UIControlStateNormal];
	[correctCountButton setTitle:[[NSNumber numberWithInt:[self.quiz correctCount]] stringValue] forState:UIControlStateNormal];
	[errorCountButton setTitle:[[NSNumber numberWithInt:[self.quiz errorCount]] stringValue] forState:UIControlStateNormal];
	badgeAnswerCount.value = [self.quiz correctCount] + [self.quiz errorCount];
    badgeCorrectCount.value = [self.quiz correctCount];
    badgeErrorCount.value = [self.quiz errorCount];
	[self.quiz toNext];
	if ([self.quiz atEnd]) {
		[self.quiz finish];
		self.errorCountButton.enabled = [self.quiz hasErrors];
        [badgeErrorCount setUserInteractionEnabled:[self.quiz hasErrors]];
		frontIdentifierLabel.text = @"Summary";
		frontText.text = @"";

		knowButton.enabled = NO;
		dontKnowButton.enabled = NO;
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
    [badgeErrorCount setUserInteractionEnabled:NO];
	[self.quiz activateErrorList];
	[self start];
}

- (void) flipCard:(BOOL)withSlide {
    BOOL shouldOnlySlide = withSlide & (backView.isHidden);
    
    if (shouldOnlySlide) {
        [self slideCard];
    } else {
        BOOL showFront = frontView.isHidden;

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
        frontIdentifierLabel.text = [self.quiz langQuestion];
        frontText.text = [self.quiz question];
        backIdentifierLabel.text = [self.quiz langAnswer];
        backText.text = [self.quiz answer];
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

    UIGraphicsBeginImageContext(containerView.frame.size);
    [containerView.layer renderInContext:UIGraphicsGetCurrentContext()];
    self.animationImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContext(self.animationImage.size);
    [self.animationImage drawAtPoint:CGPointMake(0, 0)]; // handy!

    m_animationLayer.bounds = CGRectMake(0, 0, self.animationImage.size.width, self.animationImage.size.height);
    CGPoint point = CGPointMake(containerView.layer.position.x - containerView.frame.origin.x, containerView.layer.position.y - containerView.frame.origin.y);
    m_animationLayer.position =  point;
    m_animationLayer.contentsScale = self.view.layer.contentsScale; // for retina compat. Make sure you've set you view's main layer
    m_animationLayer.contents = (__bridge id)UIGraphicsGetImageFromCurrentImageContext().CGImage;
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


- (void)dealloc {
    [super dealloc];
}

@end
