//
//  PlayerWonLevelgroupViewController.m
//  ARTest
//
//  Created by david on 17/01/09.
//  Copyright 2009 n/a. All rights reserved.
//

#import "PlayerWonLevelgroupViewController.h"
#import "MainViewController.h"


@implementation PlayerWonLevelgroupViewController

- (void)loadView
{
	UIView *mainView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	UIButton *btnNext = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	btnNext.frame = CGRectMake(60.0f, 260.0f, 200.0f, 60.0f);
	[btnNext setTitle:@"Level group Okay" forState:UIControlStateNormal];
	[btnNext addTarget:self action:@selector(btnOkayTouch:) forControlEvents:UIControlEventTouchUpInside];
	[mainView addSubview:btnNext];
	
	self.view = mainView;
}


- (void)btnOkayTouch:(id)sender
{
	[GameController PlayerWonLevelgroup];
	
	
	
	
	// Jump to the next level group if we've run out of levels
	if ([GameController AdvanceLevelgroup] == NO)
	{
		[[MainViewController sharedInstance].gameViewController DestroyViews];
		// Player won the game.
		[[MainViewController sharedInstance].gameViewController dismissModalViewControllerAnimated:YES];
		[[MainViewController sharedInstance] dismissModalViewControllerAnimated:YES];
		return;
	} 
	else 
	{
		[[MainViewController sharedInstance].gameViewController DestroyViews];
		[GameController AdvanceLevel];	
		[[MainViewController sharedInstance].gameViewController SetupViewsForGame];
		[GameController LoadGameState];
		[[MainViewController sharedInstance].gameViewController dismissModalViewControllerAnimated:YES];
	}
}


@end
