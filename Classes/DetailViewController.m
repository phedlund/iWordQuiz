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
#import "RootViewController.h"
#import "DDXML.h"
#import "HomeViewController.h"
#import "FCViewController.h"
#import "MCViewController.h"
#import "QAViewController.h"

@interface DetailViewController ()
@property (nonatomic, retain) UIPopoverController *popoverController;
- (void)configureView;
@end

@implementation DetailViewController

@synthesize popoverController;
@synthesize modePicker, modePickerPopover/*, tabController*/;
@synthesize entries, identifierFront, identifierBack;

static inline BOOL isEmpty(id thing) {
	return thing == nil
	|| ([thing respondsToSelector:@selector(length)]
		&& [(NSData *)thing length] == 0)
	|| ([thing respondsToSelector:@selector(count)]
		&& [(NSArray *)thing count] == 0);
}

- (void) setDocument:(NSURL *)URL
{
	if (popoverController != nil) {
        [popoverController dismissPopoverAnimated:YES];
    }

	[self.entries removeAllObjects];
    NSString *f = @"";
    NSString *b = @"";
	
    if ([[URL pathExtension] caseInsensitiveCompare:@"kvtml"] == NSOrderedSame) {
        //kvtml start
        NSString *fileString = [NSString stringWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:NULL];
        
        DDXMLDocument *xmlDoc = [[DDXMLDocument alloc] initWithXMLString:fileString options:0 error:nil];
        NSArray *identifierNodes = [xmlDoc nodesForXPath:@"/kvtml/identifiers/identifier/name" error:nil];
        
        self.identifierFront = [[identifierNodes objectAtIndex:0] stringValue];
        self.identifierBack  = [[identifierNodes objectAtIndex:1] stringValue];
        
        NSArray *textNodes = [xmlDoc nodesForXPath:@"/kvtml/entries/entry/translation/text" error:nil];
        int colCount = [identifierNodes count];
        int i = 0;

        int emptyCellCount = 0;
        for (DDXMLNode *textNode in textNodes){
            emptyCellCount = 0;

            if (i == 0) {
                if (isEmpty([textNode stringValue])) {
                    emptyCellCount++;
                }
                f = [textNode stringValue];
            }

            if (i == 1) {
                if (isEmpty([textNode stringValue])) {
                    emptyCellCount++;
                }
                b = [textNode stringValue];
            }
            
            if ((i == (colCount - 1)) && (!(emptyCellCount > 0))) {
                [self.entries addObject:[NSDictionary dictionaryWithObjectsAndKeys: f, @"Front", b, @"Back", nil]];
            }
            
            if (i == (colCount - 1)) {
                i = 0;
            } else {
                ++i;
            }      
        }
        [xmlDoc release];
    }
 
    if ([[URL pathExtension] caseInsensitiveCompare:@"csv"] == NSOrderedSame) {
    
        NSString *fileString = [NSString stringWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:NULL];
        
        unsigned length = [fileString length];
        unsigned paraStart = 0, paraEnd = 0, contentsEnd = 0;
        NSMutableArray *lines = [[[NSMutableArray alloc] init] autorelease];
        NSRange currentRange;
        while (paraEnd < length) {
            [fileString getParagraphStart:&paraStart end:&paraEnd contentsEnd:&contentsEnd forRange:NSMakeRange(paraEnd, 0)];
            currentRange = NSMakeRange(paraStart, contentsEnd - paraStart);
            [lines addObject:[fileString substringWithRange:currentRange]];
        }
        self.identifierFront = @"Front";
        self.identifierBack  = @"Back";
        
        int emptyCellCount = 0;

        for (NSString *theLine in lines) {

            if (!(isEmpty(theLine)) && ![theLine hasPrefix:@"!"] && ![theLine hasPrefix:@"Title:"] && ![theLine hasPrefix:@"Author:"]) {   
                //ignore empty lines and lines that start with ! (old kvtml?), Title:, and Author:
                //NSLog(@"csv theLine %@", theLine);
                NSArray *values  = [theLine componentsSeparatedByString:@"\t"];
                int valueCount = [values count];
                
                if (valueCount > 1) {
                    emptyCellCount = 0;
                    if (isEmpty([values objectAtIndex:0])) {
                        emptyCellCount++;
                    }
                    //NSLog(@"csv Front %@", [values objectAtIndex:0]);
                    f = [values objectAtIndex:0];
                    if (isEmpty([values objectAtIndex:1])) {
                        emptyCellCount++;
                    }
                    //NSLog(@"csv Back %@", [values objectAtIndex:1]);
                    b = [values objectAtIndex:1];
                }
                
                if (!(emptyCellCount > 0)) {
                    [self.entries addObject:[NSDictionary dictionaryWithObjectsAndKeys: f, @"Front", b, @"Back", nil]];
                }
            }
        }       
    }
    
	if (m_quiz != nil) {
		[m_quiz release];
		m_quiz = nil;
	}
	
    m_quiz = [[iWQQuiz alloc] init];
	[m_quiz setEntries:self.entries];
	[m_quiz setFrontIdentifier:self.identifierFront];
	[m_quiz setBackIdentifier:self.identifierBack];
	[m_quiz setFileName:[[URL lastPathComponent] stringByDeletingPathExtension]];
	
	[self activateTab:self.selectedIndex];
	self.navigationItem.title = [[URL lastPathComponent] stringByDeletingPathExtension];
	//[URL release];
}

