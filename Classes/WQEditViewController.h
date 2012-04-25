//
//  WQEditViewController.h
//  iWordQuiz
//
//  Created by Peter Hedlund on 4/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

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

@property (nonatomic, retain) IBOutlet UIButton *nextButton;
@property (nonatomic, retain) IBOutlet UIButton *previousButton;
@property (nonatomic, retain) IBOutlet UIButton *addButton;
@property (nonatomic, retain) IBOutlet UIButton *removeButton;
@property (nonatomic, strong) IBOutlet UILabel *frontIdentifierLabel;
@property (nonatomic, strong) IBOutlet UILabel *backIdentifierLabel;

@property (nonatomic, retain) IBOutlet UITextField *frontTextField;
@property (nonatomic, retain) IBOutlet UITextField *backTextField;

@property (retain, nonatomic) id<WQEditViewControllerDelegate> delegate;

@end


@protocol WQEditViewControllerDelegate <NSObject>
@optional
- (void)currentEntryDidChange:(WQEditViewController*)aEditViewController reason:(EditReason)aReason;
@end
