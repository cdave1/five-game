//
//  GameMenuView.m
//  QuartzFeedback
//
//  Created by david on 4/12/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import "GameBottomMenuView.h"
#import "GameController.h"


@implementation GameBottomMenuView

@synthesize btnRewind;

- initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]) != nil)
	{
		btnRewind = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		btnRewind.frame = CGRectMake(5.0f, 5.0f, 120.0f, 30.0f);
		[btnRewind setTitle:@"Rewind" forState:UIControlStateNormal];
		btnRewind.backgroundColor = [UIColor whiteColor];
		
		[btnRewind addTarget:self action:@selector(btnRewindTouchInside:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:btnRewind];
	}
	return self;
}

- (void)btnRewindTouchInside:(id)sender
{
	[GameController ReverseMove];
}

@end
