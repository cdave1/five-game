//
//  PlayerWonLevelViewController.m
//  ARTest
//
//  Created by david on 15/01/09.
//  Copyright 2009 n/a. All rights reserved.
//

#import "PlayerWonLevelViewController.h"
#import "MainViewController.h"
#import "PlayerWonLevelgroupViewController.h"

@implementation PlayerWonLevelViewController
- (void)loadView
{
	UIView *mainView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	
	UIButton *btnNext = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	btnNext.frame = CGRectMake(60.0f, 260.0f, 200.0f, 60.0f);
	[btnNext setTitle:@"Okay" forState:UIControlStateNormal];
	[btnNext addTarget:self action:@selector(btnOkayTouch:) forControlEvents:UIControlEventTouchUpInside];
	[mainView addSubview:btnNext];
	
	self.view = mainView;
}

- (void)btnOkayTouch:(id)sender
{
    [[MainViewController sharedInstance].gameViewController DestroyViews];

	if ([GameController AdvanceLevel] == NO)
	{
		[self presentModalViewController:[[[PlayerWonLevelgroupViewController alloc] init] autorelease] animated:YES];
	} 
	else 
	{
		[[MainViewController sharedInstance].gameViewController SetupViewsForGame];
		[GameController LoadGameState];
		[[MainViewController sharedInstance].gameViewController dismissModalViewControllerAnimated:YES];
	}
	
	
}

@end
