//
//  MCViewController.m
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

#import "MCViewController.h"
#import "WQUtils.h"
#import <QuartzCore/QuartzCore.h>
#import "UIColor+PHColor.h"
#import "UIFont+WQDynamic.h"

@interface MCViewController (){
    NSArray *_optionButtons;
}

@end

@implementation MCViewController

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor backgroundColor];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;

    [[NSUserDefaults standardUserDefaults] addObserver:self
                                            forKeyPath:@"ScoreAsPercent"
                                               options:NSKeyValueObservingOptionNew
                                               context:NULL];
    
    [[NSNotificationCenter defaultCenter] addObserverForName:UIContentSizeCategoryDidChangeNotification
                                                      object:nil
                                                       queue:[NSOperationQueue mainQueue]
                                                  usingBlock:^(NSNotification *notification) {
                                                      [self applyFonts];
                                                  }];
    
    [self applyFonts];
	self.answerIdentifierLabel.text = @"";
	self.opt1Button.hidden = YES;
	self.opt2Button.hidden = YES;
	self.opt3Button.hidden = YES;
    _optionButtons = @[self.opt1Button, self.opt2Button, self.opt3Button];
    
	[self.questionCountButton setTitle:@"" forState:UIControlStateNormal];
	[self.answerCountButton setTitle:@"" forState:UIControlStateNormal];
	[self.correctCountButton setTitle:@"" forState:UIControlStateNormal];
	[self.errorCountButton setTitle:@"" forState:UIControlStateNormal];

	self.previousQuestionHeaderLabel.text = @"";
	self.previousQuestionLabel.text = @"";
	self.yourAnswerHeaderLabel.text = @"";
	self.yourAnswerLabel.text = @"";
	self.correctAnswerHeaderLabel.text = @"";
	self.correctAnswerLabel.text = @"";
	self.previousQuestionLine.hidden =YES;
	self.yourAnswerLine.hidden = YES;
	self.correctAnswerLine.hidden = YES;
	
	self.errorCountButton.enabled = NO;
    [self willRotateToInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation duration:0];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}


 - (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	 [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
         if (UIInterfaceOrientationIsLandscape(toInterfaceOrientation)) {
             int width = CGRectGetHeight([UIScreen mainScreen].applicationFrame);
     
             if (width > 500) {
                 self.cardXPos.constant = 65;
                 self.cardYPos.constant = 42;
                 
                 self.questionCountXPos.constant = 440;
                 self.questionCountYPos.constant = 45;
                 
                 self.answerCountXPos.constant = 440;
                 self.answerCountYPos.constant = 95;
                 
                 self.correctCountXPos.constant = 440;
                 self.correctCountYPos.constant = 145;
                 
                 self.errorCountXPos.constant = 440;
                 self.errorCountYPos.constant = 195;
             } else {
                 self.cardXPos.constant = 15;
                 self.cardYPos.constant = 42;
                 
                 self.questionCountXPos.constant = 365;
                 self.questionCountYPos.constant = 45;
                 
                 self.answerCountXPos.constant = 365;
                 self.answerCountYPos.constant = 95;
                 
                 self.correctCountXPos.constant = 365;
                 self.correctCountYPos.constant = 145;
                 
                 self.errorCountXPos.constant = 365;
                 self.errorCountYPos.constant = 195;
             }
         } else {
             int height = CGRectGetHeight([UIScreen mainScreen].applicationFrame);
             if (height > 500) {
                 self.cardXPos.constant = 15;
                 self.cardYPos.constant = 92;
                 
                 self.questionCountXPos.constant = 30;
                 self.questionCountYPos.constant = 387;
                 
                 self.answerCountXPos.constant = 107;
                 self.answerCountYPos.constant = 387;
                 
                 self.correctCountXPos.constant = 183;
                 self.correctCountYPos.constant = 387;
                 
                 self.errorCountXPos.constant = 260;
                 self.errorCountYPos.constant = 387;
             } else {
                 self.cardXPos.constant = 15;
                 self.cardYPos.constant = 62;
                 
                 self.questionCountXPos.constant = 30;
                 self.questionCountYPos.constant = 357;
                 
                 self.answerCountXPos.constant = 107;
                 self.answerCountYPos.constant = 357;
                 
                 self.correctCountXPos.constant = 183;
                 self.correctCountYPos.constant = 357;
                 
                 self.errorCountXPos.constant = 260;
                 self.errorCountYPos.constant = 357;
             }

         }
     }
     
     [WQUtils renderCardShadow:self.previousView];
     [WQUtils renderCardShadow:self.questionView];
 }
 

