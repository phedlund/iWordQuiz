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

@implementation MCViewController

@synthesize quiz = m_quiz;
@synthesize questionIdentifierLabel, answerIdentifierLabel, questionLabel;
@synthesize opt1Button, opt2Button, opt3Button;
@synthesize questionCountButton, answerCountButton, correctCountButton, errorCountButton;
@synthesize previousQuestionHeaderLabel, previousQuestionLabel, yourAnswerHeaderLabel, yourAnswerLabel, correctAnswerHeaderLabel, correactAnswerLabel;
@synthesize questionLine, answerLine, previousQuestionLine, yourAnswerLine, correctAnswerLine;
@synthesize questionView, previousView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
	answerIdentifierLabel.text = @"";
	opt1Button.hidden = YES;
	opt2Button.hidden = YES;
	opt3Button.hidden = YES;

	[questionCountButton setTitle:@"" forState:UIControlStateNormal];
	[answerCountButton setTitle:@"" forState:UIControlStateNormal];
	[correctCountButton setTitle:@"" forState:UIControlStateNormal];
	[errorCountButton setTitle:@"" forState:UIControlStateNormal];
	
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
    [self willRotateToInterfaceOrientation:[UIApplication sharedApplication].statusBarOrientation duration:0];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return NO;
}


 - (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	 [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];

	 if ((toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)) {
		 self.questionView.frame = CGRectMake(20, 20, 535, 340);
		 self.previousView.frame = CGRectMake(26, 300, 535, 340);

		 questionCountButton.frame = CGRectMake(580, 45, 104, 100);
		 answerCountButton.frame = CGRectMake(580, 175, 104, 100);
		 correctCountButton.frame = CGRectMake(580, 305, 104, 100);
		 errorCountButton.frame = CGRectMake(580, 440, 104, 100);
 
	 } else {
		 self.questionView.frame = CGRectMake(122, 60, 535, 340);
		 self.previousView.frame = CGRectMake(126, 353, 535, 340);

		 questionCountButton.frame = CGRectMake(134, 760, 104, 100);
		 answerCountButton.frame = CGRectMake(266, 760, 104, 100);
		 correctCountButton.frame = CGRectMake(398, 760, 104, 100);
		 errorCountButton.frame = CGRectMake(530, 760, 104, 100);
	 }
 }
 

- (void) start {
	[questionCountButton setTitle:[[NSNumber numberWithInt:[self.quiz questionCount]] stringValue] forState:UIControlStateNormal];
	[answerCountButton setTitle:@"" forState:UIControlStateNormal];
	[correctCountButton setTitle:@"" forState:UIControlStateNormal];
	[errorCountButton setTitle:@"" forState:UIControlStateNormal];
	previousQuestionHeaderLabel.text = @"";
	previousQuestionLabel.text = @"";
	yourAnswerHeaderLabel.text = @"";
	yourAnswerLabel.text = @"";
	correctAnswerHeaderLabel.text = @"";
	correactAnswerLabel.text = @"";
	previousQuestionLine.hidden =YES;
	yourAnswerLine.hidden = YES;
	correctAnswerLine.hidden = YES;
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
	
	if (sender == opt1Button) {
		NSLog(@"First button");
		ans = opt1Button.currentTitle;
	}
	else if (sender == opt2Button) {
		NSLog(@"Second button");
		ans = opt2Button.currentTitle;
	}
	else if (sender == opt3Button) {
		NSLog(@"Third button");
		ans = opt3Button.currentTitle;
	}
	
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

	
	[answerCountButton setTitle:[[NSNumber numberWithInt:([self.quiz correctCount] + [self.quiz errorCount])] stringValue] forState:UIControlStateNormal];
	[correctCountButton setTitle:[[NSNumber numberWithInt:[self.quiz correctCount]] stringValue] forState:UIControlStateNormal];
	[errorCountButton setTitle:[[NSNumber numberWithInt:[self.quiz errorCount]] stringValue] forState:UIControlStateNormal];
	
	[m_quiz toNext];
	if (![m_quiz atEnd]) {
		[self showQuestion];
	} else {
		[m_quiz finish];
		self.errorCountButton.enabled = [self.quiz hasErrors];
		questionIdentifierLabel.text = @"Summary";
		questionLabel.text = @"";
		answerIdentifierLabel.text = @"";
		opt1Button.hidden = YES;
		opt2Button.hidden = YES;
		opt3Button.hidden = YES;
		answerLine.hidden = YES;
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


- (void)dealloc {
    [super dealloc];
}

@end
