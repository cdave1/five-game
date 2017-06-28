//
//  GameViewController.m
//  ARTest
//
//  Created by david on 23/12/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import "GameViewController.h"
#import "MainViewController.h"

@implementation GameViewController

@synthesize gameAreaView;
@synthesize gameBottomMenuView;
@synthesize inGameMenuView;
@synthesize lblPoints;


- (void)loadView
{
	mainView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	self.view = mainView;
}


- (void)SetupViewsForGame
{
	if (mainView == nil)
	{
		[self loadView];
	}
	
	// Initialise the Game Area View and top and bottom menu views.
	gameTopMenuView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 320.0f, 40.0f)];
	lblPoints = [[UILabel alloc] initWithFrame:CGRectMake(190.0f, 5.0f, 120.0f, 30.0f)];
	lblPoints.backgroundColor = [UIColor clearColor];
	lblPoints.opaque = NO;
	lblPoints.textAlignment = UITextAlignmentRight;
	lblPoints.textColor = [UIColor grayColor];
	lblPoints.highlightedTextColor = [UIColor blackColor];
	lblPoints.font = [UIFont systemFontOfSize:12];
	lblPoints.text = @"0";
	
	UIButton *btnMenu = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	btnMenu.frame = CGRectMake(5.0f, 5.0f, 120.0f, 30.0f);
	[btnMenu setTitle:@"Menu" forState:UIControlStateNormal];
	btnMenu.backgroundColor = [UIColor whiteColor];
	[btnMenu addTarget:self action:@selector(btnMenuTouchInside:) forControlEvents:UIControlEventTouchUpInside];
	
//#if DEBUG
	UIButton *btnWinLevel = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	btnWinLevel.frame = CGRectMake(150.0f, 5.0f, 120.0f, 30.0f);
	[btnWinLevel setTitle:@"Skip Level" forState:UIControlStateNormal];
	btnWinLevel.backgroundColor = [UIColor whiteColor];
	[btnWinLevel addTarget:self action:@selector(btnWinLevelTouch:) forControlEvents:UIControlEventTouchUpInside];
	
	[gameTopMenuView addSubview:btnWinLevel];
//#endif
	
	[gameTopMenuView addSubview:btnMenu];
	[gameTopMenuView addSubview:lblPoints];
	[self.view addSubview:gameTopMenuView];
	
	//backgroundView = [[BackgroundView alloc] initWithFrame:CGRectMake(0.0f, 40.0f, 320.0f, 400.0f)];
	//backgroundView.image = [UIImage imageNamed:[NSString stringWithFormat:@"bg_%d.png", [GameController GetLevelgroupIndex] - 1]];  
	//[self.view addSubview:backgroundView];
	
	self.gameAreaView = [[GameAreaView alloc] initWithFrame:CGRectMake(0.0f, 40.0f, 320.0f, 400.0f)];
	[self.view addSubview:self.gameAreaView];
	
	self.gameBottomMenuView = [[GameBottomMenuView alloc] initWithFrame:CGRectMake(0.0f, 440.0f, 320.0f, 40.0f)];
	[self.view addSubview:self.gameBottomMenuView];
	
	self.inGameMenuView = [[InGameMenuView alloc] initWithFrame:CGRectMake(40.0f, 80.0f, 240.0f, 340.0f)];
	self.inGameMenuView.hidden = YES;
	[self.view addSubview:self.inGameMenuView];
	
	
	[self.view bringSubviewToFront:self.gameAreaView];
	[self.view setNeedsDisplay];
}


- (void)SetPoints:(NSInteger)points
{
	lblPoints.text = [[NSNumber numberWithInteger:points] stringValue];
}


- (void)btnWinLevelTouch:(id)sender
{
	[GameController AddPointsToGame:100000];
	[self presentModalViewController:[[[PlayerWonLevelViewController alloc] init] autorelease] animated:YES];
}


- (void)btnMenuTouchInside:(id)sender
{
	// Pause the game
	[GameController PauseGame];
	
	// Show the in game menu
	[MainViewController sharedInstance].gameViewController.inGameMenuView.hidden = NO;
	[[MainViewController sharedInstance].gameViewController.view bringSubviewToFront:[MainViewController sharedInstance].gameViewController.inGameMenuView];
}


- (void)DestroyViews
{	
	if (gameTopMenuView != nil) {
		[gameTopMenuView removeFromSuperview];
		[lblPoints removeFromSuperview];
		[gameTopMenuView release];
		[lblPoints release];
		gameTopMenuView = nil;
		lblPoints = nil;
	}
	
	if (self.gameAreaView != nil) {
		[self.gameAreaView release];
		self.gameAreaView = nil;
	}
	
	if (backgroundView) {
		[backgroundView release];
		backgroundView = nil;
	}
	
	if (self.gameBottomMenuView) {
		[self.gameBottomMenuView release];
		self.gameBottomMenuView = nil;
	}
	
	[mainView release];
	mainView = nil;
}



- (void)dealloc
{
	[self DestroyViews];
	[super dealloc];
}



@end
