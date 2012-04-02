//
//  QAViewController.m
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

#import "QAViewController.h"
#import "WQUtils.h"

@implementation QAViewController

@synthesize quiz = m_quiz;
@synthesize questionIdentifierLabel, answerIdentifierLabel, questionLabel;
@synthesize answerTextField;
@synthesize questionCountButton, answerCountButton, correctCountButton, errorCountButton;
@synthesize previousQuestionHeaderLabel, previousQuestionLabel, yourAnswerHeaderLabel, yourAnswerLabel, correctAnswerHeaderLabel, correactAnswerLabel;
@synthesize questionLine, answerLine, previousQuestionLine, yourAnswerLine, correctAnswerLine;
@synthesize questionView, previousView;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
	answerIdentifierLabel.text = @"";
	answerTextField.hidden = YES;
	
	[questionCountButton setTitle:@"" forState:UIControlStateNormal];
	[answerCountButton setTitle:@"" forState:UIControlStateNormal];
	[correctCountButton setTitle:@"" forState:UIControlStateNormal];
	[errorCountButton setTitle:@"" forState:UIControlStateNormal];

    questionCountButton.stickyColor = kBlue;
    answerCountButton.stickyColor = kYellow;
    correctCountButton.stickyColor = kGreen;
    errorCountButton.stickyColor = kRed;
    
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



- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return NO;
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];

	if ((toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)) {
		self.questionView.frame = CGRectMake(35, 35, 505, 310);
		self.previousView.frame = CGRectMake(41, 315, 505, 310);
		
		questionCountButton.frame = CGRectMake(580, 45, 104, 100);
		answerCountButton.frame = CGRectMake(580, 175, 104, 100);
		correctCountButton.frame = CGRectMake(580, 305, 104, 100);
		errorCountButton.frame = CGRectMake(580, 440, 104, 100);
		
	} else {
		self.questionView.frame = CGRectMake(65, 75, 505, 310);
		self.previousView.frame = CGRectMake(69, 368, 505, 310);

		questionCountButton.frame = CGRectMake(620, 85, 104, 100);
		answerCountButton.frame = CGRectMake(620, 215, 104, 100);
		correctCountButton.frame = CGRectMake(620, 345, 104, 100);
		errorCountButton.frame = CGRectMake(620, 480, 104, 100);
	}
    
    [WQUtils renderCardShadow:previousView];
    [WQUtils renderCardShadow:questionView];
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
	answerTextField.hidden = NO;
	answerTextField.text = @"";
}

- (void) slotCheck {
	NSString *ans = answerTextField.text;
	bool fIsCorrect = [m_quiz checkAnswer:ans];
	
	if (fIsCorrect)
	{
		correctAnswerHeaderLabel.text = @"";
		correactAnswerLabel.text = @"";
		correctAnswerLine.hidden = YES;
		[self.quiz countIncrement:1];
	}
	else
	{
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
		answerTextField.hidden = YES;
		answerLine.hidden = YES;
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    // When the user presses return, take focus away from the text field so that the keyboard is dismissed.
    if (theTextField == answerTextField) {
        if (UIDeviceOrientationIsLandscape([UIDevice currentDevice].orientation))
		{
			[answerTextField resignFirstResponder];
		}
		[self slotCheck];
    }
    return YES;
}

- (IBAction) doRestart {
	[self restart];
}

- (IBAction) doRepeat {
	self.errorCountButton.enabled = NO;
	[self.quiz activateErrorList];
	[self start];
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    // Dismiss the keyboard when the view outside the text field is touched.
    [answerTextField resignFirstResponder];
    // Revert the text field to the previous value.
    //textField.text = self.string; 
    [super touchesBegan:touches withEvent:event];
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
