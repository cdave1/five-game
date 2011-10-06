//
//  TutorialsViewController.m
//  ARTest
//
//  Created by david on 21/12/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import "TutorialsViewController.h"


@implementation TutorialsViewController

- init
{
	if ((self = [super initWithNibName:nil bundle:nil]) != nil)
	{
		self.title = @"Tutorials";
		self.navigationItem.hidesBackButton = YES;
	}
	return self;
}

@end
