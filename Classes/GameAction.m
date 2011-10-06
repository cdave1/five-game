//
//  GameAction.m
//  ARTest
//
//  Created by david on 10/01/09.
//  Copyright 2009 n/a. All rights reserved.
//

#import "StateChange.h"

@implementation GameAction
@synthesize paperworkActions;


- init
{
	if ((self = [super init]) != nil)
	{
		self.paperworkActions = [[NSMutableArray alloc] init];
	}
	return self;
}


- (void) dealloc
{
	[self.paperworkActions release];
	[super dealloc];
}


- (void) Commit
{
	// Commit child state changes
	for(PaperworkAction* action in self.paperworkActions)
	{
		[action Commit];
	}
}


- (void) Reverse
{
	// Reverse child state changes.
	for(PaperworkAction* action in self.paperworkActions)
	{
		[action Commit];
	}
}
@end
