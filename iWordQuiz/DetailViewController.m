//
//  DetailViewController.m
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

#import "DetailViewController.h"
#import "HomeViewController.h"
#import "FCViewController.h"
#import "MCViewController.h"
#import "QAViewController.h"
#import "TransparentToolbar.h"
#import "WQUtils.h"
#import "UIColor+PHColor.h"
#import "UIImage+PHColor.h"

@interface DetailViewController () {
	WQQuiz * _quiz;
    NSInteger _currentRow;
    NSInteger _currentColumn;
}

- (void)configureView;

@end

@implementation DetailViewController

@synthesize exportBarButtonItem;
@synthesize modeBarButtonItem;
@synthesize editBarButtonItem;
@synthesize modePicker;
@synthesize modePickerPopover;

- (void)documentContentsDidChange:(WQDocument *)document {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (_quiz != nil) {
            _quiz = nil;
        }
        
        _quiz = [[WQQuiz alloc] init];
        [_quiz setEntries:[document quizEntries]];
        [_quiz setFrontIdentifier:[document frontIdentifier]];
        [_quiz setBackIdentifier:[document backIdentifier]];
        [_quiz setFileName:[[document.fileURL lastPathComponent] stringByDeletingPathExtension]];
        
        [self activateTab:self.selectedIndex];
        self.navigationItem.title = [[document.fileURL lastPathComponent] stringByDeletingPathExtension];
    });
}

#pragma mark -
#pragma mark Managing the detail item


// When setting the detail item, update the view and dismiss the popover controller if it's showing.

- (void)setDetailItem:(NSURL*)newDetailItem {
    //if (_detailItem != newDetailItem) {
        
        _detailItem = newDetailItem;
        
        // Update the view.
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            if (_detailItem == nil) {
                if (_doc != nil) {
                    [_doc closeWithCompletionHandler:nil];
                    _doc = nil;
                }
                if (_quiz != nil) {
                    _quiz = nil;
                }
                [self setSelectedIndex:0];
                [self activateTab:0];
                [[(HomeViewController*)[self.viewControllers objectAtIndex:0] spreadView] reloadData];
            } else {
                [self configureView];
            }
            self.editBarButtonItem.enabled = (_doc != nil);
            self.exportBarButtonItem.enabled = (_doc != nil);
        }
    //}
}


- (void)configureView {
    if (_doc != nil) {
        [_doc closeWithCompletionHandler:nil];
        _doc = nil;
    }

    _doc = [[WQDocument alloc] initWithFileURL:_detailItem];
    _doc.delegate = self;

    [_doc openWithCompletionHandler:^(BOOL success) {
        
        if (_quiz != nil) {
            _quiz = nil;
        }
        
        _quiz = [[WQQuiz alloc] init];
        [_quiz setEntries:[_doc quizEntries]];
        [_quiz setFrontIdentifier:[_doc frontIdentifier]];
        [_quiz setBackIdentifier:[_doc backIdentifier]];
        [_quiz setFileName:[[_detailItem lastPathComponent] stringByDeletingPathExtension]];
        
        if (![self hasEnoughEntries:self.selectedIndex]) {
            [self setSelectedIndex:0];
            [self activateTab:0];
        }
        //[self activateTab:self.selectedIndex];
        self.navigationItem.title = [[_detailItem lastPathComponent] stringByDeletingPathExtension];
     }];
}

#pragma mark -
#pragma mark Rotation support

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate {
    return YES;
}


