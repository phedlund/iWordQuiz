//
//  WQEditViewController.m
//  iWordQuiz
//
//  Created by Peter Hedlund on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

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
