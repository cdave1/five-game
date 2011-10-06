//
//  TransactedGameController.m
//  QuartzFeedback
//
//  Created by david on 12/12/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import "TransactedGameController.h"
#import "MainViewController.h"


@implementation GameStateUpdate
@synthesize stateChange, previous, next;
- (void) dealloc
{
	[(NSObject *)stateChange release];
	[next release];
	[previous release];
	[super dealloc];
}
@end



@implementation TransactedGameController

@synthesize lock, lastGameUpdate, currentLevel;

- init
{
	if ((self = [super init]) != nil)
	{
		lastGameUpdate = nil;
		lock = [[NSObject alloc] init];
	}
	return self;
}


- (void)dealloc
{
	[lock release];
	[lastGameUpdate release];
	[super dealloc];
}


// Convenience method.
- (TileMove *)TryNextMove:(int)fromIndex to:(int)toIndex
{
	return [GameStateModel TileMoveMake:fromIndex to:toIndex];
}


- (BOOL)ReverseMove { return YES; }


// Set the next move as a tile move point to point. Assume the move is legal.
- (BOOL)SetNextMove:(int)fromIndex to:(int)toIndex
{
	@synchronized(lock)
	{
		TileMove *t = [GameStateModel TileMoveMake:fromIndex to:toIndex];
		if (t == nil) return NO;
		
		[(id<GameControllerDelegate>)self DoPlayerAction:t];
		
		GameStateUpdate* update = [[GameStateUpdate alloc] init];
		update.previous = lastGameUpdate;
		if (self.lastGameUpdate != nil) lastGameUpdate.next = update;
		lastGameUpdate = update;
		lastGameUpdate.stateChange = t;
	}
	return YES;
}


- (NSArray *)GetTiles
{
	return currentLevel.tiles;
}





@end
