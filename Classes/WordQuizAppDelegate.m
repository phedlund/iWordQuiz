//
//  WordQuizAppDelegate.m
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

#import "WordQuizAppDelegate.h"
#import "RootViewController.h"
#import "DetailViewController.h"

@implementation iWordQuizAppDelegate

@synthesize window, splitViewController, rootViewController, detailViewController;

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
    // Add the split view controller's view to the window and display.
    detailViewController.delegate = self;
    [window addSubview:splitViewController.view];
    [window makeKeyAndVisible];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	//Application launch with attachment
	if ([url isFileURL]) {
		[self.rootViewController enumerateVocabularies];
		
		UITableView *tableView = ((UITableViewController *)self.rootViewController).tableView;
		[tableView reloadData];
	}
	else
	{
		// Handle custom URL scheme
	}	
	return YES;
}


- (void) aboutDidFinish {
	[splitViewController dismissModalViewControllerAnimated:YES];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive.
     */
}


- (void)applicationWillTerminate:(UIApplication *)application {
    /*
     Called when the application is about to terminate.
     */
}


#pragma mark -
#pragma mark TabBarController management

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
	return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[detailViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
	for (UIViewController *myView in tabBarController.viewControllers) {
		[myView willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	}
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
	return [detailViewController hasQuiz]; //(m_quiz != nil); //YES
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
	NSLog(@"didSelectViewController: %d", tabBarController.selectedIndex);
	[detailViewController activateTab:tabBarController.selectedIndex];
	[viewController viewWillAppear:NO];
}


#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
}


- (void)dealloc {
    [splitViewController release];
    [window release];
    [super dealloc];
}

@end