#pragma mark -
#pragma mark View lifecycle


 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.editBarButtonItem.enabled = (_doc != nil);
        self.exportBarButtonItem.enabled = (_doc != nil);
    }
    
    self.navigationItem.leftBarButtonItem = self.splitViewController.displayModeButtonItem;
    self.navigationItem.leftItemsSupplementBackButton = YES;
    
    self.navigationController.navigationBar.tintColor = [UIColor phIconColor];
    self.navigationController.navigationBar.barTintColor = [UIColor phBackgroundColor];

    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowColor = [UIColor clearColor];
    shadow.shadowBlurRadius = 0.0;
    shadow.shadowOffset = CGSizeZero;

    [self.navigationController.navigationBar setTitleTextAttributes:
     [NSDictionary dictionaryWithObjectsAndKeys:
      [UIColor phIconColor], NSForegroundColorAttributeName,
      shadow, NSShadowAttributeName, nil]];

    self.tabBar.tintColor = [UIColor phIconColor];
    self.tabBar.barTintColor = [UIColor phBackgroundColor];
    [[UITabBarItem appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: [UIColor phIconColor], NSForegroundColorAttributeName, nil]
                                             forState: UIControlStateSelected];

    UIColor *unselectedColor = [UIColor colorWithRed:0.70 green:0.60 blue:0.42 alpha:1.0];
    [[UITabBarItem appearance] setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys: unselectedColor, NSForegroundColorAttributeName, nil]
                                             forState: UIControlStateNormal];
    
    // set selected and unselected icons
    UIImage *img;
    UITabBarItem *item;
    
    item = [self.tabBar.items objectAtIndex:0];
    img = [UIImage changeImage:[UIImage imageNamed:@"homeTab"] toColor:unselectedColor];
    item.image = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.selectedImage = [UIImage imageNamed:@"homeTab"];

    item = [self.tabBar.items objectAtIndex:1];
    img = [UIImage changeImage:[UIImage imageNamed:@"flashTab"] toColor:unselectedColor];
    item.image = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.selectedImage = [UIImage imageNamed:@"flashTab"];

    item = [self.tabBar.items objectAtIndex:2];
    img = [UIImage changeImage:[UIImage imageNamed:@"multipleTab"] toColor:unselectedColor];
    item.image = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.selectedImage = [UIImage imageNamed:@"multipleTab"];

    item = [self.tabBar.items objectAtIndex:3];
    img = [UIImage changeImage:[UIImage imageNamed:@"qaTab"] toColor:unselectedColor];
    item.image = [img imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    item.selectedImage = [UIImage imageNamed:@"qaTab"];

    //remove bottom line/shadow
    for (UIView *view in self.navigationController.navigationBar.subviews) {
        for (UIView *view2 in view.subviews) {
            if ([view2 isKindOfClass:[UIImageView class]]) {
                if (![view2.superview isKindOfClass:[UIButton class]]) {
                    [view2 removeFromSuperview];
                }
                
            }
        }
    }

    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
    _currentRow = 0;
	[self activateTab:1];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    // Update the view.
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self configureView];
    }
}

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [_doc closeWithCompletionHandler:nil];
}


- (void)activateTab:(NSInteger)index {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	// getting an NSInteger
	NSInteger myMode = [prefs integerForKey:@"Mode"];
	if (myMode == 0) {
		myMode = 1;
	}
	if (_quiz != nil) {
		_quiz.quizMode = myMode;
        HomeViewController *homeViewController;
        switch (index) {
            case 0:
                homeViewController = (HomeViewController*)[self.viewControllers objectAtIndex:0];
                [homeViewController restart];
                break;
            case 1:
                _quiz.quizType = WQQuizTypeFC;
                [(FCViewController *) self.selectedViewController setQuiz:_quiz];
                [(FCViewController *) self.selectedViewController restart];
                break;
            case 2:
                _quiz.quizType = WQQuizTypeMC;
                [(MCViewController *) self.selectedViewController setQuiz:_quiz];
                [(MCViewController *) self.selectedViewController restart];
                break;
            case 3:
                _quiz.quizType = WQQuizTypeQA;
                [(QAViewController *) self.selectedViewController setQuiz:_quiz];
                [(QAViewController *) self.selectedViewController restart];
                break;
            default:
                break;
        }
	}
}


- (void)modeSelected:(NSUInteger)mode {
	if (mode != -1) { //-1 == ScoreAsPercent (hack!)
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setInteger:mode + 1 forKey:@"Mode"];
        [prefs synchronize];
        _quiz.quizMode = mode + 1;
        [self activateTab:self.selectedIndex];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSUInteger)selectedMode {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	NSInteger myMode = [prefs integerForKey:@"Mode"];
	if (myMode == 0) {
		myMode = 1;
	}
	return myMode;
}

