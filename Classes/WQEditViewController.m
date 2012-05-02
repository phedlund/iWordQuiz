//
//  WQEditViewController.m
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

#import "WQEditViewController.h"

@interface WQEditViewController ()

@end

@implementation WQEditViewController

@synthesize backIdentifierLabel = _backIdentifierLabel;
@synthesize backTextField = _backTextField;
@synthesize frontIdentifierLabel = _frontIdentifierLabel;
@synthesize frontTextField = _frontTextField;
@synthesize addButton = _addButton;
@synthesize removeButton = _removeButton;
@synthesize previousButton = _previousButton;
@synthesize nextButton = _nextButton;
@synthesize delegate = _delegate;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background.png"]];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}


- (IBAction) doNext {
    if (self.delegate && [self.delegate respondsToSelector:@selector(currentEntryDidChange: reason:)])
        [self.delegate currentEntryDidChange:self reason:kNext];
}

- (IBAction) doPrevious {
    if (self.delegate && [self.delegate respondsToSelector:@selector(currentEntryDidChange: reason:)])
        [self.delegate currentEntryDidChange:self reason:kPrevious];
}

- (IBAction) doAdd {
    if (self.delegate && [self.delegate respondsToSelector:@selector(currentEntryDidChange: reason:)])
        [self.delegate currentEntryDidChange:self reason:kAdd];
}

- (IBAction) doRemove {
    if (self.delegate && [self.delegate respondsToSelector:@selector(currentEntryDidChange: reason:)])
        [self.delegate currentEntryDidChange:self reason:kRemove];
}

- (IBAction) dismissView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(currentEntryDidChange: reason:)])
        [self.delegate currentEntryDidChange:self reason:kDone];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
