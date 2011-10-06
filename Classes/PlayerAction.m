//
//  PlayerAction.m
//  ARTest
//
//  Created by david on 10/01/09.
//  Copyright 2009 n/a. All rights reserved.
//

#import "StateChange.h"

@implementation PlayerAction
@synthesize gameActions;


- init
{
	if ((self = [super init]) != nil)
	{
		self.gameActions = [[NSMutableArray alloc] init];
	}
	return self;
}


- (void) dealloc
{
	[self.gameActions release];
	[super dealloc];
}


- (void) Commit
{
	// Commit child state changes
	for(GameAction* action in self.gameActions)
	{
		[action Commit];
	}
}


- (void) Reverse
{
	// Reverse child state changes.
	for(GameAction* action in self.gameActions)
	{
		[action Commit];
	}
}


@end
