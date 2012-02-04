//
//  HomeViewController.m
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

#import "HomeViewController.h"
#import "WordQuizAppDelegate.h"

@implementation HomeViewController

@synthesize quiz = m_quiz;
@synthesize identifierLabel, frontText;
@synthesize containerView, previousView, frontView, backView, scoreView;

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
	
	UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
	tgr.delegate = self;
	tgr.numberOfTapsRequired = 1;
	[scoreView addGestureRecognizer:tgr];
	[tgr release];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
	if ((toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft) || (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)) {
		self.containerView.frame = CGRectMake(92, 40, 535, 340);
		self.previousView.frame = CGRectMake(96, 46, 535, 340);
		self.scoreView.frame = CGRectMake(235, 410, 238, 200);
		
	} else {
		self.containerView.frame = CGRectMake(122, 65, 535, 340);
		self.previousView.frame = CGRectMake(126, 71, 535, 340);
		self.scoreView.frame = CGRectMake(260, 610, 238, 200);
	}
}

- (void) start {
	identifierLabel.text = self.quiz.fileName;
	NSNumber *number = [NSNumber numberWithInt:[self.quiz.entries count]];
	frontText.text = [NSString stringWithFormat:@"Front:\t%1@\nBack:\t%2@\nEntries:\t%3@", self.quiz.frontIdentifier, self.quiz.backIdentifier, number];
	[self slotCheck];
}

- (void) restart {
	[self.quiz activateBaseList];
	[self start];
}

- (void) slotCheck {
	//Do nothing
}

- (void) handleTap:(UITapGestureRecognizer *)tapGestureRecognizer {
	// Create the modal view controller
	AboutViewController *aboutController = [[AboutViewController alloc] initWithNibName:@"AboutView" bundle:nil];
	
	// We are the delegate responsible for dismissing the modal view
	aboutController.delegate = ((iWordQuizAppDelegate *)[[UIApplication sharedApplication] delegate]);
	
	// Create a Navigation controller
	UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:aboutController];
	navController.modalPresentationStyle = UIModalPresentationFormSheet;
	
	// show the navigation controller modally
	[((iWordQuizAppDelegate *)[[UIApplication sharedApplication] delegate]).splitViewController presentModalViewController:navController animated:YES];
	
	// Clean up resources
	[navController release];
	[aboutController release];
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
