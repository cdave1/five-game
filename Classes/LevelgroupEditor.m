//
//  LevelgroupEditor.m
//  ARTest
//
//  Created by david on 21/12/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import "LevelgroupEditor.h"

static UINavigationController *navigationController;
static Levelgroup *currentLevelgroup;
static LevelgroupViewController *levelgroupViewController;
static LevelsViewController *levelsViewController;

@implementation LevelgroupEditor

+ (void) dealloc
{
	[levelsViewController release];
	[super dealloc];
}


+ (UINavigationController *)getNavigationController
{
	if (navigationController == nil) 
    {
		levelsViewController = [[LevelsViewController alloc] init];
		
		navigationController = [[UINavigationController alloc] initWithRootViewController:levelsViewController];
		navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
		navigationController.navigationBarHidden = NO;
		
		CGRect mainViewBounds = [UIScreen mainScreen].bounds;
		
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
		
		[doneButton release];
		[cancelButton release];
	}
	return navigationController;
}


+ (LevelsViewController *)getLevelsViewController
{
	if (levelsViewController == nil)
	{
		levelsViewController = [[LevelsViewController alloc] init];
	}
	return levelsViewController;
}


+ (LevelgroupViewController *)getLevelgroupViewController
{
	if (levelgroupViewController == nil)
	{
		levelgroupViewController = [[LevelgroupViewController alloc] init];
		levelgroupViewController.editing = YES;
		
		
	}
	return levelgroupViewController;
}


+ (void)doneButtonTouch:(id)sender
{
	[Levelgroup SaveLevelGroups];
	[LevelgroupEditor setCurrentLevelgroup:nil];
	[[LevelgroupEditor getNavigationController] dismissModalViewControllerAnimated:YES];
}


+ (void)cancelButtonTouch:(id)sender
{
	[Levelgroup ReloadLevelGroups];
	[[LevelgroupEditor getNavigationController] dismissModalViewControllerAnimated:YES];
}


+ (Levelgroup *)getCurrentLevelgroup;
{
	return currentLevelgroup;
}


+ (void)setCurrentLevelgroup:(Levelgroup *)levelgroup
{
	currentLevelgroup = levelgroup;
}


+ (void)ReloadViews
{
	[levelgroupViewController loadView];
}

@end
