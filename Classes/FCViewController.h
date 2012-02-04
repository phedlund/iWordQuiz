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
#import "iWQQuiz.h"

@interface FCViewController : UIViewController <UIGestureRecognizerDelegate> {

	iWQQuiz * m_quiz;
	bool m_showFront;
	bool m_flipNeeded;
	
	UILabel *identifierLabel;
	UITextView *frontText;
	
	UIButton *questionCountButton;
	UIButton *answerCountButton;
	UIButton *correctCountButton;
	UIButton *errorCountButton;
	
	UIButton *knowButton;
	UIButton *dontKnowButton;
	
	UIView *containerView;
	UIView *line;
	UIView *previousView;
	UIImageView *frontView;
}

- (void) start;
- (void) restart;
- (void) slotCheck;
- (void) keepDiscardCard:(bool)keep;

- (void) handleTap:(UITapGestureRecognizer *)tapGestureRecognizer;

@property (nonatomic, retain) iWQQuiz *quiz;
@property (nonatomic, assign) bool showFront;
@property (nonatomic, assign) bool flipNeeded;

@property (nonatomic, retain) IBOutlet UILabel *identifierLabel;
@property (nonatomic, retain) IBOutlet UITextView *frontText;

@property (nonatomic, retain) IBOutlet UIButton *questionCountButton;
@property (nonatomic, retain) IBOutlet UIButton *answerCountButton;
@property (nonatomic, retain) IBOutlet UIButton *correctCountButton;
@property (nonatomic, retain) IBOutlet UIButton *errorCountButton;

@property (nonatomic, retain) IBOutlet UIButton *knowButton;
@property (nonatomic, retain) IBOutlet UIButton *dontKnowButton;

@property (nonatomic, retain) IBOutlet UIView *containerView;
@property (nonatomic, retain) IBOutlet UIView *line;
@property (nonatomic, retain) IBOutlet UIView *previousView;
@property (nonatomic, retain) IBOutlet UIImageView *frontView;

- (IBAction) doKnowButton;
- (IBAction) doDontKnowButton;
- (IBAction) doRestart;
- (IBAction) doRepeat;

@end
