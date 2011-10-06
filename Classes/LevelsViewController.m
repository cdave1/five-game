//
//  LevelsViewController.m
//  ARTest
//
//  Created by david on 20/12/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import "LevelsViewController.h"
#import "LevelgroupEditor.h"

@implementation LevelsViewController

- init
{
	self = [super initWithStyle:UITableViewStyleGrouped];	
	return self;
}


- (void)loadView
{
	[super loadView];
	
	toolbar = [UIToolbar new];
	toolbar.barStyle = UIBarStyleDefault;
	
	// size up the toolbar and set its frame
	[toolbar sizeToFit];
	CGFloat toolbarHeight = [toolbar frame].size.height;
	CGRect mainViewBounds = self.view.bounds;
	[toolbar setFrame:CGRectMake(CGRectGetMinX(mainViewBounds),
								 CGRectGetMinY(mainViewBounds) + CGRectGetHeight(mainViewBounds) - (toolbarHeight * 2.0) + 2.0,
								 CGRectGetWidth(mainViewBounds),
								 toolbarHeight)];
	
	[self.view addSubview:toolbar];
	
	UIBarButtonItem *addLevelButton = [[UIBarButtonItem alloc] initWithTitle:@"+ Add New Level" 
																	   style:UIBarButtonItemStyleBordered 
																	  target:self 
																	  action:@selector(addLevelButtonTouch:)];
	
	NSArray *items = [NSArray arrayWithObject:addLevelButton];
	[toolbar setItems:items animated:NO];
	[addLevelButton release];
	
	// set the view height, add the toolbar underneath the table view, containing a "done" button at the bottom
	// that saves the information about the level view.
	// and then add in another view containing text boxes for the level group details
	
}


- (void)addLevelButtonTouch:(id)sender
{
	[LevelEditor setCurrentLevelgroup:[LevelgroupEditor getCurrentLevelgroup]];
	Level* newlevel = [[Level alloc] init];
	[[LevelgroupEditor getCurrentLevelgroup].levels addObject:newlevel];
	[LevelEditor setCurrentLevel:newlevel];
	[self presentModalViewController:[LevelEditor getNavigationController] animated:YES];
	
	//[[self navigationController] pushViewController:[LevelEditor viewController] animated:YES];
}


// Update the table before the view displays.
- (void)viewWillAppear:(BOOL)animated {
	self.title = [NSString stringWithFormat:@"%@", [LevelgroupEditor getCurrentLevelgroup].name];
    [self.tableView reloadData];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
	return 1;
}

- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section {
    return [LevelgroupEditor getCurrentLevelgroup].levels.count;
}


- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:@"MyIdentifier"] autorelease];
    }

    //Level *level = [self.levels objectAtIndex:indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"Level %d", indexPath.row];
    return cell;
}


- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Level *level = [[LevelgroupEditor getCurrentLevelgroup].levels objectAtIndex:indexPath.row];
	
	UINavigationController *controller = [LevelEditor getNavigationController];
	[LevelEditor setCurrentLevel:level]; 
	[self presentModalViewController:controller animated:YES];
	return nil;
}


@end