- (IBAction) onExport:(id)sender {
    if (!_detailItem) {
        return;
    }
    UIActivityViewController *vc = [[UIActivityViewController alloc] initWithActivityItems:@[_detailItem] applicationActivities:@[]];
    vc.excludedActivityTypes = @[UIActivityTypeAssignToContact,
                                 UIActivityTypeSaveToCameraRoll,
                                 UIActivityTypePostToFlickr,
                                 UIActivityTypePostToVimeo,
                                 UIActivityTypePostToTencentWeibo,
                                 UIActivityTypePostToTwitter,
                                 UIActivityTypePostToFacebook,
                                 UIActivityTypeOpenInIBooks];
    vc.modalPresentationStyle = UIModalPresentationPopover;

    modePickerPopover = vc.popoverPresentationController;
    modePickerPopover.delegate = self;
    modePickerPopover.barButtonItem = self.exportBarButtonItem;
    modePickerPopover.permittedArrowDirections = UIPopoverArrowDirectionLeft | UIPopoverArrowDirectionRight | UIPopoverArrowDirectionUp | UIPopoverArrowDirectionDown;
    [self presentViewController:vc animated:YES completion:nil];
}

- (IBAction) doMode:(id)sender {
    [self presentViewController:self.modePicker animated:YES completion:nil];
}

- (IBAction) doEdit:(id)sender {
    UINavigationController *navController =  [self.storyboard instantiateViewControllerWithIdentifier:@"edit"];

    WQEditViewController *editViewController = (WQEditViewController*)navController.topViewController;
    [self presentViewController:navController animated:YES completion:nil];
    editViewController.delegate = self;
    editViewController.nextEntryButton.enabled = (_currentRow < (_doc.entries.count - 1));
    editViewController.previousEntryButton.enabled = (_currentRow > 0);
    editViewController.frontTextField.text = [[_doc.entries objectAtIndex:_currentRow] objectAtIndex:0];
    editViewController.backTextField.text = [[_doc.entries objectAtIndex:_currentRow] objectAtIndex:1];
}

- (void) quizDidFinish {
	//self.repeatErrors.enabled = [m_quiz hasErrors];
}

- (BOOL) hasEnoughEntries:(NSInteger)index {
    BOOL result = true;
    switch (index) {
        case 0:
            result = true;
            break;
        case 1:
            result = ((_quiz != nil) && (_quiz.entries.count > 0));
            break;
        case 2:
            result = ((_quiz != nil) && (_quiz.entries.count > 2));
            break;
        case 3:
            result = ((_quiz != nil) && (_quiz.entries.count > 0));
            break;
        default:
            result = true;
            break;
    }
    return result;
}

#pragma mark -
#pragma mark Memory management

/*
- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
*/

#pragma mark - Spread View Datasource

- (NSInteger)spreadView:(MDSpreadView *)aSpreadView numberOfColumnsInSection:(NSInteger)section
{
    return 2;
}

- (NSInteger)spreadView:(MDSpreadView *)aSpreadView numberOfRowsInSection:(NSInteger)section
{
    if ([self.doc.entries count] == 0)
        return 30;
    else
        return [self.doc.entries count];
}

- (NSInteger)numberOfColumnSectionsInSpreadView:(MDSpreadView *)aSpreadView
{
    return 1;
}

- (NSInteger)numberOfRowSectionsInSpreadView:(MDSpreadView *)aSpreadView
{
    return 1;
}

#pragma Cells
- (MDSpreadViewCell *)spreadView:(MDSpreadView *)aSpreadView cellForRowAtIndexPath:(MDIndexPath *)rowPath forColumnAtIndexPath:(MDIndexPath *)columnPath
{
    static NSString *cellIdentifier = @"Cell";
    
    MDSpreadViewCell *cell = [aSpreadView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[MDSpreadViewCell alloc] initWithStyle:MDSpreadViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    if (self.doc.entries.count > 0) {
        cell.textLabel.text = [[self.doc.entries objectAtIndex:rowPath.row ] objectAtIndex:columnPath.column];
    }

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        cell.textLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    }
    return cell;
}

