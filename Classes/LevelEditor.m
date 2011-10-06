//
//  LevelEditor.m
//  ARTest
//
//  Created by david on 21/12/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import "LevelEditor.h"

//static LevelEditorViewController *levelEditorViewController;
static UINavigationController *navigationController;
static TileEditorViewController *tileEditorViewController;
static Level *currentLevel;
static Levelgroup *currentLevelgroup;
static MapViewController *mapViewController;
static SettingsViewController *settingsViewController;
static QueueViewController *queueViewController;
static GoalsViewController *goalsViewController;
static BonusesViewController *bonusesViewController;
static TutorialsViewController *tutorialsViewController;

@implementation LevelEditor



+ (UINavigationController *)getNavigationController
{
	if (navigationController == nil) {
		mapViewController = [[MapViewController alloc] init];
		settingsViewController = [[SettingsViewController alloc] init];
		queueViewController = [[QueueViewController alloc] init];
		goalsViewController = [[GoalsViewController alloc] init];
		bonusesViewController = [[BonusesViewController alloc] init];
		tutorialsViewController = [[TutorialsViewController alloc] init];
		tileEditorViewController = [[TileEditorViewController alloc] init];
		
		navigationController = [[UINavigationController alloc] initWithRootViewController:mapViewController];
		navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
		navigationController.navigationBarHidden = YES;
		
		settingsViewController.editing = YES;
		
		// Tab bar at top of screen with a segmented control
		UIToolbar *tabsBar = [UIToolbar new];
		tabsBar.barStyle = UIBarStyleBlackTranslucent;
		[tabsBar sizeToFit];
		CGFloat tabsBarHeight = [tabsBar frame].size.height;
		CGRect mainViewBounds = [UIScreen mainScreen].bounds;
		[tabsBar setFrame:CGRectMake(CGRectGetMinX(mainViewBounds),
									 CGRectGetMinY(mainViewBounds), // + CGRectGetHeight(mainViewBounds) - (tabsBarHeight * 3.0) + 2.0 + 22.0f,
									 CGRectGetWidth(mainViewBounds),
									 tabsBarHeight)];
		[navigationController.view addSubview:tabsBar];
		
		UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:
												[NSArray arrayWithObjects:@"Map", @"Settings", @"Queue", @"Goals", @"Tuts", nil]];
		[segmentedControl addTarget:self action:@selector(toggleEditorNavigationView:) forControlEvents:UIControlEventValueChanged];
		segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
		segmentedControl.backgroundColor = [UIColor clearColor];
		segmentedControl.frame = CGRectMake(10.0f, 10.0f, [segmentedControl frame].size.width, [segmentedControl frame].size.height);
		[segmentedControl sizeToFit];
		segmentedControl.selectedSegmentIndex = 0;
		
		UIBarButtonItem *tabs = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
		NSArray *tabItems = [NSArray arrayWithObjects:tabs, nil];
		[tabsBar setItems:tabItems animated:NO];
		
		
		
		// button bar at bottom with controls for saving.
		UIToolbar *buttonBar = [UIToolbar new];
		buttonBar.barStyle = UIBarStyleBlackOpaque;
		[buttonBar sizeToFit];
		CGFloat buttonBarHeight = [buttonBar frame].size.height;
		[buttonBar setFrame:CGRectMake(CGRectGetMinX(mainViewBounds),
									 CGRectGetMinY(mainViewBounds) + CGRectGetHeight(mainViewBounds) - (buttonBarHeight),
									 CGRectGetWidth(mainViewBounds),
									 buttonBarHeight)];
		[navigationController.view addSubview:buttonBar];
		UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" 
																	   style:UIBarButtonItemStyleDone 
																	  target:self 
																	  action:@selector(doneButtonTouch:)];
		UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																	  target:self 
																	  action:@selector(cancelButtonTouch:)];
		NSArray *buttonItems = [NSArray arrayWithObjects:doneButton, cancelButton, nil];
		[buttonBar setItems:buttonItems animated:NO];
		
		
		
		[tabs release];
		[doneButton release];
		[cancelButton release];
		[segmentedControl release];
		
	}
	return navigationController;
}


