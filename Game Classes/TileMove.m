//
//  TileMove.m
//  QuartzFeedback
//
//  Created by david on 22/11/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import "StateChange.h"
#import "GameController.h"


@implementation TileMove

@synthesize fromIndex, toIndex, tilePath, piece;

- (void)dealloc
{
	if (self.tilePath != nil) [tilePath release];
	[super dealloc];
}


- (void) Commit
{
	Tile *from = [[GameController GetTiles] objectAtIndex:self.fromIndex];
	Tile *to = [[GameController GetTiles] objectAtIndex:self.toIndex];
	
	if (from != nil && to != nil) {
		from.piece = nil;
		to.piece = self.piece;
	}
	
	[super Commit];
}


- (void) Reverse
{
	[super Reverse];
	
	Tile *from = [[GameController GetTiles] objectAtIndex:self.fromIndex];
	Tile *to = [[GameController GetTiles] objectAtIndex:self.toIndex];
	
	if (from != nil && to != nil) {
		from.piece = self.piece;
		to.piece = nil;
	}
}

- (NSArray *)TilesChanged
{
	NSNumber *from = [[NSNumber alloc] initWithInt:self.fromIndex];
	NSNumber *to = [[NSNumber alloc] initWithInt:self.toIndex];
	NSArray *array = [NSArray arrayWithObjects:from, to, nil];
	[from release];
	[to release];
	return array;	
}

@end