- (MDSpreadViewCell *)spreadView:(MDSpreadView *)aSpreadView cellForHeaderInRowSection:(NSInteger)section forColumnAtIndexPath:(MDIndexPath *)columnPath
{
    static NSString *cellIdentifier = @"RowHeaderCell";
    
    MDSpreadViewHeaderCell *cell = (MDSpreadViewHeaderCell *)[aSpreadView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[MDSpreadViewHeaderCell alloc] initWithStyle:MDSpreadViewHeaderCellStyleRow reuseIdentifier:cellIdentifier];
    }
    
    if (columnPath.column == 0) {
        cell.textLabel.text = [self.doc frontIdentifier];
    } else {
        cell.textLabel.text = [self.doc backIdentifier];
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        cell.textLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    }
    return cell;
}

- (MDSpreadViewCell *)spreadView:(MDSpreadView *)aSpreadView cellForHeaderInColumnSection:(NSInteger)section forRowAtIndexPath:(MDIndexPath *)rowPath
{
    static NSString *cellIdentifier = @"ColumnHeaderCell";
    
    MDSpreadViewHeaderCell *cell = (MDSpreadViewHeaderCell *)[aSpreadView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[MDSpreadViewHeaderCell alloc] initWithStyle:MDSpreadViewHeaderCellStyleColumn reuseIdentifier:cellIdentifier];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%ld", (long)rowPath.row + 1];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        cell.textLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    }
    
    return cell;
}


#pragma mark Heights
// Comment these out to use normal values (see MDSpreadView.h)
- (CGFloat)spreadView:(MDSpreadView *)aSpreadView heightForRowAtIndexPath:(MDIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return 25;
    } else {
        return 35;
    }
}

- (CGFloat)spreadView:(MDSpreadView *)aSpreadView heightForRowHeaderInSection:(NSInteger)rowSection
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return 25;
    } else {
        return 35;
    }
}

- (CGFloat)spreadView:(MDSpreadView *)aSpreadView widthForColumnAtIndexPath:(MDIndexPath *)indexPath {
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return (CGRectGetWidth([UIScreen mainScreen].bounds) - 54) / 2;
    } else { //iPad
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            if (self.splitViewController.displayMode == UISplitViewControllerDisplayModePrimaryHidden) {
                return (CGRectGetWidth([UIScreen mainScreen].bounds) - 65) / 2;
            } else {
                return (CGRectGetHeight([UIScreen mainScreen].bounds) - 110) / 2;
            }
        } else {
            return (CGRectGetWidth([UIScreen mainScreen].bounds) - 70) / 2;
        }
    }
}

- (CGFloat)spreadView:(MDSpreadView *)aSpreadView widthForColumnHeaderInSection:(NSInteger)columnSection
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return 44;
    } else {
        return 60;
    }
}

- (void)spreadView:(MDSpreadView *)aSpreadView didSelectCellForRowAtIndexPath:(MDIndexPath *)rowPath forColumnAtIndexPath:(MDIndexPath *)columnPath
{
    _currentRow = rowPath.row;
    _currentColumn = columnPath.column;
    [aSpreadView reloadData];
}

#pragma mark WQEditViewControllerDelegate

