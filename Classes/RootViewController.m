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

#import "RootViewController.h"
#import "DetailViewController.h"


@implementation RootViewController

@synthesize detailViewController;
@synthesize vocabularies, documentsDirectory;

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = NO;
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 600.0);
	
	NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
	
	// getting a BOOL
	BOOL examplesCopied = [prefs boolForKey:@"ExamplesCopied"];
	if (!examplesCopied) {
		[prefs setBool:YES forKey:@"ExamplesCopied"];
		NSBundle *appBundle = [NSBundle mainBundle];
		NSArray *exampleFiles = [appBundle URLsForResourcesWithExtension:@"kvtml" subdirectory:nil];
		//NSString *bundlePath = [appBundle pathForResource:@"XXXX" ofType:@"xxx"];
		NSEnumerator *enumerator = [exampleFiles objectEnumerator];
		id aFile;
		
		NSArray *paths = [[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask];
	    
		NSError *err;
		
		while (aFile = [enumerator nextObject]) {
			//NSLog(@"Example File: %@", aFile);
			NSURL *dest = [[paths objectAtIndex:0] URLByAppendingPathComponent: [aFile lastPathComponent]];
			NSLog(@"Example File: %@", dest);
			[[NSFileManager defaultManager] copyItemAtURL:aFile toURL:dest error:&err];
		}
	}
		
	self.vocabularies = [NSMutableArray array];
	[self enumerateVocabularies];
}

- (void) enumerateVocabularies
{
    // Create a local file manager instance
    //NSFileManager *localFileManager=[[NSFileManager alloc] init];
	
	// Get the Documents folder
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	self.documentsDirectory = [paths objectAtIndex:0];
	//NSURL *docURL = [NSURL fileURLWithPath:[paths objectAtIndex:0] isDirectory:YES];
	//NSURL *docURL = [NSURL fileURLWithPath:@"file:///localhost/Users/peter/Documents" isDirectory:YES];
	//wait self.vocabularies = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:docURL includingPropertiesForKeys:nil options:NSDirectoryEnumerationSkipsHiddenFiles error:nil];
	NSLog(@"Documents Directory: %@", documentsDirectory);
	/*
    // Enumerate the directory (specified elsewhere in your code)
    // Request the two properties the method uses, name and isDirectory
	NSArray *keys = [NSArray arrayWithObjects:NSURLNameKey, NSURLIsDirectoryKey, nil];
    // Ignore hidden files
    // The errorHandler: parameter is set to nil. Typically you'd want to present a panel
    NSDirectoryEnumerator *dirEnumerator = [localFileManager enumeratorAtURL:docURL
										    includingPropertiesForKeys:keys
											options:NSDirectoryEnumerationSkipsHiddenFiles
											errorHandler:nil];
	
    // An array to store the all the enumerated file names in
    //NSMutableArray *theArray=[NSMutableArray array];
	
    // Enumerate the dirEnumerator results, each value is stored in allURLs
	NSURL *theURL;
    while (theURL = [dirEnumerator nextObject]) {
		
        // Retrieve the file name. From NSURLNameKey, cached during the enumeration.
        NSString *fileName;
        [theURL getResourceValue:&fileName forKey:NSURLNameKey error:NULL];
		
        // Retrieve whether a directory. From NSURLIsDirectoryKey, also cached during the enumeration.
        NSNumber *isDirectory;
        [theURL getResourceValue:&isDirectory forKey:NSURLIsDirectoryKey error:NULL];
		
        // Ignore files under the _extras directory
        if (([fileName.pathExtension caseInsensitiveCompare:@".kvtml"]==NSOrderedSame) && ([isDirectory boolValue]==NO))
        {
                [self.vocabularies addObject:theURL];
			
        }
    }
	*/
	[self.vocabularies removeAllObjects];
	
	NSDirectoryEnumerator *dirEnum = [[NSFileManager defaultManager] enumeratorAtPath:self.documentsDirectory];	
	
	for (NSString *fileName in dirEnum) {
		if (([fileName.pathExtension caseInsensitiveCompare:@"kvtml"] == NSOrderedSame) ||
            ([fileName.pathExtension caseInsensitiveCompare:@"csv"]   == NSOrderedSame)) {
                [self.vocabularies addObject:[NSURL fileURLWithPath:[self.documentsDirectory stringByAppendingPathComponent:fileName] isDirectory:NO]];
		}
	}
	
    // Do something with the path URLs.
    //NSLog(@"Vocabularies - %@", self.vocabularies);
	
    // Release the localFileManager.
    //[localFileManager release];
	
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
	[detailViewController setDocument:[self.vocabularies objectAtIndex: indexPath.row]];
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
    [detailViewController release];
    [super dealloc];
}

@end