- (void) start {
	[self.questionCountButton setTitle:[@([self.quiz questionCount]) stringValue] forState:UIControlStateNormal];
	[self.answerCountButton setTitle:@"" forState:UIControlStateNormal];
	[self.correctCountButton setTitle:@"" forState:UIControlStateNormal];
	[self.errorCountButton setTitle:@"" forState:UIControlStateNormal];
	self.previousQuestionHeaderLabel.text = @"";
	self.previousQuestionLabel.text = @"";
	self.yourAnswerHeaderLabel.text = @"";
	self.yourAnswerLabel.text = @"";
	self.correctAnswerHeaderLabel.text = @"";
	self.correctAnswerLabel.text = @"";
	self.previousQuestionLine.hidden =YES;
	self.yourAnswerLine.hidden = YES;
	self.correctAnswerLine.hidden = YES;
    self.errorCountButton.enabled = NO;
	[self showQuestion];
}

- (void) restart {
	[self.quiz activateBaseList];
	[self start];
}

- (void) showQuestion {
	self.questionIdentifierLabel.text = [self.quiz langQuestion];
	self.questionLabel.text = [self.quiz question];
	self.answerIdentifierLabel.text = [self.quiz langAnswer];
	self.opt1Button.hidden = NO;
	self.opt2Button.hidden = NO;
	self.opt3Button.hidden = NO;
	self.answerLine.hidden = NO;
	
	NSArray *options = [self.quiz multiOptions];
	[self.opt1Button setTitle:[options objectAtIndex:0] forState:UIControlStateNormal];
	[self.opt2Button setTitle:[options objectAtIndex:1] forState:UIControlStateNormal];
	[self.opt3Button setTitle:[options objectAtIndex:2] forState:UIControlStateNormal];
}

- (void) slotCheck {

}

- (IBAction) doChoice:(id)sender {
	NSString *ans = @"";
    //int selectedButtonIndex = [m_optionButtons indexOfObject:sender];
	//UIButton *selectedButton = [m_optionButtons objectAtIndex:selectedButtonIndex];
    //ans = selectedButton.currentTitle;
    ans = [(UIButton*)sender currentTitle];
	bool fIsCorrect = [self.quiz checkAnswer:ans];
	
	if (fIsCorrect)	{
		self.correctAnswerHeaderLabel.text = @"";
		self.correctAnswerLabel.text = @"";
		self.correctAnswerLine.hidden = YES;
		[self.quiz countIncrement:1];
	} else {
		self.correctAnswerHeaderLabel.text = @"Correct Answer";
		self.correctAnswerLabel.text = [self.quiz answer];
		self.correctAnswerLine.hidden = NO;
		[self.quiz countIncrement:-1];
	}
	self.previousQuestionHeaderLabel.text = @"Previous Question";
	self.previousQuestionLabel.text = [self.quiz question];
	self.yourAnswerHeaderLabel.text = @"Your Answer";
	self.yourAnswerLabel.text = ans;
	self.previousQuestionLine.hidden =NO;
	self.yourAnswerLine.hidden = NO;
	
	[self.answerCountButton setScore:[self.quiz correctCount] + [self.quiz errorCount] of:[self.quiz questionCount]];
	[self.correctCountButton setScore:[self.quiz correctCount] of:[self.quiz questionCount]];
	[self.errorCountButton setScore:[self.quiz errorCount] of:[self.quiz questionCount]];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        UIButton *btn = (UIButton*)sender;
        [self animate:btn.titleLabel error:!fIsCorrect];
        if (!fIsCorrect) {
            BOOL correct = false;
            int currentIndex = 0;
            UIButton *currentButton;
            while (!correct) {
                currentButton = [_optionButtons objectAtIndex:currentIndex];
                if ([currentButton.currentTitle isEqualToString:[self.quiz answer]]) {
                    [self animate:currentButton.titleLabel error:false];
                    correct = true;
                }
                ++currentIndex;
            }
        }
    }
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        [self.quiz toNext];
        if (![self.quiz atEnd]) {
            [self showQuestion];
        } else {
            [self.quiz finish];
            self.errorCountButton.enabled = [self.quiz hasErrors];
            self.questionIdentifierLabel.text = @"Summary";
            self.questionLabel.text = @"";
            self.answerIdentifierLabel.text = @"";
            self.opt1Button.hidden = YES;
            self.opt2Button.hidden = YES;
            self.opt3Button.hidden = YES;
            self.answerLine.hidden = YES;
        }
	}
}

