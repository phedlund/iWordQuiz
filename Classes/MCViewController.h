//
//  MCViewController.h
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

#import "iWQQuiz.h"

@interface MCViewController : UIViewController {
	iWQQuiz * m_quiz;
	
	UILabel *questionIdentifierLabel;
	UILabel *answerIdentifierLabel;
	UILabel *questionLabel;
	
	UIButton *opt1Button;
	UIButton *opt2Button;
	UIButton *opt3Button;
	
	UIButton *questionCountButton;
	UIButton *answerCountButton;
	UIButton *correctCountButton;
	UIButton *errorCountButton;
	
	UILabel *previousQuestionHeaderLabel;
	UILabel *previousQuestionLabel;
	UILabel *yourAnswerHeaderLabel;
	UILabel *yourAnswerLabel;
	UILabel *correctAnswerHeaderLabel;
	UILabel *correactAnswerLabel;
	
	UIView * questionLine;
    UIView * answerLine;
	UIView * previousQuestionLine;
	UIView * yourAnswerLine;
	UIView * correctAnswerLine;
	
	UIView *questionView;
	UIView *previousView;
}

- (void) start;
- (void) restart;
- (void) slotCheck;
- (void) showQuestion;

@property (nonatomic, retain) iWQQuiz *quiz;

@property (nonatomic, retain) IBOutlet UILabel *questionIdentifierLabel;
@property (nonatomic, retain) IBOutlet UILabel *answerIdentifierLabel;
@property (nonatomic, retain) IBOutlet UILabel *questionLabel;

@property (nonatomic, retain) IBOutlet UIButton *opt1Button;
@property (nonatomic, retain) IBOutlet UIButton *opt2Button;
@property (nonatomic, retain) IBOutlet UIButton *opt3Button;

@property (nonatomic, retain) IBOutlet UIButton *questionCountButton;
@property (nonatomic, retain) IBOutlet UIButton *answerCountButton;
@property (nonatomic, retain) IBOutlet UIButton *correctCountButton;
@property (nonatomic, retain) IBOutlet UIButton *errorCountButton;

@property (nonatomic, retain) IBOutlet UILabel *previousQuestionHeaderLabel;
@property (nonatomic, retain) IBOutlet UILabel *previousQuestionLabel;
@property (nonatomic, retain) IBOutlet UILabel *yourAnswerHeaderLabel;
@property (nonatomic, retain) IBOutlet UILabel *yourAnswerLabel;
@property (nonatomic, retain) IBOutlet UILabel *correctAnswerHeaderLabel;
@property (nonatomic, retain) IBOutlet UILabel *correactAnswerLabel;

@property (nonatomic, retain) IBOutlet UIView * questionLine;
@property (nonatomic, retain) IBOutlet UIView * answerLine;
@property (nonatomic, retain) IBOutlet UIView * previousQuestionLine;
@property (nonatomic, retain) IBOutlet UIView * yourAnswerLine;
@property (nonatomic, retain) IBOutlet UIView * correctAnswerLine;

@property (nonatomic, retain) IBOutlet UIView *questionView;
@property (nonatomic, retain) IBOutlet UIView *previousView;

- (IBAction) doChoice:(id)sender;
- (IBAction) doRestart;
- (IBAction) doRepeat;

@end