+ (void)doneButtonTouch:(id)sender
{
	
	// Save the level;
	Level* lev = [LevelEditor getCurrentLevel];
	if (lev == nil)
	{
		// it's a new level.
		lev = [[Level alloc] init];
		if (currentLevelgroup.levels == nil)
		{
			currentLevelgroup.levels = [NSMutableArray array];
		}
		
		[currentLevelgroup.levels addObject:lev];
	} 
	else
	{
		// delete all of its tiles
		if (currentLevelgroup.levels == nil)
		{
			currentLevelgroup.levels = [NSMutableArray array];
		}
	}
	
	// find the boundaries of the play area:
	int limit = kMapTilesWidthCount * kMapTilesHeightCount;
	short min_col = kMapTilesWidthCount, max_col = 0, min_row = kMapTilesHeightCount, max_row = 0;
	for (int i = 0; i < limit; i++)
	{
		MapTileView *view = (MapTileView *)[mapViewController.mapView viewWithTag:i + 100];
		
		if (view != nil) {
			// find the col and row, and then set the min_col etc
			short row = floor(i / kMapTilesWidthCount);
			short col = (i % kMapTilesWidthCount);
			
			min_col = (col < min_col) ? col : min_col;
			max_col = (col >= max_col) ? col : max_col;
			
			min_row = (row < min_row) ? row : min_row;
			max_row = (row >= max_row) ? row : max_row;	
		}
	}
	
	// Have the width/height from this:
	// Create new level object
	lev.width = (max_col - min_col + 1); // counter the obiwan
	lev.height = (max_row - min_row + 1);
	
	// Go through all the mapViews from min_col/min_row to max_col/max_row,
	// creating tiles for each position. 
	[lev.tiles release];
	[lev.startingPieces release];
	lev.tiles = nil;
	lev.startingPieces = nil;
	lev.tiles = [[NSMutableArray array] retain];
	lev.startingPieces = [[NSMutableArray array] retain];
	
	for (int j = min_row; j <= max_row; j++)
	{
		for (int i = min_col; i <= max_col; i++)
		{
			int pos = ((j * kMapTilesWidthCount) + i);
			int index = (((j - min_row) * lev.width) + (i - min_col));
			
			MapTileView *mtv = (MapTileView *)[mapViewController.mapView viewWithTag:pos + 100];
			
			if (mtv == nil) {
				Tile *tile = [[Tile alloc] init];
				tile.position = (pos);
				tile.index = index;
				tile.type = WallTile;
				[lev.tiles addObject:tile];
				[tile release];
			} 
			else
			{
				Tile* tile = mtv.tile;
				tile.index = index;
				[lev.tiles addObject:tile];
				if (tile.isEmpty == NO)
				{
					[lev.startingPieces addObject:tile];
				}
			}
		}
	}
	
	[Levelgroup SaveLevelGroups];
	[mapViewController.mapView resetView];
	
	[LevelEditor setCurrentLevel:nil];
	[[LevelEditor getNavigationController] dismissModalViewControllerAnimated:YES];
}


+ (void)cancelButtonTouch:(id)sender
{
	[mapViewController.mapView resetView];
	[LevelEditor setCurrentLevel:nil];
	[[LevelEditor getNavigationController] dismissModalViewControllerAnimated:YES];
}


// TODO: Add the tile being modified.
+ (void)showTileEditorDialog:(MapTileView *)tv
{
	tileEditorViewController.tileView = tv;
	[[LevelEditor getNavigationController] presentModalViewController:tileEditorViewController animated:YES];
}


+ (void)toggleEditorNavigationView:(id)sender
{
	switch ([sender selectedSegmentIndex])
	{
		case 0:	
		{
			[[LevelEditor getNavigationController] popToRootViewControllerAnimated:YES];
			
			break;
		}
		case 1:
		{
			[[LevelEditor getNavigationController] popToRootViewControllerAnimated:NO];
			[[LevelEditor getNavigationController] pushViewController:settingsViewController animated:YES];
			break;			
		}
		case 2: 
		{	
			[[LevelEditor getNavigationController] popToRootViewControllerAnimated:NO];
			[[LevelEditor getNavigationController] pushViewController:queueViewController animated:YES];
			break;
		}
		case 3:
		{
			[[LevelEditor getNavigationController] popToRootViewControllerAnimated:NO];
			[[LevelEditor getNavigationController] pushViewController:goalsViewController animated:YES];			
			break;
		}
		case 4:
		{
			[[LevelEditor getNavigationController] popToRootViewControllerAnimated:NO];
			[[LevelEditor getNavigationController] pushViewController:tutorialsViewController animated:YES];			
			break;
		}
	}
}


+ (Level *)getCurrentLevel
{
	return currentLevel;
}


+ (void)setCurrentLevel:(Level *)level 
{
	if (level != nil)
	{
		[mapViewController.mapView loadLevel:level];
	}
	currentLevel = level;
}


+ (Levelgroup *)getCurrentLevelgroup;
{
	return currentLevelgroup;
}


+ (void)setCurrentLevelgroup:(Levelgroup *)levelgroup
{
	currentLevelgroup = levelgroup;
}


@end
