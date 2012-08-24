//
//  DetailViewController.m
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

#import "DetailViewController.h"
#import "HomeViewController.h"
#import "FCViewController.h"
#import "MCViewController.h"
#import "QAViewController.h"
#import "AboutViewController.h"

@interface DetailViewController ()
@property (strong, nonatomic) UIPopoverController *masterPopoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize masterPopoverController = _masterPopoverController;
@synthesize modePicker = _modePicker;
@synthesize modePickerPopover = _modePickerPopover;
@synthesize doc = _doc;
@synthesize detailItem = _detailItem;

- (void)documentContentsDidChange:(WQDocument *)document {
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (m_quiz != nil) {
            [m_quiz release];
            m_quiz = nil;
        }
        
        m_quiz = [[WQQuiz alloc] init];
        [m_quiz setEntries:[document quizEntries]];
        [m_quiz setFrontIdentifier:[document frontIdentifier]];
        [m_quiz setBackIdentifier:[document backIdentifier]];
        [m_quiz setFileName:[[document.fileURL lastPathComponent] stringByDeletingPathExtension]];
        
        [self activateTab:self.selectedIndex];
        self.navigationItem.title = [[document.fileURL lastPathComponent] stringByDeletingPathExtension];
    });
}

#pragma mark -
#pragma mark Managing the detail item


// When setting the detail item, update the view and dismiss the popover controller if it's showing.

- (void)setDetailItem:(NSURL*)newDetailItem {
    //if (_detailItem != newDetailItem) {
        [_detailItem release];
        
        _detailItem = [newDetailItem retain];
        
        // Update the view.
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            if (_detailItem == nil) {
                if (_doc != nil) {
                    [_doc closeWithCompletionHandler:nil];
                    [_doc release];
                    _doc = nil;
                }
                if (m_quiz != nil) {
                    [m_quiz release];
                    m_quiz = nil;
                }
                [self setSelectedIndex:0];
                [self activateTab:0];
                [[(HomeViewController*)[self.viewControllers objectAtIndex:0] spreadView] reloadData];
            } else {
                [self configureView];
            }
        }
    //}

	if (self.masterPopoverController != nil) {
        [self.masterPopoverController dismissPopoverAnimated:YES];
    }        
}


- (void)configureView {
    if (_doc != nil) {
        [_doc closeWithCompletionHandler:nil];
        [_doc release];
        _doc = nil;
    }

    _doc = [[WQDocument alloc] initWithFileURL:_detailItem];
    _doc.delegate = self;

    [_doc openWithCompletionHandler:^(BOOL success) {
        
        if (m_quiz != nil) {
            [m_quiz release];
            m_quiz = nil;
        }
        
        m_quiz = [[WQQuiz alloc] init];
        [m_quiz setEntries:[_doc quizEntries]];
        [m_quiz setFrontIdentifier:[_doc frontIdentifier]];
        [m_quiz setBackIdentifier:[_doc backIdentifier]];
        [m_quiz setFileName:[[_detailItem lastPathComponent] stringByDeletingPathExtension]];
        
        if (![self hasEnoughEntries:self.selectedIndex]) {
            [self setSelectedIndex:0];
            [self activateTab:0];
        }
        //[self activateTab:self.selectedIndex];
        self.navigationItem.title = [[_detailItem lastPathComponent] stringByDeletingPathExtension];
     }];
}


#pragma mark -
#pragma mark Split view support

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    barButtonItem.title = @"Vocabularies";
	[self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.masterPopoverController = pc;
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
	[self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.masterPopoverController = nil;
}


#pragma mark -
#pragma mark Rotation support

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
	for (UIViewController *myView in self.viewControllers) {
		[myView willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	}
}



#pragma mark -
#pragma mark View lifecycle


 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem* barButtonAbout = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(doAbout:)];
    UIBarButtonItem *barButtonEdit = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(doEdit:)];
    UIBarButtonItem* barButtonMode = [[UIBarButtonItem alloc] initWithTitle:@"Mode" style:UIBarButtonItemStyleBordered target:self action:@selector(doMode:)]; 
    NSArray *buttons = nil;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) { 
        buttons = [NSArray arrayWithObjects:barButtonAbout, barButtonEdit, barButtonMode, nil];
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) { 
        buttons = [NSArray arrayWithObjects:barButtonEdit, barButtonMode, nil];
    }    
    self.navigationItem.rightBarButtonItems = buttons;
    [barButtonAbout release];
    [barButtonEdit release];
    [barButtonMode release];
    
    m_currentRow = 0;
	[self activateTab:1];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.selectedViewController willRotateToInterfaceOrientation:[[UIDevice currentDevice] orientation ] duration:0];
    // Update the view.
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        [self configureView];
    }
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.masterPopoverController = nil;
    [_doc closeWithCompletionHandler:nil];
}


