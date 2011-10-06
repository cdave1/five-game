//
//  WinningMove.m
//  ARTest
//
//  Created by david on 10/01/09.
//  Copyright 2009 n/a. All rights reserved.
//

#import "StateChange.h"
#import "GameAreaView.h"

@implementation WinningMove
@synthesize removePieceActions;
@dynamic type;
@dynamic center;

- (id)initWithTiles:(NSMutableArray *)set
{
	if ((self = [super init]) != nil) 
	{
		self.removePieceActions = [[NSMutableArray alloc] init];
		for(int j = 0; j < set.count; j++)
		{
			Tile *t = [set objectAtIndex:j];
			RemovePiece *r = [[RemovePiece alloc] init];
			r.tileIndex = t.index;
			r.piece = t.piece;
			[self.removePieceActions addObject:r];
			[r release];
		}
	}
	return self;
}


- (void) dealloc
{
	[self.removePieceActions release];
	[super dealloc];
}


- (void) Commit
{
	[super Commit];
	// Commit child state changes
	for(RemovePiece* removePiece in self.removePieceActions)
	{
		[removePiece Commit];
	}
}


- (void) Reverse
{
	// Reverse child state changes.
	for(RemovePiece* removePiece in self.removePieceActions)
	{
		[removePiece Reverse];
	}
}


- (CGPoint)center
{
	// sort the removePieceActions
	
	return [GameAreaView tileIndexToCGPoint:[[self.removePieceActions objectAtIndex:0] tileIndex]];
}


-(PieceType)type
{
	PieceType pieceType = NullPiece;
	
	// If it contains one coloured piece, then that's the type.
	// If it contains all wildcards, then its type is wildcard.
	// Bomb types are treated like wildcards.
	for(RemovePiece* action in self.removePieceActions)
	{
		if (action.piece.type == BombPiece || action.piece.type == WildcardPiece)
		{
			pieceType = WildcardPiece;
		} 
		else 
		{
			pieceType = action.piece.type;
			break;
		}
	}
	return pieceType;
}
@end
