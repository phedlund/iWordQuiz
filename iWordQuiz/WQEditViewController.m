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

@interface WQEditViewController () <UITextFieldDelegate> {
    NSString *_newFileName;
}

- (void) vocabSettings:(NSNotification *)n;

@end

@implementation WQEditViewController

@synthesize previousEntryButton;
@synthesize previousFieldButton;
@synthesize addButton;
@synthesize removeButton;
@synthesize nextFieldButton;
@synthesize nextEntryButton;

@synthesize entryToolbar;

- (void)awakeFromNib {
    [super awakeFromNib];
    _newFileName = nil;
    self.view.backgroundColor = [UIColor phBackgroundColor];
    self.navigationController.navigationBar.tintColor = [UIColor phIconColor];
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor clearColor];
    shadow.shadowBlurRadius = 0.0;
    shadow.shadowOffset = CGSizeMake(0.0, 0.0);
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor phIconColor], NSForegroundColorAttributeName,
      shadow, NSShadowAttributeName, nil]];

    self.frontTextField.delegate = self;
    self.backTextField.delegate = self;
    
    self.frontTextField.inputAccessoryView = self.entryToolbar;
    self.backTextField.inputAccessoryView = self.entryToolbar;
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor phBackgroundColor];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *result;
    if (self.delegate && [self.delegate respondsToSelector:@selector(identifierForSection:)]) {
       result = [self.delegate identifierForSection:section];
    }
    return result;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (section < 2) {
        return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 44.0f : 27.0f;
    }
    return 0.0f;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0f;
}

- (IBAction) doPreviousEntry {
    if (self.delegate && [self.delegate respondsToSelector:@selector(currentEntryDidChange: reason: value:)])
        [self.delegate currentEntryDidChange:self reason:kPrevious value:nil];
}

- (IBAction) doPreviousField {
    [self.frontTextField becomeFirstResponder];
    self.previousFieldButton.enabled = NO;
    self.nextFieldButton.enabled = YES;
}

- (IBAction) doAdd {
    if (self.delegate && [self.delegate respondsToSelector:@selector(currentEntryDidChange: reason: value:)])
        [self.delegate currentEntryDidChange:self reason:kAdd value:nil];
}

- (IBAction) doRemove {
    if (self.delegate && [self.delegate respondsToSelector:@selector(currentEntryDidChange: reason: value:)])
        [self.delegate currentEntryDidChange:self reason:kRemove value:nil];
}

- (IBAction) doNextField {
    [self.backTextField becomeFirstResponder];
    self.previousFieldButton.enabled = YES;
    self.nextFieldButton.enabled = NO;
}

- (IBAction) doNextEntry {
    if (self.delegate && [self.delegate respondsToSelector:@selector(currentEntryDidChange: reason: value:)])
        [self.delegate currentEntryDidChange:self reason:kNext value:nil];
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
                    [self.tableView reloadData];
                    if (self.delegate && [self.delegate respondsToSelector:@selector(currentEntryDidChange: reason: value:)]) {
                        [self.delegate currentEntryDidChange:self reason:kSetVocabFrontIdentifier value:tf.text];
                    }
                }
            }
                break;
            case 203: {
                if (tf.text.length > 0) {
                    [self.tableView reloadData];
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

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if ([textField isEqual:self.frontTextField]) {
        self.previousFieldButton.enabled = NO;
        self.nextFieldButton.enabled = YES;
    }
    if ([textField isEqual:self.backTextField]) {
        self.previousFieldButton.enabled = YES;
        self.nextFieldButton.enabled = NO;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField isEqual:self.frontTextField]) {
        [self doNextField];
    }
    if ([textField isEqual:self.backTextField]) {
        [self doNextEntry];
        [self doPreviousField];
    }

    return YES;
}

- (UIBarButtonItem*)previousEntryButton {
    if (!previousEntryButton) {
        previousEntryButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"up"] style:UIBarButtonItemStylePlain target:self action:@selector(doPreviousEntry)];
    }
    return previousEntryButton;
}

- (UIBarButtonItem*)previousFieldButton {
    if (!previousFieldButton) {
        previousFieldButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"back"] style:UIBarButtonItemStylePlain target:self action:@selector(doPreviousField)];
    }
    return previousFieldButton;
  
}

- (UIBarButtonItem*)addButton {
    if (!addButton) {
        addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(doAdd)];
    }
    return addButton;
 
}

- (UIBarButtonItem*)removeButton {
    if (!removeButton) {
        removeButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"minus"] style:UIBarButtonItemStylePlain target:self action:@selector(doRemove)];
    }
    return removeButton;
 
}

- (UIBarButtonItem*)nextFieldButton {
    if (!nextFieldButton) {
        nextFieldButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"forward"] style:UIBarButtonItemStylePlain target:self action:@selector(doNextField)];
    }
    return nextFieldButton;

}

- (UIBarButtonItem*)nextEntryButton {
    if (!nextEntryButton) {
        nextEntryButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"down"] style:UIBarButtonItemStylePlain target:self action:@selector(doNextEntry)];
    }
    return nextEntryButton;

}

- (UIToolbar*) entryToolbar {
    if (!entryToolbar) {
        UIBarButtonItem *fixedSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        fixedSpace.width = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 5.0f : 15.0f;

        entryToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) ? 320.0f : 400.0f, 44)];
        entryToolbar.tintColor = [UIColor phIconColor];
        entryToolbar.barStyle = UIBarStyleDefault;
        entryToolbar.items = @[self.previousEntryButton,
                               self.previousFieldButton,
                               fixedSpace,
                               self.addButton,
                               self.removeButton,
                               self.nextFieldButton,
                               self.nextEntryButton,
                               [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                               [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(dismissView)]];
        [entryToolbar sizeToFit];
    }
    return entryToolbar;
}

@end
