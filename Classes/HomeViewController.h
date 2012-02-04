//
//  HomeViewController.h
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

@interface HomeViewController : UIViewController <UIGestureRecognizerDelegate> {

	iWQQuiz * m_quiz;
	UILabel *identifierLabel;
	UITextView *frontText;
	
	UIView *containerView;
	UIImageView *frontView;
	UIImageView *backView;
	UIImageView *scoreView;

}
- (void) start;
- (void) restart;
- (void) slotCheck;

- (void) handleTap:(UITapGestureRecognizer *)tapGestureRecognizer;

@property (nonatomic, retain) iWQQuiz *quiz;

@property (nonatomic, retain) IBOutlet UILabel *identifierLabel;
@property (nonatomic, retain) IBOutlet UITextView *frontText;
@property (nonatomic, retain) IBOutlet UIView *containerView;
@property (nonatomic, retain) IBOutlet UIView *previousView;
@property (nonatomic, retain) IBOutlet UIImageView *frontView;
@property (nonatomic, retain) IBOutlet UIImageView *backView;
@property (nonatomic, retain) IBOutlet UIImageView *scoreView;

@end
