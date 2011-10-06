//
//  GoalsViewController.m
//  ARTest
//
//  Created by david on 21/12/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import "GoalsViewController.h"


@implementation GoalsViewController

- init
{
	if ((self = [super initWithNibName:nil bundle:nil]) != nil)
	{
		self.title = @"Goals";
		self.navigationItem.hidesBackButton = YES;
	}
	return self;
}


- (void)loadView
{
	//UIView *v = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];

	
}

@end
