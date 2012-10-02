//
//  MCViewController.m
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

#import "MCViewController.h"
#import "WQUtils.h"
#import "JMWhenTapped.h"
#import <QuartzCore/QuartzCore.h>

@implementation MCViewController

@synthesize quiz = m_quiz;
@synthesize questionIdentifierLabel, answerIdentifierLabel, questionLabel;
@synthesize opt1Button, opt2Button, opt3Button;
@synthesize questionCountButton, answerCountButton, correctCountButton, errorCountButton;
@synthesize previousQuestionHeaderLabel, previousQuestionLabel, yourAnswerHeaderLabel, yourAnswerLabel, correctAnswerHeaderLabel, correactAnswerLabel;
@synthesize questionLine, answerLine, previousQuestionLine, yourAnswerLine, correctAnswerLine;
@synthesize questionView, previousView;
@synthesize badgeQuestionCount;
@synthesize badgeAnswerCount;
@synthesize badgeCorrectCount;
@synthesize badgeErrorCount;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
	answerIdentifierLabel.text = @"";
	opt1Button.hidden = YES;
	opt2Button.hidden = YES;
	opt3Button.hidden = YES;
    m_optionButtons = @[opt1Button, opt2Button, opt3Button];
    
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
    
	previousQuestionHeaderLabel.text = @"";
	previousQuestionLabel.text = @"";
	yourAnswerHeaderLabel.text = @"";
	yourAnswerLabel.text = @"";
	correctAnswerHeaderLabel.text = @"";
	correactAnswerLabel.text = @"";
	previousQuestionLine.hidden =YES;
	yourAnswerLine.hidden = YES;
	correctAnswerLine.hidden = YES;
	
	self.errorCountButton.enabled = NO;
    self.badgeErrorCount.userInteractionEnabled = NO;
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
             self.questionView.frame = CGRectMake(35, 35, 505, 310);
             self.previousView.frame = CGRectMake(41, 315, 505, 310);
             
             questionCountButton.frame = CGRectMake(580, 45, 104, 100);
             answerCountButton.frame = CGRectMake(580, 175, 104, 100);
             correctCountButton.frame = CGRectMake(580, 305, 104, 100);
             errorCountButton.frame = CGRectMake(580, 440, 104, 100);
             
         } else {
             self.questionView.frame = CGRectMake(137, 75, 505, 310);
             self.previousView.frame = CGRectMake(146, 368, 505, 310);
             
             questionCountButton.frame = CGRectMake(134, 760, 104, 100);
             answerCountButton.frame = CGRectMake(266, 760, 104, 100);
             correctCountButton.frame = CGRectMake(398, 760, 104, 100);
             errorCountButton.frame = CGRectMake(530, 760, 104, 100);
         }
     }
     if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
         if ((toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)) {
             int width = CGRectGetHeight([UIScreen mainScreen].applicationFrame);
             self.questionView.frame = CGRectMake(15, 15, 290, 190 );
     
             if (width > 500) {
                 badgeQuestionCount.frame = CGRectMake(410, 5, 50, 50);
                 badgeAnswerCount.frame = CGRectMake(410, 60, 50, 50);
                 badgeCorrectCount.frame = CGRectMake(410, 115, 50, 50);
                 badgeErrorCount.frame = CGRectMake(410, 170, 50, 50);

             } else {
                 badgeQuestionCount.frame = CGRectMake(365, 5, 50, 50);
                 badgeAnswerCount.frame = CGRectMake(365, 60, 50, 50);
                 badgeCorrectCount.frame = CGRectMake(365, 115, 50, 50);
                 badgeErrorCount.frame = CGRectMake(365, 170, 50, 50);
             }

         } else {
             self.questionView.frame = CGRectMake(15, 15, 290, 190);
        
             badgeQuestionCount.frame = CGRectMake(20, 300, 50, 50);
             badgeAnswerCount.frame = CGRectMake(90, 300, 50, 50);
             badgeCorrectCount.frame = CGRectMake(170, 300, 50, 50);
             badgeErrorCount.frame = CGRectMake(240, 300, 50, 50);

         }
     }
     
     [WQUtils renderCardShadow:previousView];
     [WQUtils renderCardShadow:questionView];
 }
 

- (void) start {
	[questionCountButton setTitle:[@([self.quiz questionCount]) stringValue] forState:UIControlStateNormal];
	[answerCountButton setTitle:@"" forState:UIControlStateNormal];
	[correctCountButton setTitle:@"" forState:UIControlStateNormal];
	[errorCountButton setTitle:@"" forState:UIControlStateNormal];
    badgeQuestionCount.value = self.quiz.questionCount;
    badgeAnswerCount.value = 0;
    badgeCorrectCount.value = 0;
    badgeErrorCount.value = 0;
	previousQuestionHeaderLabel.text = @"";
	previousQuestionLabel.text = @"";
	yourAnswerHeaderLabel.text = @"";
	yourAnswerLabel.text = @"";
	correctAnswerHeaderLabel.text = @"";
	correactAnswerLabel.text = @"";
	previousQuestionLine.hidden =YES;
	yourAnswerLine.hidden = YES;
	correctAnswerLine.hidden = YES;
    errorCountButton.enabled = NO;
    badgeErrorCount.userInteractionEnabled = NO;
	[self showQuestion];
}

- (void) restart {
	[self.quiz activateBaseList];
	[self start];
}