- (void)activateTab:(int)index {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	// getting an NSInteger
	NSInteger myMode = [prefs integerForKey:@"Mode"];
	if (myMode == 0) {
		myMode = 1;
	}
	if (m_quiz != nil) {
		m_quiz.quizMode = myMode;
        HomeViewController *homeViewController;
        switch (index) {
            case 0:
                homeViewController = (HomeViewController*)[self.viewControllers objectAtIndex:0];
                [homeViewController restart];
                break;
            case 1:
                [(FCViewController *) self.selectedViewController setQuiz:m_quiz];
                [(FCViewController *) self.selectedViewController restart];
                break;
            case 2:
                [(MCViewController *) self.selectedViewController setQuiz:m_quiz];
                [(MCViewController *) self.selectedViewController restart];
                break;
            case 3:
                [(QAViewController *) self.selectedViewController setQuiz:m_quiz];
                [(QAViewController *) self.selectedViewController restart];
                break;
            default:
                break;
        }
	}
}


- (void)modeSelected:(NSUInteger)mode {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	// saving an NSInteger
	[prefs setInteger:mode + 1 forKey:@"Mode"];
	[prefs synchronize];
	
	m_quiz.quizMode = mode + 1;
    [self.modePickerPopover dismissPopoverAnimated:YES];
	[self activateTab:self.selectedIndex];
}

- (NSUInteger)selectedMode {
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	// getting an NSInteger
	NSInteger myMode = [prefs integerForKey:@"Mode"];
	if (myMode == 0) {
		myMode = 1;
	}
	
	return myMode;
}

- (IBAction) doMode:(id)sender {
    if (_modePicker == nil) {
        _modePicker = [[[ModePickerController alloc] initWithStyle:UITableViewStylePlain] autorelease];
        _modePicker.delegate = self;
        _modePickerPopover = [[WEPopoverController alloc] initWithContentViewController:_modePicker];  
        if ([_modePickerPopover respondsToSelector:@selector(setContainerViewProperties:)]) {
			[_modePickerPopover setContainerViewProperties:[self improvedContainerViewProperties]];
		}
    }
    [_modePickerPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:(UIPopoverArrowDirectionUp | UIPopoverArrowDirectionDown) animated:YES];
}

- (IBAction) doAbout:(id)sender {
    UINavigationController *navController =  [self.storyboard instantiateViewControllerWithIdentifier:@"about"];
    navController.modalPresentationStyle = UIModalPresentationFormSheet;
    [self presentViewController:navController animated:YES completion:nil];
}

- (void) doEdit:(id)sender {
    UINavigationController *navController =  [self.storyboard instantiateViewControllerWithIdentifier:@"edit"];

    WQEditViewController *editViewController = (WQEditViewController*)navController.topViewController;
    [self presentViewController:navController animated:YES completion:nil];
    editViewController.delegate = self;
    editViewController.nextButton.enabled = (m_currentRow < (_doc.entries.count - 1));
    editViewController.previousButton.enabled = (m_currentRow > 0);
    editViewController.frontIdentifierLabel.text = _doc.frontIdentifier;
    editViewController.backIdentifierLabel.text = _doc.backIdentifier;
    editViewController.frontTextField.text = [[_doc.entries objectAtIndex:m_currentRow] objectAtIndex:0];
    editViewController.backTextField.text = [[_doc.entries objectAtIndex:m_currentRow] objectAtIndex:1];
}

- (void) quizDidFinish {
	//self.repeatErrors.enabled = [m_quiz hasErrors];
}

