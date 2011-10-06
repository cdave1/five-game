//
//  NewPiece.m
//  QuartzFeedback
//
//  Created by david on 5/12/08.
//  Copyright 2008 n/a. All rights reserved.
//



#import "StateChange.h"
#import "GameController.h"



@implementation NewPiece

@synthesize tileIndex, piece, gameActions;


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
	Tile *tile = [[GameController GetTiles] objectAtIndex:self.tileIndex];
	
	if (tile != nil) {
		tile.piece = self.piece;
	}
	
	for(GameAction* action in self.gameActions)
	{
		[action Commit];
	}
	
	[super Commit];
}


- (void) Reverse
{
	for(GameAction* action in self.gameActions)
	{
		[action Reverse];
	}
	
	[super Reverse];
	
	Tile *tile = [[GameController GetTiles] objectAtIndex:self.tileIndex];
	
	if (tile != nil) {
		tile.piece = nil;
	}
}


- (NSArray *)TilesChanged
{
	NSNumber *num = [[NSNumber alloc] initWithInt:self.tileIndex];
	NSArray *array = [NSArray arrayWithObjects:num, nil];
	[num release];
	return array;
}



@end