- (void) showQuestion {
	questionIdentifierLabel.text = [self.quiz langQuestion];
	questionLabel.text = [self.quiz question];
	answerIdentifierLabel.text = [self.quiz langAnswer];
	opt1Button.hidden = NO;
	opt2Button.hidden = NO;
	opt3Button.hidden = NO;
	answerLine.hidden = NO;
	
	NSArray *options = [m_quiz multiOptions];
	[opt1Button setTitle:[options objectAtIndex:0] forState:UIControlStateNormal];
	[opt2Button setTitle:[options objectAtIndex:1] forState:UIControlStateNormal];
	[opt3Button setTitle:[options objectAtIndex:2] forState:UIControlStateNormal];
}

- (void) slotCheck {

}

- (IBAction) doChoice:(id)sender {
	NSString *ans = @"";
    int selectedButtonIndex = [m_optionButtons indexOfObject:sender];
	UIButton *selectedButton = [m_optionButtons objectAtIndex:selectedButtonIndex];
    ans = selectedButton.currentTitle;

	bool fIsCorrect = [m_quiz checkAnswer:ans];
	
	if (fIsCorrect)	{
		correctAnswerHeaderLabel.text = @"";
		correactAnswerLabel.text = @"";
		correctAnswerLine.hidden = YES;
		[self.quiz countIncrement:1];
	} else {
		correctAnswerHeaderLabel.text = @"Correct Answer";
		correactAnswerLabel.text = [m_quiz answer];
		correctAnswerLine.hidden = NO;
		[self.quiz countIncrement:-1];
	}
	previousQuestionHeaderLabel.text = @"Previous Question";
	previousQuestionLabel.text = [m_quiz question];
	yourAnswerHeaderLabel.text = @"Your Answer";
	yourAnswerLabel.text = ans;
	previousQuestionLine.hidden =NO;
	yourAnswerLine.hidden = NO;
	
	[answerCountButton setTitle:[@([self.quiz correctCount] + [self.quiz errorCount]) stringValue] forState:UIControlStateNormal];
	[correctCountButton setTitle:[@([self.quiz correctCount]) stringValue] forState:UIControlStateNormal];
	[errorCountButton setTitle:[@([self.quiz errorCount]) stringValue] forState:UIControlStateNormal];
	badgeAnswerCount.value = [self.quiz correctCount] + [self.quiz errorCount];
    badgeCorrectCount.value = [self.quiz correctCount];
    badgeErrorCount.value = [self.quiz errorCount];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        UIButton *btn = (UIButton*)sender;
        [self animate:btn.titleLabel error:!fIsCorrect];
        if (!fIsCorrect) {
            BOOL correct = false;
            int currentIndex = 0;
            UIButton *currentButton;
            while (!correct) {
                currentButton = [m_optionButtons objectAtIndex:currentIndex];
                if ([currentButton.currentTitle isEqualToString:[m_quiz answer]]) {
                    [self animate:currentButton.titleLabel error:false];
                    correct = true;
                }
                ++currentIndex;
            }
        }
    }
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        [m_quiz toNext];
        if (![m_quiz atEnd]) {
            [self showQuestion];
        } else {
            [m_quiz finish];
            self.errorCountButton.enabled = [self.quiz hasErrors];
            [badgeErrorCount setUserInteractionEnabled:[self.quiz hasErrors]];
            questionIdentifierLabel.text = @"Summary";
            questionLabel.text = @"";
            answerIdentifierLabel.text = @"";
            opt1Button.hidden = YES;
            opt2Button.hidden = YES;
            opt3Button.hidden = YES;
            answerLine.hidden = YES;
        }
	}
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
        clear = [UIColor colorWithRed:1.0 green:0.39 blue:0.39 alpha:0.0];
        opaque = [UIColor colorWithRed:1.0 green:0.39 blue:0.39 alpha:1.0]; 
    } else {
        clear = [UIColor colorWithRed:0.39 green:1.0 blue:0.39 alpha:0.0];
        opaque = [UIColor colorWithRed:0.39 green:1.0 blue:0.39 alpha:1.0];
    }
    
    
    
    // Rounded corners.
    aLabel.layer.cornerRadius = 6;

    // Drop shadow.
    aLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    aLabel.layer.shadowOpacity = 0.0;
    aLabel.layer.shadowRadius = 1.0;
    aLabel.layer.shadowOffset = CGSizeMake(0, 1);
	aLabel.layer.masksToBounds = NO;
    aLabel.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:aLabel.bounds cornerRadius:6].CGPath;   
    
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
    [opt1Button.titleLabel.layer removeAllAnimations];
    [opt2Button.titleLabel.layer removeAllAnimations];
    [opt3Button.titleLabel.layer removeAllAnimations];
    [m_quiz toNext];
    if (![m_quiz atEnd]) {
        [self showQuestion];
    } else {
        [m_quiz finish];
        self.errorCountButton.enabled = [self.quiz hasErrors];
        [badgeErrorCount setUserInteractionEnabled:[self.quiz hasErrors]];
        questionIdentifierLabel.text = @"Summary";
        questionLabel.text = @"";
        answerIdentifierLabel.text = @"";
        opt1Button.hidden = YES;
        opt2Button.hidden = YES;
        opt3Button.hidden = YES;
        answerLine.hidden = YES;
    }
}

@end