#pragma mark -
#pragma mark Managing the detail item

/*
 When setting the detail item, update the view and dismiss the popover controller if it's showing.

- (void)setDetailItem:(id)newDetailItem {
    if (detailItem != newDetailItem) {
        [detailItem release];
        detailItem = [newDetailItem retain];
        
        // Update the view.
        [self configureView];
    }

    if (popoverController != nil) {
        [popoverController dismissPopoverAnimated:YES];
    }        
}
 */

- (void)configureView {
    // Update the user interface for the detail item.
    //detailDescriptionLabel.text = [detailItem description];   
	//if (currentViewController == flashViewController) {
		//flashViewController.identifierLabel.text =  [detailItem description];
	//}
}


#pragma mark -
#pragma mark Split view support

- (void)splitViewController: (UISplitViewController*)svc willHideViewController:(UIViewController *)aViewController withBarButtonItem:(UIBarButtonItem*)barButtonItem forPopoverController: (UIPopoverController*)pc {
    barButtonItem.title = @"Vocabularies";
	[self.navigationItem setLeftBarButtonItem:barButtonItem animated:YES];
    self.popoverController = pc;
}


// Called when the view is shown again in the split view, invalidating the button and popover controller.
- (void)splitViewController: (UISplitViewController*)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
	[self.navigationItem setLeftBarButtonItem:nil animated:YES];
    self.popoverController = nil;
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
    entries = [[NSMutableArray alloc] init];

    NSMutableArray *listOfViewControllers = [[NSMutableArray alloc] init];
	HomeViewController *hvc;
    hvc = [[HomeViewController alloc] init];
    hvc.tabBarItem.image = [UIImage imageNamed:@"homeTab.png"];
	hvc.title = @"Home";
    
	[listOfViewControllers addObject:hvc];
	[hvc release];
    
    FCViewController *fcvc;
    fcvc = [[FCViewController alloc] init];
	fcvc.title = @"Flashcard";
    fcvc.tabBarItem.image = [UIImage imageNamed:@"flashTab.png"];
	[listOfViewControllers addObject:fcvc];
	[fcvc release];    
    
    MCViewController *mcvc;
    mcvc = [[MCViewController alloc] init];
	mcvc.title = @"Multiple Choice";
    mcvc.tabBarItem.image = [UIImage imageNamed:@"multipleTab.png"];
	[listOfViewControllers addObject:mcvc];
	[mcvc release]; 
    
    QAViewController *qavc;
    qavc = [[QAViewController alloc] init];
	qavc.title = @"Question & Answer";
    qavc.tabBarItem.image = [UIImage imageNamed:@"qaTab.png"];
	[listOfViewControllers addObject:qavc];
	[qavc release]; 
    
    [self setViewControllers:listOfViewControllers animated:YES];
    [listOfViewControllers release];
    
	UIBarButtonItem* button = [[UIBarButtonItem alloc] initWithTitle:@"Mode" style:UIBarButtonItemStyleBordered target:self action:@selector(doMode:)]; 
	self.navigationItem.rightBarButtonItem = button;
	[button release];

	[self activateTab:1];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.selectedViewController willRotateToInterfaceOrientation:[[UIDevice currentDevice] orientation ] duration:0];
}

/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/
/*
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}
*/
/*
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}
*/

- (void)viewDidUnload {
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    self.popoverController = nil;
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
		[self.selectedViewController setQuiz:m_quiz];
		[self.selectedViewController restart];
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
    if (modePicker == nil) {
        self.modePicker = [[[ModePickerController alloc] initWithStyle:UITableViewStylePlain] autorelease];
        modePicker.delegate = self;
        self.modePickerPopover = [[[UIPopoverController alloc] initWithContentViewController:modePicker] autorelease];               
    }
    [self.modePickerPopover presentPopoverFromBarButtonItem:sender permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
}


- (void) quizDidFinish {
	//self.repeatErrors.enabled = [m_quiz hasErrors];
}

- (BOOL) hasQuiz {
    return m_quiz != nil;
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
    [popoverController release];
	[modePicker release];
	[modePickerPopover release];
	
	[m_quiz release];
    [entries release];
	
    [super dealloc];
}

@end
