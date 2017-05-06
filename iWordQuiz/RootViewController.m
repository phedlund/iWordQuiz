//
//  RootViewController.m
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

#import "RootViewController.h"
#import "DetailViewController.h"
#import "WQDocument.h"
#import "WQUtils.h"
#import "CHDropboxSync.h"
#import "UIColor+PHColor.h"

NSString* WQDocmentFileExtension = @"kvtml";
NSString* DisplayDetailSegue = @"DisplayDetailSegue";
NSString* WQDocumentsDirectoryName = @"Documents";

@interface RootViewController () {
    NSInteger _currentRow;
}

@end

@implementation RootViewController

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    //self.detailViewController = (DetailViewController *)self.dynamicsDrawerViewController;
    self.detailViewController.delegate = self;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(linked:) name:@"Linked" object:nil];
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        self.navigationController.navigationBar.tintColor = [UIColor phIconColor];
        self.navigationController.navigationBar.barTintColor = [UIColor phBackgroundColor];
        
        NSShadow *shadow = [[NSShadow alloc] init];
        shadow.shadowColor = [UIColor clearColor];
        shadow.shadowBlurRadius = 0.0;
        shadow.shadowOffset = CGSizeMake(0.0, 0.0);
        
        [self.navigationController.navigationBar setTitleTextAttributes:
         [NSDictionary dictionaryWithObjectsAndKeys:
          [UIColor phIconColor], NSForegroundColorAttributeName,
          shadow, NSShadowAttributeName, nil]];
        
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newFileURL:) name:@"FileURL" object:nil];
    NSError *err;
     
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	// getting a BOOL
	BOOL examplesCopied = [prefs boolForKey:@"ExamplesCopied"];
	if (!examplesCopied) {
		[prefs setBool:YES forKey:@"ExamplesCopied"];
		NSBundle *appBundle = [NSBundle mainBundle];
		NSArray *exampleFiles = [appBundle URLsForResourcesWithExtension:@"kvtml" subdirectory:nil];
		
		NSEnumerator *enumerator = [exampleFiles objectEnumerator];
		id aFile;
		NSFileManager *fm = [NSFileManager defaultManager];
        NSArray *paths = [fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        NSURL *docDir = [paths objectAtIndex:0];
		while (aFile = [enumerator nextObject]) {
			NSURL *dest = [docDir URLByAppendingPathComponent: [aFile lastPathComponent]];
			NSLog(@"Example File: %@", dest);
			[fm copyItemAtURL:aFile toURL:dest error:&err];
		}
    }
    
    _currentRow = 0;
	_vocabularies = [[NSMutableArray alloc] init];
    [self enumerateVocabularies];
}

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
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
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
        BOOL deletingCurrentRow = (indexPath.row == _currentRow);
		[[NSFileManager defaultManager] removeItemAtURL:[self.vocabularies objectAtIndex:indexPath.row] error:nil];
		[self.vocabularies removeObjectAtIndex:indexPath.row];
		[tableView reloadData];
        if (deletingCurrentRow) {
            [self.detailViewController setDetailItem:nil];
        }
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
    _currentRow = indexPath.row;
    NSFileManager *fm = [NSFileManager defaultManager];
    if (![fm fileExistsAtPath:[[self.vocabularies objectAtIndex: _currentRow] path]]) {
        [self enumerateVocabularies];
        [aTableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [self.detailViewController setDetailItem:[self.vocabularies objectAtIndex: _currentRow]];
        [self.dynamicsDrawerViewController setPaneState:MSDynamicsDrawerPaneStateClosed inDirection:MSDynamicsDrawerDirectionLeft animated:YES allowUserInterruption:YES completion:^{
            //
        }];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = self.tableView.indexPathForSelectedRow;
        [[segue destinationViewController] setDetailItem:[self.vocabularies objectAtIndex: indexPath.row]];
        [[segue destinationViewController] setDelegate:self];
    }
    
    if ([[segue identifier] isEqualToString:@"NewDocument"]) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            UINavigationController *navController = [segue destinationViewController];
            [(WQNewFileViewController*)navController.topViewController setDelegate:self];
        } else {
            [[segue destinationViewController] setDelegate:self];
        }
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
	NSInteger index = 0;
    index = [tabBarController.viewControllers indexOfObject:viewController];
    return [(DetailViewController *) tabBarController hasEnoughEntries:index]; //(m_quiz != nil); //YES
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
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




