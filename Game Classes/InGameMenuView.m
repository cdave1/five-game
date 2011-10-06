//
//  InGameMenuView.m
//  QuartzFeedback
//
//  Created by david on 12/12/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import "InGameMenuView.h"
#import "GameController.h"
#import "MainViewController.h"

@implementation InGameMenuView

- initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]) != nil)
	{
		UIButton *btnResume = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		btnResume.frame = CGRectMake(5.0f, 5.0f, 120.0f, 30.0f);
		[btnResume setTitle:@"Resume Game" forState:UIControlStateNormal];
		
		[btnResume addTarget:self action:@selector(btnResumeTouchInside:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:btnResume];
		
		UIButton *btnQuit = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		btnQuit.frame = CGRectMake(5.0f, 40.0f, 120.0f, 30.0f);
		[btnQuit setTitle:@"Quit" forState:UIControlStateNormal];
		
		[btnQuit addTarget:self action:@selector(btnQuitTouchInside:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:btnQuit];
		
	}
	self.backgroundColor = [UIColor blackColor];
	self.alpha = 0.8;
	return self;
}


- (void)btnResumeTouchInside:(id)sender
{
	// hide self
	self.hidden = YES;
	[self.superview sendSubviewToBack:self];
	
	[GameController ResumeGame];
}


- (void)btnQuitTouchInside:(id)sender
{
	
	// hide self
	self.hidden = YES;
	[self.superview sendSubviewToBack:self];
	
	[GameController QuitGame];
	[[MainViewController sharedInstance].gameViewController DestroyViews];
	[[MainViewController sharedInstance].gameViewController dismissModalViewControllerAnimated:YES];
}

@end
