//
//  RootViewController.m
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

#import "CHDropboxSync.h"

#import "RootViewController.h"
#import "DetailViewController.h"

@implementation RootViewController

@synthesize detailViewController = _detailViewController;
//@synthesize detailViewController;
@synthesize vocabularies, documentsDirectory;
@synthesize syncer;

#pragma mark -
#pragma mark View lifecycle

- (void)awakeFromNib
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.clearsSelectionOnViewWillAppear = NO;
        self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
    }
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    self.detailViewController.delegate = self;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.navigationItem.rightBarButtonItem.enabled = [[DBSession sharedSession] isLinked];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(linked:) name:@"Linked" object:nil];
    }
    NSError *err;
    NSFileManager *df = [NSFileManager defaultManager];
    NSArray *paths = [df URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    self.documentsDirectory = [paths objectAtIndex:0];
    NSLog(@"Documents Directory: %@", self.documentsDirectory);
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	// getting a BOOL
	BOOL examplesCopied = [prefs boolForKey:@"ExamplesCopied"];
	if (!examplesCopied) {
		[prefs setBool:YES forKey:@"ExamplesCopied"];
		NSBundle *appBundle = [NSBundle mainBundle];
		NSArray *exampleFiles = [appBundle URLsForResourcesWithExtension:@"kvtml" subdirectory:nil];
		
		NSEnumerator *enumerator = [exampleFiles objectEnumerator];
		id aFile;
		
		while (aFile = [enumerator nextObject]) {
			NSURL *dest = [self.documentsDirectory URLByAppendingPathComponent: [aFile lastPathComponent]];
			NSLog(@"Example File: %@", dest);
			[df copyItemAtURL:aFile toURL:dest error:&err];
		}
    }
		
	self.vocabularies = [NSMutableArray array];
    [self enumerateVocabularies];
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
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

// Ensure that the view controller supports rotation and that the split view can therefore show in both portrait and landscape.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}


#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)aTableView {
    // Return the number of sections.
    return 1;
}


- (NSInteger)tableView:(UITableView *)aTableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return [self.vocabularies count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    
    // Dequeue or create a cell of the appropriate type.
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    // Configure the cell.
	cell.textLabel.text = [[[self.vocabularies objectAtIndex:indexPath.row] lastPathComponent] stringByDeletingPathExtension];
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        //[tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
		[[NSFileManager defaultManager] removeItemAtURL:[self.vocabularies objectAtIndex:indexPath.row] error:nil];
		[self.vocabularies removeObjectAtIndex:indexPath.row];
		[tableView reloadData];
    }   
    /*else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }*/ 
}



/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark -
#pragma mark Table view delegate

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        [self.detailViewController setDocument:[self.vocabularies objectAtIndex: indexPath.row]];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        [[segue destinationViewController] setDocument:[self.vocabularies objectAtIndex: indexPath.row]];
        [[segue destinationViewController] setDelegate:self];
    }
}

#pragma mark -
#pragma mark UITabBarControllerDelegate methods

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[tabBarController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
	for (UIViewController *myView in tabBarController.viewControllers) {
		[myView willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	}
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
	return [(DetailViewController *) tabBarController hasQuiz]; //(m_quiz != nil); //YES
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
	NSLog(@"didSelectViewController: %d", tabBarController.selectedIndex);
	[(DetailViewController *) tabBarController activateTab:tabBarController.selectedIndex];
	[viewController viewWillAppear:NO];
}

#pragma mark -
#pragma mark Memory management

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Relinquish ownership any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    // Relinquish ownership of anything that can be recreated in viewDidLoad or on demand.
    // For example: self.myOutlet = nil;
}


- (void)dealloc {
    [self.detailViewController release];
    [super dealloc];
}


#pragma mark private methods

- (void) enumerateVocabularies
{
	[self.vocabularies removeAllObjects];
    
    //Move files out of the Inbox and remove the Inbox folder
    NSString *inboxPath  = [[self.documentsDirectory path] stringByAppendingPathComponent:@"Inbox/"];
    NSDirectoryEnumerator *inboxEnum = [[NSFileManager defaultManager] enumeratorAtPath: inboxPath];
    NSString *file;
    while (file = [inboxEnum nextObject]) {
        NSString *origFilePath = [inboxPath stringByAppendingPathComponent:[file lastPathComponent]];
        NSString *finalFilePath = [[self.documentsDirectory path] stringByAppendingPathComponent:[file lastPathComponent]];
        [[NSFileManager defaultManager] moveItemAtPath:origFilePath toPath:finalFilePath error:nil];        
    }
    [[NSFileManager defaultManager] removeItemAtPath:inboxPath error:nil];
    
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:[self.documentsDirectory path]];
    
    while (file = [dirEnum nextObject]) {
        if (([file.pathExtension caseInsensitiveCompare:@"kvtml"] == NSOrderedSame) ||
            ([file.pathExtension caseInsensitiveCompare:@"csv"] == NSOrderedSame)) {
            [self.vocabularies addObject:[self.documentsDirectory URLByAppendingPathComponent:file isDirectory:NO]];
        }
    }
    
    [self.tableView reloadData];
}


- (IBAction) doDBSync:(id)sender {
    // Now do the sync
    self.syncer = [[[CHDropboxSync alloc] init] autorelease];
    self.syncer.delegate = self;
    [self.syncer doSync];
}

// Sync has finished, so you can dealloc it now
- (void)syncComplete {
    self.syncer = nil;
    [self enumerateVocabularies];
}
#pragma mark - Linked notification

- (void)linked:(NSNotification*)n {
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        self.navigationItem.rightBarButtonItem.enabled = [[DBSession sharedSession] isLinked];
    }
}

- (IBAction) doActions:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                        delegate:self
                               cancelButtonTitle:nil
                          destructiveButtonTitle:nil
                               otherButtonTitles:@"About", nil];
    if ([[DBSession sharedSession] isLinked]) {
        [sheet addButtonWithTitle:@"Dropbox Sync"];
    }
    sheet.cancelButtonIndex = [sheet addButtonWithTitle:@"Cancel"];
    // Show the sheet
    [sheet showInView:self.view];
    [sheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    NSLog(@"Button %d", buttonIndex);
    
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        UINavigationController *navController;
        
        switch (buttonIndex) {
            case 0:
                navController =  [self.storyboard instantiateViewControllerWithIdentifier:@"about"];
                [self presentModalViewController:navController animated:YES];
                break;
            case 1:
                [self doDBSync:nil];
                break;            
            default:
                break;
        }
    }
}

@end
