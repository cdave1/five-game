//
//  GameStart.m
//  ARTest
//
//  Created by david on 10/01/09.
//  Copyright 2009 n/a. All rights reserved.
//

#import "StateChange.h"

@implementation GameStart
@synthesize newPieces;


- init
{
	if ((self = [super init]) != nil)
	{
		self.newPieces = [[NSMutableArray alloc] init];
	}
	return self;
}


- (void) dealloc
{
	[self.newPieces release];
	[super dealloc];
}


- (void) Commit
{
	// Commit child state changes
	for(GameAction* action in self.newPieces)
	{
		[action Commit];
	}
}


- (void) Reverse
{
}


@end
