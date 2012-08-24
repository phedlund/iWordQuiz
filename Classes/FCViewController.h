//
//  FCViewController.h
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

#import <UIKit/UIKit.h>
#import "WQQuiz.h"
#import "WQScoreButton.h"
#import "MKNumberBadgeView.h"

@interface FCViewController : UIViewController <UIGestureRecognizerDelegate> {

	WQQuiz * m_quiz;
    bool slideToTheRight;
	
	UILabel *frontIdentifierLabel;
    UILabel *backIdentifierLabel;
	UITextView *frontText;
    UITextView *backText;
	
	WQScoreButton *questionCountButton;
	WQScoreButton *answerCountButton;
	WQScoreButton *correctCountButton;
	WQScoreButton *errorCountButton;
	
	UIButton *knowButton;
	UIButton *dontKnowButton;
	
	UIView *containerView;
	UIView *previousView;
	UIView *frontView;
    UIView *backView;
    
    CALayer *m_animationLayer;
    UIImage *animationImage;
}

- (void) start;
- (void) restart;
- (void) slotCheck;
- (void) keepDiscardCard:(bool)keep;

- (void) flipCard:(BOOL)withSlide;
- (void) updateCard;
- (void) slideCard;

@property (nonatomic, strong) WQQuiz *quiz;
@property (nonatomic, assign) bool slideToTheRight;

@property (nonatomic, strong) IBOutlet UILabel *frontIdentifierLabel;
@property (nonatomic, strong) IBOutlet UILabel *backIdentifierLabel;
@property (nonatomic, strong) IBOutlet UITextView *frontText;
@property (nonatomic, strong) IBOutlet UITextView *backText;

@property (nonatomic, strong) IBOutlet WQScoreButton *questionCountButton;
@property (nonatomic, strong) IBOutlet WQScoreButton *answerCountButton;
@property (nonatomic, strong) IBOutlet WQScoreButton *correctCountButton;
@property (nonatomic, strong) IBOutlet WQScoreButton *errorCountButton;

@property (strong) IBOutlet MKNumberBadgeView* badgeQuestionCount;
@property (strong) IBOutlet MKNumberBadgeView* badgeAnswerCount;
@property (strong) IBOutlet MKNumberBadgeView* badgeCorrectCount;
@property (strong) IBOutlet MKNumberBadgeView* badgeErrorCount;

@property (nonatomic, strong) IBOutlet UIButton *knowButton;
@property (nonatomic, strong) IBOutlet UIButton *dontKnowButton;

@property (nonatomic, strong) IBOutlet UIView *containerView;
@property (nonatomic, strong) IBOutlet UIView *previousView;
@property (nonatomic, strong) IBOutlet UIView *frontView;
@property (nonatomic, strong) IBOutlet UIView *backView;

@property (nonatomic, strong) UIImage *animationImage;

- (IBAction) doKnowButton;
- (IBAction) doDontKnowButton;
- (IBAction) doRestart;
- (IBAction) doRepeat;

@end
