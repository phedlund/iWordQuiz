//
//  WQNewFileViewController.h
//  iWordQuiz
//
//  Created by Peter Hedlund on 4/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WQNewFileViewControllerDelegate;

@interface WQNewFileViewController : UITableViewController

@property (retain, nonatomic) IBOutlet UITextField *fileNameTextField;
@property (retain, nonatomic) IBOutlet UITextField *frontTextField;
@property (retain, nonatomic) IBOutlet UITextField *backTextField;
@property (retain, nonatomic) id<WQNewFileViewControllerDelegate> delegate;

- (IBAction)doDismissView:(id)sender;

@end

@protocol WQNewFileViewControllerDelegate <NSObject>
@required
- (BOOL)createNewDocument:(WQNewFileViewController*)aWQNewFileViewController;
@end