- (BOOL) hasEnoughEntries:(int)index {
    BOOL result = true;
    switch (index) {
        case 0:
            result = true;
            break;
        case 1:
            result = ((m_quiz != nil) && (m_quiz.entries.count > 0));
            break;
        case 2:
            result = ((m_quiz != nil) && (m_quiz.entries.count > 2));
            break;
        case 3:
            result = ((m_quiz != nil) && (m_quiz.entries.count > 0));
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

- (void)dealloc {
	[_modePicker release];
	[_modePickerPopover release];
	
	[m_quiz release];
    //[doc release];
	
    [super dealloc];
}



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
- (MDSpreadViewCell *)spreadView:(MDSpreadView *)aSpreadView cellForRowAtIndexPath:(NSIndexPath *)rowPath forColumnAtIndexPath:(NSIndexPath *)columnPath
{
    static NSString *cellIdentifier = @"Cell";
    
    MDSpreadViewCell *cell = [aSpreadView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[MDSpreadViewCell alloc] initWithStyle:MDSpreadViewCellStyleDefault reuseIdentifier:cellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [[self.doc.entries objectAtIndex:rowPath.row ] objectAtIndex:columnPath.row];
    cell.highlighted = ((rowPath.row == m_currentRow) && (columnPath.row == m_currentColumn));
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        cell.textLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    }
    return cell;
}

- (MDSpreadViewCell *)spreadView:(MDSpreadView *)aSpreadView cellForHeaderInRowSection:(NSInteger)rowSection forColumnSection:(NSInteger)columnSection
{
    static NSString *cellIdentifier = @"CornerHeaderCell";
    
    MDSpreadViewHeaderCell *cell = (MDSpreadViewHeaderCell *)[aSpreadView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[MDSpreadViewHeaderCell alloc] initWithStyle:MDSpreadViewHeaderCellStyleCorner reuseIdentifier:cellIdentifier] autorelease];
    }
    
    return cell;
}

- (MDSpreadViewCell *)spreadView:(MDSpreadView *)aSpreadView cellForHeaderInRowSection:(NSInteger)section forColumnAtIndexPath:(NSIndexPath *)columnPath
{
    static NSString *cellIdentifier = @"RowHeaderCell";
    
    MDSpreadViewHeaderCell *cell = (MDSpreadViewHeaderCell *)[aSpreadView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[MDSpreadViewHeaderCell alloc] initWithStyle:MDSpreadViewHeaderCellStyleRow reuseIdentifier:cellIdentifier] autorelease];
    }
    
    if (columnPath.row == 0) {
        cell.textLabel.text = [self.doc frontIdentifier];
    } else {
        cell.textLabel.text = [self.doc backIdentifier];
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        cell.textLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    }
    return cell;
}

- (MDSpreadViewCell *)spreadView:(MDSpreadView *)aSpreadView cellForHeaderInColumnSection:(NSInteger)section forRowAtIndexPath:(NSIndexPath *)rowPath
{
    static NSString *cellIdentifier = @"ColumnHeaderCell";
    
    MDSpreadViewHeaderCell *cell = (MDSpreadViewHeaderCell *)[aSpreadView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[[MDSpreadViewHeaderCell alloc] initWithStyle:MDSpreadViewHeaderCellStyleColumn reuseIdentifier:cellIdentifier] autorelease];
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"%d", rowPath.row + 1];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        cell.textLabel.font = [UIFont systemFontOfSize:[UIFont smallSystemFontSize]];
    }
    
    return cell;
}


#pragma mark Heights
// Comment these out to use normal values (see MDSpreadView.h)
- (CGFloat)spreadView:(MDSpreadView *)aSpreadView heightForRowAtIndexPath:(NSIndexPath *)indexPath
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