- (void)currentEntryDidChange:(WQEditViewController*)aEditViewController reason:(EditReason)aReason value:(NSString *)aValue {
    NSString *newFront = aEditViewController.frontTextField.text;
    NSString *newBack = aEditViewController.backTextField.text;
    NSString *oldFront = [[_doc.entries objectAtIndex:_currentRow] objectAtIndex:0];
    NSString *oldBack = [[_doc.entries objectAtIndex:_currentRow] objectAtIndex:1];
    int valueChanges = 0;
    if (![newFront isEqualToString:oldFront])
        ++valueChanges;
    if (![newBack isEqualToString:oldBack])
        ++valueChanges;
    
    if (valueChanges > 0) {
        [_doc.entries removeObjectAtIndex:_currentRow];
        [_doc.entries insertObject:@[newFront, newBack] atIndex:_currentRow];
        [_doc updateChangeCount:UIDocumentChangeDone];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Edited" object:nil];
    }
    
    
    switch (aReason) {
        case kNext: {
            ++_currentRow;
        }
            break;
        case kPrevious: {
            --_currentRow;
        }
            break;
        case kAdd: {
            [_doc.entries insertObject:@[@"", @""] atIndex:++_currentRow];
            [_doc updateChangeCount:UIDocumentChangeDone];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Edited" object:nil];
        }
            break;
        case kRemove: {
            [_doc.entries removeObjectAtIndex:_currentRow];
            while (_currentRow > (_doc.entries.count - 1)) {
                --_currentRow;
            }
            [_doc updateChangeCount:UIDocumentChangeDone];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Edited" object:nil];
        }
            break;
        case kGetVocabInfo: {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"VocabInfo" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:_doc.frontIdentifier, @"FrontIdentifier", _doc.backIdentifier, @"BackIdentifier", _doc.fileURL, @"URL", nil]];
        }
            break;
        case kSetVocabFrontIdentifier: {
            _doc.frontIdentifier = aValue;
            [_doc updateChangeCount:UIDocumentChangeDone];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Edited" object:nil];
        }
            break;
        case kSetVocabBackIdentifier: {
            _doc.backIdentifier = aValue;
            [_doc updateChangeCount:UIDocumentChangeDone];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Edited" object:nil];
        }
            break;
        case kDone: {
            if (![WQUtils isEmpty:aValue]) {
                NSString *oldFilename = [_doc.fileURL lastPathComponent];
                NSString* fileNameWithExtension = [NSString stringWithFormat:@"%@.kvtml", aValue];
                if (![oldFilename isEqualToString:fileNameWithExtension]) {
                    NSURL* parentDirectory = [_doc.fileURL URLByDeletingLastPathComponent];
                    NSURL* newURL = [parentDirectory URLByAppendingPathComponent:fileNameWithExtension];
                    NSFileManager *fm = [NSFileManager defaultManager];
                    if (![fm fileExistsAtPath:[newURL path]]) {
                        [fm moveItemAtURL:_doc.fileURL toURL:newURL error:nil];
                        [_doc presentedItemDidMoveToURL:newURL];
                        [_doc updateChangeCount:UIDocumentChangeDone];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"Edited" object:nil];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"FileURL" object:self userInfo:[NSDictionary dictionaryWithObjectsAndKeys:newURL, @"URL", nil]];
                    } 
                }
            } 
            
            [_doc saveToURL:_doc.fileURL forSaveOperation:UIDocumentSaveForOverwriting completionHandler:^(BOOL success) {
                NSLog(@"Degree of success: %i", success);
                if (success) {
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                        [self setDetailItem:_doc.fileURL];
                    }
                    
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                        [self configureView];
                    }
                }
            }];
        }
            break;
        default:
            break;
    }

    aEditViewController.nextEntryButton.enabled = (_currentRow < (_doc.entries.count - 1));
    aEditViewController.previousEntryButton.enabled = (_currentRow > 0);
    aEditViewController.frontTextField.text = [[_doc.entries objectAtIndex:_currentRow] objectAtIndex:0];
    aEditViewController.backTextField.text = [[_doc.entries objectAtIndex:_currentRow] objectAtIndex:1];
}

- (NSString*)identifierForSection:(NSInteger)section {
    NSString *result;
    if (section == 0) {
        result = _doc.frontIdentifier;
    }
    if (section == 1) {
        result = _doc.backIdentifier;
    }
    return result;
}

#pragma mark - Mode Popover

- (ModePickerController*)modePicker {
    if (!modePicker) {
        modePicker = [[ModePickerController alloc] initWithStyle:UITableViewStylePlain];
        modePicker.delegate = self;
        modePicker.preferredContentSize = CGSizeMake(290.0, 324.0f);
        modePicker.modalPresentationStyle = UIModalPresentationPopover;
    }
    modePickerPopover = modePicker.popoverPresentationController;
    modePickerPopover.delegate = self;
    modePickerPopover.barButtonItem = self.modeBarButtonItem;
    modePickerPopover.permittedArrowDirections = UIPopoverArrowDirectionLeft | UIPopoverArrowDirectionRight | UIPopoverArrowDirectionUp | UIPopoverArrowDirectionDown;
    return modePicker;
}

- (UIModalPresentationStyle)adaptivePresentationStyleForPresentationController:(UIPresentationController *)controller {
    
    return UIModalPresentationNone;
}

@end
