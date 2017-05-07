//
//  ModePickerController.m
//  iWordQuiz
//

/************************************************************************

Copyright 2012-2017 Peter Hedlund peter.hedlund@me.com

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

#import "ModePickerController.h"
#import "UIColor+PHColor.h"

@interface ModePickerController () {
    NSInteger _currentMode;
}

@end

@implementation ModePickerController

@synthesize modes;
@synthesize delegate;

- (NSArray *)modes {
    if (!modes) {
        modes = @[@"Front to Back In Order",
                  @"Back To Front In Order",
                  @"Front To Back Randomly",
                  @"Back To Front Randomly",
                  @"Back <-> Front Randomly"];
    }
    return modes;
}

#pragma mark -
#pragma mark View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    self.clearsSelectionOnViewWillAppear = YES;
    //self.preferredContentSize = CGSizeMake(290.0, 264.0);
    self.tableView.scrollEnabled = NO;
    self.tableView.separatorColor = [UIColor phPopoverBorderColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Override to allow orientations other than the default portrait orientation.
    return YES;
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
	return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    NSInteger result;
	if (section == 0) {
        result = self.modes.count;
    } else {
        result = 1;
    }
    return result;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.backgroundColor = [UIColor phPopoverBackgroundColor];
        cell.textLabel.textColor = [UIColor phPopoverIconColor];
        cell.tintColor = [UIColor phIconColor];
    }
    
	[cell setAccessoryType:UITableViewCellAccessoryNone];

    if (indexPath.section == 0) {
        cell.textLabel.text = [self.modes objectAtIndex:indexPath.row];
        NSInteger r = [self.delegate selectedMode] - 1;
        if (r == indexPath.row) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            _currentMode = r;
        }

    } else {
        cell.textLabel.text = @"Show Score As Percent";
        if ([[NSUserDefaults standardUserDefaults] boolForKey:@"ScoreAsPercent"]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
    }
    
    return cell;
}

#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0f;
}

- (UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGRect frame = CGRectMake(0, 0, 200, 30);
    UIView *customView = [[UIView alloc] initWithFrame:frame];
    UILabel *headerLabel = [[UILabel alloc] init];
    [customView addSubview:headerLabel];
    customView.backgroundColor = [UIColor phPopoverButtonColor];
    
    frame.origin.x = 10;
    frame.size.width = frame.size.width - 10;
    
    headerLabel.frame = frame;
    headerLabel.backgroundColor = [UIColor phPopoverButtonColor];
    headerLabel.textColor = [UIColor phIconColor];
    headerLabel.font = [UIFont systemFontOfSize:14];
    if (section == 0) {
        headerLabel.text = @"MODE";
    } else {
        headerLabel.text = @"SCORE";
    }
    return customView;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        if (_currentMode == indexPath.row) {
            return;
        }
        _currentMode = indexPath.row;
        [self.tableView reloadData];
        if (self.delegate != nil) {
            [self.delegate modeSelected:_currentMode];
        }
    } else {
        [[NSUserDefaults standardUserDefaults] setBool:![[NSUserDefaults standardUserDefaults] boolForKey:@"ScoreAsPercent"] forKey:@"ScoreAsPercent"];
        if (self.delegate != nil) {
            [self.delegate modeSelected:-1];
        }
    }
   
}

@end
