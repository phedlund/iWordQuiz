//
//  HomeViewController.m
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

#import "HomeViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation HomeViewController

@synthesize containerView;
@synthesize spreadView;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"background"]];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(edited:) name:@"Edited" object:nil];
    spreadView.dataSource = (id)self.tabBarController;
    spreadView.delegate = (id) self.tabBarController;
    spreadView.selectionMode = MDSpreadViewSelectionModeCell;
    [spreadView reloadData];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	[super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void) viewWillLayoutSubviews {
    NSLog(@"Frame for layout: %@", NSStringFromCGRect([UIScreen mainScreen].applicationFrame));
    [super viewWillLayoutSubviews];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        int width;
        int height;
        if (([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeLeft) ||
            ([UIApplication sharedApplication].statusBarOrientation == UIDeviceOrientationLandscapeRight)) {
            width = CGRectGetHeight([UIScreen mainScreen].applicationFrame);
            height = CGRectGetWidth([UIScreen mainScreen].applicationFrame) - 44 - 49 + 20;
        } else {
            width = CGRectGetWidth([UIScreen mainScreen].applicationFrame);
            height = CGRectGetHeight([UIScreen mainScreen].applicationFrame) - 44 - 49 + 20;
        }
        NSLog(@"Width: %d, Height: %d", width, height);
        self.spreadView.frame = CGRectMake(0, 0, width, height);
        [spreadView reloadData];
    }
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        if (([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeLeft) ||
            ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationLandscapeRight)) {
            self.containerView.frame = CGRectMake(20, 20, 665, 615);
            self.spreadView.frame = CGRectMake(0, 0, 665, 615);
        } else {
            self.containerView.frame = CGRectMake(20, 20, 665, 864);
            self.spreadView.frame = CGRectMake(0, 0, 665, 864);
        }
        
        containerView.layer.borderWidth = 1.0;
        containerView.layer.borderColor = [[UIColor grayColor] CGColor];
        containerView.layer.shadowColor = [[UIColor blackColor] CGColor];
        containerView.layer.shadowOpacity = 0.5f;
        containerView.layer.shadowOffset = CGSizeMake(0, 4);
        containerView.layer.shadowRadius = 6.0f;
        containerView.layer.masksToBounds = NO;
        
        CGSize size = containerView.bounds.size;
        CGFloat curlFactor = 15.0f;
        CGFloat shadowDepth = 5.0f;
        
        UIBezierPath *path = [UIBezierPath bezierPath];
        [path moveToPoint:CGPointMake(0.0f, 0.0f)];
        [path addLineToPoint:CGPointMake(size.width + shadowDepth, 0.0f)];
        [path addCurveToPoint:CGPointMake(size.width, size.height + shadowDepth)
                controlPoint1:CGPointMake(size.width - curlFactor, shadowDepth + curlFactor)
                controlPoint2:CGPointMake(size.width +shadowDepth, size.height - curlFactor)];
        [path addCurveToPoint:CGPointMake(0.0f, size.height + shadowDepth)
                controlPoint1:CGPointMake(size.width - curlFactor, size.height + shadowDepth - curlFactor)
                controlPoint2:CGPointMake(curlFactor, size.height + shadowDepth - curlFactor)];
        
        containerView.layer.shadowPath = path.CGPath;
    }
}

- (void) start {
    [spreadView reloadData];
	[self slotCheck];
}

- (void) restart {
	[self start];
}

- (void) slotCheck {
	//Do nothing
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


- (void)viewDidUnload {
    [self setSpreadView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}



- (void)edited:(NSNotification*)n {
    [spreadView reloadData];
}

@end
