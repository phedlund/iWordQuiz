//
//  WQEditViewController.h
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

#import <UIKit/UIKit.h>

typedef enum {
    kNext,
    kPrevious,
    kAdd,
    kRemove,
    kDone
} EditReason;

@protocol WQEditViewControllerDelegate;

@interface WQEditViewController : UIViewController

- (IBAction) doNext;
- (IBAction) doPrevious;
- (IBAction) doAdd;
- (IBAction) doRemove;
- (IBAction) dismissView;

@property (nonatomic, strong) IBOutlet UIButton *nextButton;
@property (nonatomic, strong) IBOutlet UIButton *previousButton;
@property (nonatomic, strong) IBOutlet UIButton *addButton;
@property (nonatomic, strong) IBOutlet UIButton *removeButton;
@property (nonatomic, strong) IBOutlet UILabel *frontIdentifierLabel;
@property (nonatomic, strong) IBOutlet UILabel *backIdentifierLabel;

@property (nonatomic, strong) IBOutlet UITextField *frontTextField;
@property (nonatomic, strong) IBOutlet UITextField *backTextField;

@property (strong, nonatomic) id<WQEditViewControllerDelegate> delegate;

@end


@protocol WQEditViewControllerDelegate <NSObject>
@optional
- (void)currentEntryDidChange:(WQEditViewController*)aEditViewController reason:(EditReason)aReason;
@end
