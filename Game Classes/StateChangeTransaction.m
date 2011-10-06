//
//  StateChangeTransaction.m
//  QuartzFeedback
//
//  Created by david on 4/12/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import "StateChangeTransaction.h"


@implementation StateChangeTransaction

@synthesize stateChangeSet, previous, next;

- init
{
	if ((self = [super init]) != nil)
	{
		self.stateChangeSet = [[NSMutableArray alloc] init];
	}
	return self;
}

- (void)dealloc
{
	[self.stateChangeSet release];
	[super dealloc];
}

@end
