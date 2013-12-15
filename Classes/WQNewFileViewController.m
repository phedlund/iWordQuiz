//
//  WQNewFileViewController.m
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

#import "WQNewFileViewController.h"

@interface WQNewFileViewController () {
    NSString *_frontIdentifier;
    NSString *_backIdentifier;
    NSString *_fileName;
}

- (void) vocabInfo:(NSNotification *)n;
@end

@implementation WQNewFileViewController

@synthesize delegate = _delegate;
@synthesize isEditingVocabulary;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
        self.isEditingVocabulary = NO;
        _frontIdentifier = nil;
        _backIdentifier = nil;
        _fileName = nil;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    UIImageView *tempImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"background"]];
    [tempImageView setFrame:self.tableView.frame];
    
    self.tableView.backgroundView = tempImageView;
    //[tempImageView release];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.frontTextField.text = _frontIdentifier;
    self.backTextField.text = _backIdentifier;
    self.fileNameTextField.text = _fileName;
}

- (void)viewDidUnload
{
    [self setFileNameTextField:nil];
    [self setFrontTextField:nil];
    [self setBackTextField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    NSInteger result = 0;
    switch (section) {
        case 0:
            result = 1;
            break;
        case 1:
            result = 2;
            break;
        case 2:
            if (!self.isEditingVocabulary) {
                result = 1;
            }
            break;
        default:
            break;
    }
    return result;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	if (section < 2) {
        return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ? 44.0f : 27.0f;
    }
    return 0.0f;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //iPad
    BOOL success = false;
    if (indexPath.section == 2) {
        if (self.delegate) {
            success = [self.delegate createNewDocument:self];
        }
    }
    
    if (success) {
        [self doDismissView:self];
    } else {
        [tableView deselectRowAtIndexPath:indexPath animated:true];
    }
}


- (IBAction)doDismissView:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)doCreateNew:(id)sender {
    //iPhone
    BOOL success = false;
    if (self.delegate) {
        success = [self.delegate createNewDocument:self];
    }
    
    if (success) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void) vocabInfo:(NSNotification *)n {
    NSDictionary *dict = n.userInfo;
    _frontIdentifier = [dict valueForKey:@"FrontIdentifier"];
    _backIdentifier = (NSString*)[dict valueForKey:@"BackIdentifier"];
    _fileName = [[(NSURL*)[dict valueForKey:@"URL"] lastPathComponent] stringByDeletingPathExtension];
}

@end