#pragma mark private methods

- (void) enumerateVocabularies
{
	[self.vocabularies removeAllObjects];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *paths = [fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
    NSURL *docDir = [paths objectAtIndex:0];

    //Move files out of the Inbox and remove the Inbox folder
    NSString *inboxPath  = [[docDir path] stringByAppendingPathComponent:@"Inbox/"];
    NSDirectoryEnumerator *inboxEnum = [[NSFileManager defaultManager] enumeratorAtPath: inboxPath];
    NSString *file;
    while (file = [inboxEnum nextObject]) {
        NSString *origFilePath = [inboxPath stringByAppendingPathComponent:[file lastPathComponent]];
        NSString *finalFilePath = [[docDir path] stringByAppendingPathComponent:[file lastPathComponent]];
        [[NSFileManager defaultManager] moveItemAtPath:origFilePath toPath:finalFilePath error:nil];        
    }
    [[NSFileManager defaultManager] removeItemAtPath:inboxPath error:nil];
    
    NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:[docDir path]];
    
    while (file = [dirEnum nextObject]) {
        if (([file.pathExtension caseInsensitiveCompare:@"kvtml"] == NSOrderedSame) ||
            ([file.pathExtension caseInsensitiveCompare:@"csv"] == NSOrderedSame)) {
            [self.vocabularies addObject:[docDir URLByAppendingPathComponent:file isDirectory:NO]];
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark - Dropbox syncer delegate

// Sync has finished, so you can dealloc it now
- (void)syncComplete {
    self.syncer = nil;
    [self enumerateVocabularies];
}

#pragma mark - Notifications

- (void)linked:(NSNotification*)n {
    /*if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.menuButton.enabled = [[DBSession sharedSession] isLinked];
    }*/
}

- (void)newFileURL:(NSNotification*)n {
    NSURL *newURL = (NSURL*)[n.userInfo valueForKey:@"URL"];
    [self.vocabularies replaceObjectAtIndex:_currentRow withObject:newURL];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:_currentRow inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
}


- (IBAction) doActions:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil
                                        delegate:self
                               cancelButtonTitle:nil
                          destructiveButtonTitle:nil
                               otherButtonTitles:@"New Vocabulary", nil];
    if ([[DBSession sharedSession] isLinked]) {
        [sheet addButtonWithTitle:@"Sync With Dropbox"];
        [sheet addButtonWithTitle:@"Unlink Dropbox"];
    } else {
        [sheet addButtonWithTitle:@"Link Dropbox"];
    }
    sheet.cancelButtonIndex = [sheet addButtonWithTitle:@"Cancel"];
    // Show the sheet
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        [sheet showFromBarButtonItem:self.menuButton animated:YES];
    } else {
        [sheet showInView:self.view];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSLog(@"Button %ld", (long)buttonIndex);
    
    if (buttonIndex != actionSheet.cancelButtonIndex) {
        NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
        if ([buttonTitle isEqualToString:@"New Vocabulary"]) {
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                UINavigationController *navController = [self.storyboard instantiateViewControllerWithIdentifier:@"newVocabulary"];
                [(WQNewFileViewController*)navController.topViewController setDelegate:self];
                [self presentViewController:navController animated:YES completion:nil];
            } else {
                WQNewFileViewController *newController = [self.storyboard instantiateViewControllerWithIdentifier:@"newVocabulary"];
                newController.delegate = self;
                [self.navigationController pushViewController:newController animated:YES];
            }
        }
        if ([buttonTitle isEqualToString:@"Sync With Dropbox"]) {
            self.syncer = [[CHDropboxSync alloc] init];
            self.syncer.delegate = self;
            [self.syncer doSync];
        }
        if ([buttonTitle isEqualToString:@"Link Dropbox"]) {
            [[DBSession sharedSession] linkFromController:self];
        }
        if ([buttonTitle isEqualToString:@"Unlink Dropbox"]) {
            [[DBSession sharedSession] unlinkAll];
            [[[UIAlertView alloc] initWithTitle:@"Account Unlinked!"
                                        message:@"Your Dropbox account has been unlinked"
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil]
             show];
        }
    }
}

