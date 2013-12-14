//
//  WQEditViewController.m
//  iWordQuiz
//

/************************************************************************
 
 Copyright 2012-2013 Peter Hedlund peter.hedlund@me.com
 
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
#import "WQNewFileViewController.h"
#import "UIColor+PHColor.h"

@interface WQEditViewController () {
    NSString *_newFileName;
}

- (void) vocabSettings:(NSNotification *)n;

@end

@implementation WQEditViewController

- (void)awakeFromNib {
    _newFileName = nil;
    self.view.backgroundColor = [UIColor backgroundColor];
    self.navigationController.navigationBar.tintColor = [UIColor iconColor];
    //self.navigationController.navigationBar.barTintColor = [UIColor backgroundColor];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor clearColor];
    shadow.shadowBlurRadius = 0.0;
    shadow.shadowOffset = CGSizeMake(0.0, 0.0);
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor iconColor], NSForegroundColorAttributeName,
      shadow, NSShadowAttributeName, nil]];
    
    self.previousButton.tintColor = [UIColor iconColor];
    self.addButton.tintColor = [UIColor iconColor];
    self.removeButton.tintColor = [UIColor iconColor];
    self.nextButton.tintColor = [UIColor iconColor];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
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
    if (self.delegate && [self.delegate respondsToSelector:@selector(currentEntryDidChange: reason: value:)])
        [self.delegate currentEntryDidChange:self reason:kNext value:nil];
}

- (IBAction) doPrevious {
    if (self.delegate && [self.delegate respondsToSelector:@selector(currentEntryDidChange: reason: value:)])
        [self.delegate currentEntryDidChange:self reason:kPrevious value:nil];
}

- (IBAction) doAdd {
    if (self.delegate && [self.delegate respondsToSelector:@selector(currentEntryDidChange: reason: value:)])
        [self.delegate currentEntryDidChange:self reason:kAdd value:nil];
}

- (IBAction) doRemove {
    if (self.delegate && [self.delegate respondsToSelector:@selector(currentEntryDidChange: reason: value:)])
        [self.delegate currentEntryDidChange:self reason:kRemove value:nil];
}

- (IBAction) dismissView {
    if (self.delegate && [self.delegate respondsToSelector:@selector(currentEntryDidChange: reason: value:)])
        [self.delegate currentEntryDidChange:self reason:kDone value:_newFileName];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"editVocabulary"]) {
        WQNewFileViewController * nfController = (WQNewFileViewController*)[segue destinationViewController];
        nfController.navigationItem.title = @"Edit Vocabulary";
        nfController.navigationItem.rightBarButtonItem = nil;
        nfController.isEditingVocabulary = YES;
        [[NSNotificationCenter defaultCenter] addObserver:nfController selector:@selector(vocabInfo:) name:@"VocabInfo" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(vocabSettings:) name:UITextFieldTextDidChangeNotification object:nil];
    
        if (self.delegate && [self.delegate respondsToSelector:@selector(currentEntryDidChange: reason: value:)])
            [self.delegate currentEntryDidChange:self reason:kGetVocabInfo value:nil];

    }
}

- (void) vocabSettings:(NSNotification *)n {
    UITextField *tf = (UITextField*)n.object;
    if (tf) {
        switch (tf.tag) {
        case 201:
                _newFileName = tf.text;
            break;
            case 202: {
                if (tf.text.length > 0) {
                    self.frontIdentifierLabel.text = tf.text;
                    if (self.delegate && [self.delegate respondsToSelector:@selector(currentEntryDidChange: reason: value:)]) {
                        [self.delegate currentEntryDidChange:self reason:kSetVocabFrontIdentifier value:tf.text];
                    }
                }
            }
                break;
            case 203: {
                if (tf.text.length > 0) {
                    self.backIdentifierLabel.text = tf.text;
                    if (self.delegate && [self.delegate respondsToSelector:@selector(currentEntryDidChange: reason: value:)]) {
                        [self.delegate currentEntryDidChange:self reason:kSetVocabBackIdentifier value:tf.text];
                    }
                }
            }
                break;
        default:
            break;
        }
    }

}

@end
