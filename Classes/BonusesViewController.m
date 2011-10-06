//
//  BonusesViewController.m
//  ARTest
//
//  Created by david on 21/12/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import "BonusesViewController.h"


@implementation BonusesViewController

- init
{
	if ((self = [super initWithNibName:nil bundle:nil]) != nil)
	{
		self.title = @"Bonuses";
		self.navigationItem.hidesBackButton = YES;
	}
	return self;
}

@end