- (CGFloat)spreadView:(MDSpreadView *)aSpreadView widthForColumnAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        if (([[UIDevice currentDevice] orientation ] == UIDeviceOrientationLandscapeLeft) ||
            ([[UIDevice currentDevice] orientation ] == UIDeviceOrientationLandscapeRight)) {
            
            return 214;
        } else {
            return 138;
        }
        
    } else {
        return 302;
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

- (void)spreadView:(MDSpreadView *)aSpreadView didSelectRowAtIndexPath:(NSIndexPath *)indexPath forColumnIndex:(NSIndexPath *)columnPath {
    m_currentRow = indexPath.row;
    m_currentColumn = columnPath.row;
    [aSpreadView reloadData];
}


#pragma mark WEPopover
/**
 Thanks to Paul Solt for supplying these background images and container view properties
 */
- (WEPopoverContainerViewProperties *)improvedContainerViewProperties {
	
	WEPopoverContainerViewProperties *props = [[WEPopoverContainerViewProperties alloc] autorelease];
	NSString *bgImageName = nil;
	CGFloat bgMargin = 0.0;
	CGFloat bgCapSize = 0.0;
	CGFloat contentMargin = 6.0;
	
	bgImageName = @"popoverBg.png";
	
	// These constants are determined by the popoverBg.png image file and are image dependent
	bgMargin = 13; // margin width of 13 pixels on all sides popoverBg.png (62 pixels wide - 36 pixel background) / 2 == 26 / 2 == 13 
	bgCapSize = 31; // ImageSize/2  == 62 / 2 == 31 pixels
	
	props.leftBgMargin = bgMargin;
	props.rightBgMargin = bgMargin;
	props.topBgMargin = bgMargin;
	props.bottomBgMargin = bgMargin;
	props.leftBgCapSize = bgCapSize;
	props.topBgCapSize = bgCapSize;
	props.bgImageName = bgImageName;
	props.leftContentMargin = contentMargin;
	props.rightContentMargin = contentMargin - 1; // Need to shift one pixel for border to look correct
	props.topContentMargin = contentMargin; 
	props.bottomContentMargin = contentMargin;
	
	props.arrowMargin = 4.0;
	
	props.upArrowImageName = @"popoverArrowUp.png";
	props.downArrowImageName = @"popoverArrowDown.png";
	props.leftArrowImageName = @"popoverArrowLeft.png";
	props.rightArrowImageName = @"popoverArrowRight.png";
	return props;	
}

#pragma mark WQEditViewControllerDelegate

- (void)currentEntryDidChange:(WQEditViewController*)aEditViewController reason:(EditReason)aReason {
    NSString *newFront = aEditViewController.frontTextField.text;
    NSString *newBack = aEditViewController.backTextField.text;
    NSString *oldFront = [[_doc.entries objectAtIndex:m_currentRow] objectAtIndex:0];
    NSString *oldBack = [[_doc.entries objectAtIndex:m_currentRow] objectAtIndex:1];
    int valueChanges = 0;
    if (![newFront isEqualToString:oldFront])
        ++valueChanges;
    if (![newBack isEqualToString:oldBack])
        ++valueChanges;
    
    if (valueChanges > 0) {
        [_doc.entries removeObjectAtIndex:m_currentRow];
        [_doc.entries insertObject:[NSArray arrayWithObjects:newFront, newBack, nil] atIndex:m_currentRow];
        [_doc updateChangeCount:UIDocumentChangeDone];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"Edited" object:nil];
    }
    
    
    switch (aReason) {
        case kNext:
            ++m_currentRow;
            break;
        case kPrevious:
            --m_currentRow;
            break;
        case kAdd:
            [_doc.entries insertObject:[NSArray arrayWithObjects:@"", @"", nil] atIndex:++m_currentRow];
            [_doc updateChangeCount:UIDocumentChangeDone];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Edited" object:nil];
            break;
        case kRemove:
            [_doc.entries removeObjectAtIndex:m_currentRow];
            while (m_currentRow > (_doc.entries.count - 1)) {
                --m_currentRow;
            }
            [_doc updateChangeCount:UIDocumentChangeDone];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"Edited" object:nil];
            break;
        case kDone:
            [_doc saveToURL:_doc.fileURL forSaveOperation:UIDocumentSaveForOverwriting 
                                        completionHandler:^(BOOL success) {
                                                                if (success) {
                                                                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                                                                        [self setDetailItem:_doc.fileURL];
                                                                    }
                                                                    
                                                                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
                                                                        [self configureView];
                                                                    }
                                                                }
                                        }];
            
            break;
        default:
            break;
    }

    aEditViewController.nextButton.enabled = (m_currentRow < (_doc.entries.count - 1));
    aEditViewController.previousButton.enabled = (m_currentRow > 0);
    aEditViewController.frontTextField.text = [[_doc.entries objectAtIndex:m_currentRow] objectAtIndex:0];
    aEditViewController.backTextField.text = [[_doc.entries objectAtIndex:m_currentRow] objectAtIndex:1];
}
@end