- (IBAction) doRestart {
	[self restart];
}

- (IBAction) doRepeat {
	self.errorCountButton.enabled = NO;
	[self.quiz activateErrorList];
	[self start];
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




- (void) animate:(UILabel *)aLabel error:(BOOL) flag {
    
    UIColor *clear;
    UIColor *opaque;
    
    if (flag) {
        clear = [UIColor colorWithRed:1.0 green:0.45 blue:0.45 alpha:0.0];
        opaque = [UIColor colorWithRed:1.0 green:0.45 blue:0.45 alpha:1.0];
    } else {
        clear = [UIColor colorWithRed:0.62 green:1.0 blue:0.27 alpha:0.0];
        opaque = [UIColor colorWithRed:0.62 green:1.0 blue:0.27 alpha:1.0];
    }
    
    // Rounded corners.
    aLabel.layer.cornerRadius = 3;

    // Drop shadow.
    aLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    aLabel.layer.shadowOpacity = 0.0;
    aLabel.layer.shadowRadius = 1.0;
    aLabel.layer.shadowOffset = CGSizeMake(0, 1);
	aLabel.layer.masksToBounds = NO;
    aLabel.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:aLabel.bounds cornerRadius:3].CGPath;
    
    CGFloat duration = 0.3;
    CGFloat totalDuration = 0.0;
    CGFloat pause = 0.01;
    CGFloat start = 0;
    
    CABasicAnimation *bcolor = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    bcolor.duration = duration / 2;
    bcolor.fromValue = (id)clear.CGColor;
    bcolor.toValue = (id)opaque.CGColor;
    bcolor.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    bcolor.removedOnCompletion = NO;
    bcolor.beginTime = start;
    bcolor.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *sopacity = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    sopacity.duration = duration / 4;
    sopacity.fromValue = @0.0f;
    sopacity.toValue = @0.8f;
    sopacity.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    sopacity.removedOnCompletion = NO;
    sopacity.beginTime = start + (duration / 2);
    sopacity.fillMode = kCAFillModeForwards;
    
    start = start + (duration / 2) + .1;
    
    CABasicAnimation *pAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pAnimation.duration = duration;
    pAnimation.toValue = @1.2f;
    pAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    pAnimation.autoreverses = YES;
    pAnimation.removedOnCompletion = NO;
    pAnimation.beginTime = start;
    pAnimation.fillMode = kCAFillModeForwards;
    
    start = start + duration + 0.1;
    
    CABasicAnimation *bcolor2 = [CABasicAnimation animationWithKeyPath:@"backgroundColor"];
    bcolor2.duration = duration / 2;
    bcolor2.fromValue = (id)opaque.CGColor;
    bcolor2.toValue = (id)clear.CGColor;
    bcolor2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    bcolor2.removedOnCompletion = NO;
    bcolor2.beginTime = start;
    bcolor2.fillMode = kCAFillModeForwards;
    
    CABasicAnimation *sopacity2 = [CABasicAnimation animationWithKeyPath:@"shadowOpacity"];
    sopacity2.duration = duration / 4;
    sopacity2.fromValue = @0.8f;
    sopacity2.toValue = @0.0f;
    sopacity2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    sopacity2.removedOnCompletion = NO;
    sopacity2.beginTime = start;
    sopacity2.fillMode = kCAFillModeForwards;
    
    totalDuration = start + (duration / 2) + pause;
    //Put all the animations into a group.
    CAAnimationGroup* group = [CAAnimationGroup animation];
    [group setDuration: totalDuration];  //Set the duration of the group to the time for all animations
    group.removedOnCompletion = FALSE;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = YES;
    if (!flag) {
        group.delegate = self;
    }
    //group.delegate = self;
    [group setAnimations: @[bcolor, sopacity, pAnimation, bcolor2, sopacity2]];
    [aLabel.layer addAnimation: group forKey:  nil];
}


- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag {
    [self.opt1Button.titleLabel.layer removeAllAnimations];
    [self.opt2Button.titleLabel.layer removeAllAnimations];
    [self.opt3Button.titleLabel.layer removeAllAnimations];
    [self.quiz toNext];
    if (![self.quiz atEnd]) {
        [self showQuestion];
    } else {
        [self.quiz finish];
        self.errorCountButton.enabled = [self.quiz hasErrors];
        self.questionIdentifierLabel.text = @"Summary";
        self.questionLabel.text = @"";
        self.answerIdentifierLabel.text = @"";
        self.opt1Button.hidden = YES;
        self.opt2Button.hidden = YES;
        self.opt3Button.hidden = YES;
        self.answerLine.hidden = YES;
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"ScoreAsPercent"]) {
        [self.answerCountButton setScore:[self.quiz correctCount] + [self.quiz errorCount] of:[self.quiz questionCount]];
        [self.correctCountButton setScore:[self.quiz correctCount] of:[self.quiz questionCount]];
        [self.errorCountButton setScore:[self.quiz errorCount] of:[self.quiz questionCount]];
    }
}

- (void)applyFonts {
	self.questionIdentifierLabel.font = [UIFont preferredWQFontForTextStyle:UIFontTextStyleHeadline];
	self.questionLabel.font = [UIFont preferredWQFontForTextStyle:UIFontTextStyleBody];
    self.answerIdentifierLabel.font = [UIFont preferredWQFontForTextStyle:UIFontTextStyleHeadline];
	self.opt1Button.titleLabel.font = [UIFont preferredWQFontForTextStyle:UIFontTextStyleBody];
    self.opt2Button.titleLabel.font = [UIFont preferredWQFontForTextStyle:UIFontTextStyleBody];
    self.opt3Button.titleLabel.font = [UIFont preferredWQFontForTextStyle:UIFontTextStyleBody];
    self.previousQuestionHeaderLabel.font = [UIFont preferredWQFontForTextStyle:UIFontTextStyleHeadline];
    self.previousQuestionLabel.font = [UIFont preferredWQFontForTextStyle:UIFontTextStyleBody];
    self.yourAnswerHeaderLabel.font = [UIFont preferredWQFontForTextStyle:UIFontTextStyleHeadline];
    self.yourAnswerLabel.font = [UIFont preferredWQFontForTextStyle:UIFontTextStyleBody];
    self.correctAnswerHeaderLabel.font = [UIFont preferredWQFontForTextStyle:UIFontTextStyleHeadline];
    self.correctAnswerLabel.font = [UIFont preferredWQFontForTextStyle:UIFontTextStyleBody];
}

@end
