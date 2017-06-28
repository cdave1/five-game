//
//  LineRemove.m
//  QuartzFeedback
//
//  Created by david on 6/12/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import "StateChange.h"
#import "GameController.h"


@implementation RemovePiece

@synthesize tileIndex, piece;

- (void) Commit
{
	Tile *tile = [[GameController GetTiles] objectAtIndex:self.tileIndex];
	
	if (tile != nil) {
		self.piece = tile.piece;
		tile.piece = nil;
	}
}


- (void) Reverse
{
	Tile *tile = [[GameController GetTiles] objectAtIndex:self.tileIndex];
	
	if (tile != nil) {
		tile.piece = self.piece;
	}
}


- (NSArray *)TilesChanged
{
	NSNumber *num = [[NSNumber alloc] initWithInteger:self.tileIndex];
	NSArray *array = [NSArray arrayWithObjects:num, nil];
	[num release];
	return array;
}


- (void) dealloc
{
	[self.piece release];
	[super dealloc];
}

@end