# pragma mark -
# pragma mark WQNewFileViewControllerDelegate

- (BOOL)createNewDocument:(WQNewFileViewController*)aWQNewFileViewController {
    //NSInteger docCount = 1;     // Start with 1 and go from there.
    if ([WQUtils isEmpty:aWQNewFileViewController.fileNameTextField.text]) {
        return false;
    }
    NSString* newDocName = aWQNewFileViewController.fileNameTextField.text;
    
    // At this point, the document list should be up-to-date.
    BOOL done = NO;
    while (!done) {
        newDocName = [NSString stringWithFormat:@"%@.%@", newDocName, WQDocmentFileExtension];
        
        // Look for an existing document with the same name. If one is
        // found, increment the docCount value and try again.
        BOOL nameExists = NO;
        for (NSURL* aURL in _vocabularies) {
            if ([[aURL lastPathComponent] isEqualToString:newDocName]) {
                nameExists = YES;
                break;
            }
        }
        
        // If the name wasn't found, exit the loop.
        if (!nameExists)
            done = YES;
        else {
            return NO;
        }
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // Create the new URL object on a background queue.
        NSFileManager *fm = [NSFileManager defaultManager];
        NSArray *paths = [fm URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
        NSURL *newDocumentURL = [paths objectAtIndex:0]; //[fm URLForUbiquityContainerIdentifier:nil];
        //newDocumentURL = [newDocumentURL
        //URLByAppendingPathComponent:STEDocumentsDirectoryName
        //isDirectory:YES];
        newDocumentURL = [newDocumentURL URLByAppendingPathComponent:newDocName];
        
        // Perform the remaining tasks on the main queue.
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the data structures and table.
            [_vocabularies addObject:newDocumentURL];
            
            WQDocument *document = [[WQDocument alloc] initWithFileURL:newDocumentURL];
            NSString *frontId = aWQNewFileViewController.frontTextField.text;
            if ([WQUtils isEmpty:frontId]) {
                frontId = @"Front";
            }
            NSString *backId = aWQNewFileViewController.backTextField.text;
            if ([WQUtils isEmpty:backId]) {
                backId = @"Back";
            }
            
            document.frontIdentifier = frontId;
            document.backIdentifier = backId;
            
            for (int i = 0; i < 10; ++i) {
                [document.entries addObject:@[@"", @""]];
            }
            
            [document updateChangeCount:UIDocumentChangeDone];
            [document saveToURL:newDocumentURL forSaveOperation:UIDocumentSaveForCreating completionHandler: ^(BOOL success) {
                if (success) {
                    
                    // Update the table.
                    NSIndexPath* newCellIndexPath =
                    [NSIndexPath indexPathForRow:([_vocabularies count] - 1) inSection:0];
                    [self.tableView insertRowsAtIndexPaths:@[newCellIndexPath]
                                          withRowAnimation:UITableViewRowAnimationAutomatic];
                    
                    [self.tableView selectRowAtIndexPath:newCellIndexPath
                                                animated:YES
                                          scrollPosition:UITableViewScrollPositionMiddle];
                    
                    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                        [self.detailViewController setSelectedIndex:0];
                        [self.detailViewController setDetailItem:newDocumentURL];
                    }
                    // Segue to the detail view controller to begin editing.
                    //UITableViewCell* selectedCell = [self.tableView
                    //                                 cellForRowAtIndexPath:newCellIndexPath];
                    //[self performSegueWithIdentifier:DisplayDetailSegue sender:selectedCell];
                    
                    // Reenable the Add button.
                    //self.addButton.enabled = YES;
                }

            }];

        });
    });
    
    return true;
}

@end
