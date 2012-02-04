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

#define kCardHeight		    422.0
#define kCardWidth			663.0
#define kTransitionDuration	0.50
#define kTopPlacement		55.0	// y coord for the images

@implementation FCViewController

@synthesize quiz = m_quiz;
@synthesize showFront = m_showFront;
@synthesize flipNeeded = m_flipNeeded;

@synthesize identifierLabel, frontText;;
@synthesize questionCountButton, answerCountButton, correctCountButton, errorCountButton;
@synthesize knowButton, dontKnowButton;
@synthesize containerView, line, previousView, frontView;


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
	
	frontView.userInteractionEnabled = YES;
	
	UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
	tgr.delegate = self;
	tgr.numberOfTapsRequired = 1;
	[frontView addGestureRecognizer:tgr];
	[tgr release];
	
	[questionCountButton setTitle:@"" forState:UIControlStateNormal];
	[answerCountButton setTitle:@"" forState:UIControlStateNormal];
	[correctCountButton setTitle:@"" forState:UIControlStateNormal];
	[errorCountButton setTitle:@"" forState:UIControlStateNormal];
	
	knowButton.enabled = NO;
	dontKnowButton.enabled = NO;
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
		self.containerView.frame = CGRectMake(20, 20, 535, 340);
		self.previousView.frame = CGRectMake(26, 300, 535, 340);
		
		questionCountButton.frame = CGRectMake(580, 45, 104, 100);
		answerCountButton.frame = CGRectMake(580, 175, 104, 100);
		correctCountButton.frame = CGRectMake(580, 305, 104, 100);
		errorCountButton.frame = CGRectMake(580, 440, 104, 100);
		
	} else {
		self.containerView.frame = CGRectMake(122, 60, 535, 340);
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
	self.showFront = true;
	self.flipNeeded = false;
	self.knowButton.enabled = YES;
	self.dontKnowButton.enabled = YES;
	self.errorCountButton.enabled = NO;
	[self slotCheck];
}

- (void) restart {
	[self.quiz activateBaseList];
	[self start];
}

- (void) slotCheck {
	[self handleTap:nil];
	self.flipNeeded = YES;
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
	if (!self.showFront) {
		self.flipNeeded = false;
	}
	self.showFront = true;
	
	[answerCountButton setTitle:[[NSNumber numberWithInt:([self.quiz correctCount] + [self.quiz errorCount])] stringValue] forState:UIControlStateNormal];
	[correctCountButton setTitle:[[NSNumber numberWithInt:[self.quiz correctCount]] stringValue] forState:UIControlStateNormal];
	[errorCountButton setTitle:[[NSNumber numberWithInt:[self.quiz errorCount]] stringValue] forState:UIControlStateNormal];
	
	[self.quiz toNext];
	if (![self.quiz atEnd]) {
		[self slotCheck];
	}
	else {
		[self.quiz finish];
		self.errorCountButton.enabled = [self.quiz hasErrors];

		identifierLabel.text = @"Summary";
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
	[self.quiz activateErrorList];
	[self start];
}

- (void) handleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
	if (self.flipNeeded) {	
		[UIView beginAnimations:nil context:NULL];
		[UIView setAnimationDuration:kTransitionDuration];
		[UIView setAnimationTransition:(self.showFront ? 
										UIViewAnimationTransitionFlipFromLeft : UIViewAnimationTransitionFlipFromRight)
							            forView:self.containerView cache:YES];
		
		[UIView commitAnimations];
	}
	
	if( self.showFront )
	{
		line.backgroundColor = [UIColor redColor]; //self.frontView.image = [UIImage imageNamed: @"front.png"];
		identifierLabel.text = [self.quiz langQuestion];
		frontText.text = [self.quiz question];
		self.showFront = false;
	}
	else
	{
		line.backgroundColor = [UIColor blueColor]; //self.frontView.image = [UIImage imageNamed: @"back.png"];
		identifierLabel.text = [self.quiz langAnswer];
		frontText.text = [self.quiz answer];
		self.showFront = true;
	}

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
