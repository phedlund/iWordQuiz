//
//  DetailViewController.h
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

#import <UIKit/UIKit.h>

#import "WQQuiz.h"
#import "ModePickerController.h"
#import "WQDocument.h"
#import "MDSpreadViewClasses.h"
#import "WQEditViewController.h"
#import "MSDynamicsDrawerViewController.h"

@interface DetailViewController : UITabBarController <UIPopoverPresentationControllerDelegate, ModePickerDelegate, MDSpreadViewDataSource, MDSpreadViewDelegate, WQDocumentDelegate, WQEditViewControllerDelegate>

@property (strong, nonatomic) NSURL *detailItem;
@property (strong, nonatomic) ModePickerController *modePicker;
@property (strong, nonatomic) UIPopoverPresentationController *modePickerPopover;
@property (strong, nonatomic) WQDocument *doc;
@property (weak, nonatomic) MSDynamicsDrawerViewController *dynamicsDrawerViewController;

@property (strong, nonatomic) IBOutlet UIBarButtonItem *menuButton;
@property (nonatomic, strong, readonly) UIBarButtonItem *modeBarButtonItem;
@property (nonatomic, strong, readonly) UIBarButtonItem *editBarButtonItem;

- (void) activateTab:(NSInteger)index;

- (void) quizDidFinish;
- (BOOL) hasEnoughEntries:(NSInteger)index;

- (IBAction) doMenu:(id)sender;
- (IBAction) doMode:(id)sender;
- (IBAction) doEdit:(id)sender;

@end
