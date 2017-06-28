//
//  GameStateModel.m
//  QuartzFeedback
//
//  Created by david on 20/11/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import "GameStateModel.h"
#import "GameController.h"


struct Node {
	short tileIndex;
	short H;
	short G;
	struct Node *parent;
};


@interface GameStateModel (Private)
	+ (NSMutableArray *)CountTiles:(NSInteger)tileIndex direction:(NSInteger)direction;
	+ (NSMutableArray *)CountTiles:(NSInteger)tileIndex type:(PieceType)type direction:(NSInteger)direction;
	+ (NSInteger)AddDirection:(NSInteger)tileIndex direction:(NSInteger)direction;
	+ (NSInteger)MDistance:(NSInteger)direction fromIndex:(NSInteger)from toIndex:(NSInteger)to;
@end


@implementation GameStateModel

// Would be really good as a generator method...
//
// Returns an array of arrays of tiles to be removed.
+ (NSMutableArray *)GetWinningTileSets
{
	NSMutableArray *tileSets = [NSMutableArray array];
	NSMutableArray *visited = [NSMutableArray array];
	
	NSInteger maxTiles = [GameController GetMaximumTilesForCurrentLevel];
	
	for(NSInteger i = 0; i < maxTiles; i++)
	{
		Tile *t = [[GameController GetTiles] objectAtIndex:i];
		if (t.isEmpty == false && [visited containsObject:t] == NO) {
			NSMutableArray *n = [GameStateModel CountTiles:i direction:NORTH];
			if (n.count >= [GameController GetMinimumWinningTileCount]) 
			{
				[tileSets addObject:n];
				[visited addObjectsFromArray:n];
			}
			
			NSMutableArray *ne = [GameStateModel CountTiles:i direction:NORTHEAST];
			if (ne.count >= [GameController GetMinimumWinningTileCount]) 
			{
				[tileSets addObject:ne];
				[visited addObjectsFromArray:ne];
			}
			
			NSMutableArray *e = [GameStateModel CountTiles:i direction:EAST];
			if (e.count >= [GameController GetMinimumWinningTileCount]) 
			{
				[tileSets addObject:e];
				[visited addObjectsFromArray:e];
			}
			
			NSMutableArray *se = [GameStateModel CountTiles:i direction:SOUTHEAST];
			if (se.count >= [GameController GetMinimumWinningTileCount]) {
				[tileSets addObject:se];
				[visited addObjectsFromArray:se];
			}
		}
	}
	
	return tileSets;
}


+ (NSMutableArray *)CountTiles:(NSInteger)tileIndex direction:(NSInteger)direction
{
	if (tileIndex >= [GameController GetTiles].count) return nil;
	if (tileIndex <= -1) return nil;
	
	Tile *t = [[GameController GetTiles] objectAtIndex:tileIndex];
	if (t.type == WallTile) return nil;
	if (t.isEmpty) return nil;
	
	NSMutableArray* first  = [GameStateModel CountTiles:[self AddDirection:tileIndex direction:direction] type:t.piece.type direction:direction];
	NSMutableArray* second = [GameStateModel CountTiles:[self AddDirection:tileIndex direction:(direction * -1)] type:t.piece.type direction:(direction * -1)];
	
	NSMutableArray* array = [NSMutableArray arrayWithArray:first];
	[array addObject:t];
	[array addObjectsFromArray:second];
	return array;
}


// Recursively construct an array of tiles that share the same color as the tile 
// at tileIndex when travelling in direction across the game board.
+ (NSMutableArray *)CountTiles:(NSInteger)tileIndex type:(PieceType)type direction:(NSInteger)direction
{
	if (tileIndex >= [GameController GetTiles].count) return nil;
	if (tileIndex <= -1) return nil;
	
	Tile *t = [[GameController GetTiles] objectAtIndex:tileIndex];
	if (t.type == WallTile) return nil;
	if (t.isEmpty) return nil;
	if (t.piece.type != type) return nil;
	
	NSMutableArray* array = [NSMutableArray arrayWithObject:t];
	[array addObjectsFromArray:[GameStateModel CountTiles:[self AddDirection:tileIndex direction:direction] type:type direction:direction]];
	return array;
}
		
		
+ (NSInteger)AddDirection:(NSInteger)tileIndex direction:(NSInteger)direction
{
	short row = floor(tileIndex / [GameController GetCurrentLevel].width);
	short col = (tileIndex % [GameController GetCurrentLevel].width);
	
	if (direction == NORTH) { row--; }
	else if (direction == NORTHEAST) { row--; col++; }
	else if (direction == EAST) { col++; }
	else if (direction == SOUTHEAST) { row++; col++; }
	else if (direction == SOUTH) { row++; }
	else if (direction == SOUTHWEST) { row++; col--; }
	else if (direction == WEST) { col--; }
	else if (direction == NORTHWEST) { col--; row--; }
	
	if (col < 0 || col >= [GameController GetCurrentLevel].width) return -1;
	if (row < 0 || row >= [GameController GetCurrentLevel].height) return -1;
	return tileIndex + direction;
}


// Check if there's a path from a to b.
+ (BOOL)TryNextMove:(NSInteger)fromIndex to:(NSInteger)toIndex
{
	if (fromIndex >= [GameController GetTiles].count) return NO;
	if (toIndex >= [GameController GetTiles].count) return NO;
	
	Tile *from = [[GameController GetTiles] objectAtIndex:fromIndex];
	if (from.isEmpty == YES) return NO;
	
	Tile *to = [[GameController GetTiles] objectAtIndex:toIndex];
	if (to.isEmpty == NO) return NO;
	
	NSMutableArray* path = [GameStateModel FindMovementPath:fromIndex to:toIndex];
	
	if (path == nil) return NO;
	if (path.count == 0) return NO;
	
	return YES;
}


+ (TileMove *)TileMoveMake:(NSInteger)fromIndex to:(NSInteger)toIndex
{
	if ([GameStateModel TryNextMove:fromIndex to:toIndex]) {
		TileMove* t = [[TileMove alloc] init];
		t.fromIndex = fromIndex;
		t.toIndex = toIndex;
		t.tilePath = [GameStateModel FindMovementPath:fromIndex to:toIndex];
		t.piece = ((Tile *)[[GameController GetTiles] objectAtIndex:fromIndex]).piece;
		return [t autorelease];
	} else {
		return nil;
	}
}


// Returns an array of tiles from the movement starting point
// to toIndex, using A* algorithm.
+ (NSMutableArray *)FindMovementPath:(NSInteger)fromIndex to:(NSInteger)toIndex
{	
	if (toIndex > [GameController GetTiles].count) return nil;
	Tile* t = [[GameController GetTiles] objectAtIndex:toIndex];
	if (!t.isEmpty) return nil;
	
	NSInteger maxTiles = [GameController GetMaximumTilesForCurrentLevel];
	struct Node *top = 0;

	// the DFS stack
	NSInteger stackTop = 0;
	struct Node nodeStack[maxTiles];
	
	// visited tiles
	NSInteger visitedCount = 0;
	struct Node visited[maxTiles];
	
	// best path to goal
	NSInteger nodeStackIndex = -1;
	bool hasVisited = false;
	
	// Add the first item to the stack.
	nodeStack[stackTop].tileIndex = fromIndex;
	nodeStack[stackTop].H = [GameStateModel MDistance:0 fromIndex:fromIndex toIndex:toIndex];
	nodeStack[stackTop].G =	1;
	nodeStack[stackTop].parent = nil;
	stackTop++;
	
	while(nodeStack[stackTop - 1].tileIndex != toIndex) {
		if (stackTop == 0) return nil; // couldn't find a path.
		
		stackTop--;
		visited[visitedCount].tileIndex = nodeStack[stackTop].tileIndex;
		visited[visitedCount].H = nodeStack[stackTop].H;
		visited[visitedCount].G = nodeStack[stackTop].G;
		visited[visitedCount].parent = nodeStack[stackTop].parent;
		top = &visited[visitedCount];
		visitedCount++;
		
		// Heuristic function for each of the adjacent nodes.
		struct Node arr[4] = { 
			{ (top->tileIndex + NORTH), [GameStateModel MDistance:NORTH fromIndex:top->tileIndex toIndex:toIndex], top->G + 1, top },
			{ (top->tileIndex + EAST),	[GameStateModel MDistance:EAST	fromIndex:top->tileIndex toIndex:toIndex], top->G + 1, top },
			{ (top->tileIndex + SOUTH), [GameStateModel MDistance:SOUTH fromIndex:top->tileIndex toIndex:toIndex], top->G + 1, top },
			{ (top->tileIndex + WEST),	[GameStateModel MDistance:WEST	fromIndex:top->tileIndex toIndex:toIndex], top->G + 1, top } };
		
		// Add all of these to the nodeStack
		for(NSInteger i = 0; i < 4; i++)
		{
			if (arr[i].H < MAX_DISTANCE) {
				Tile* t = [[GameController GetTiles] objectAtIndex:arr[i].tileIndex];
				if (t.isEmpty) {
					hasVisited = false;
					nodeStackIndex = -1;
					
					// Check if we've visited before
					for (NSInteger k = 0; k < visitedCount; k++)
					{
						if (arr[i].tileIndex == visited[k].tileIndex) 
						{
							hasVisited = true;
							break;
						}
					}
					
					// process the node if not.
					if (!hasVisited) {
						// Check if the node is already on the node stack
						for(NSInteger j = 0; j < stackTop; j++)
						{
							if (arr[i].tileIndex == nodeStack[j].tileIndex)
							{
								nodeStackIndex = j;
								break;
							}
						}
						
						// If the node is on the node stack, check if this node is a better path.
						// Swap the two nodes if that is the case.
						if (nodeStackIndex != -1) 
						{
							if (arr[i].G < nodeStack[nodeStackIndex].G)
							{
								nodeStack[nodeStackIndex].parent = top;
								nodeStack[nodeStackIndex].G = top->G;
							}						
						} else {
							nodeStack[stackTop].tileIndex = arr[i].tileIndex;
							nodeStack[stackTop].H = arr[i].H;
							nodeStack[stackTop].G =	arr[i].G;
							nodeStack[stackTop].parent = arr[i].parent;
							stackTop++;
						}
					}
				}
			}
		}
		
		// Basic insertion sort to sort the list (in descending order).
		//
		// TODO: optimize me!
		struct Node tmp;
		for(NSInteger i = 0; i < stackTop; i++)
		{
			for (NSInteger j = i+1; j < stackTop; j++)
			{
				if ((nodeStack[i].H + nodeStack[i].G) < (nodeStack[j].H + nodeStack[j].G)) 
				{
					tmp = nodeStack[j];
					nodeStack[j] = nodeStack[i];
					nodeStack[i] = tmp;
				}
			}
		}
	}
	
	NSMutableArray* path = [[NSMutableArray alloc] init];
	struct Node current = nodeStack[stackTop - 1];
	while(current.tileIndex != fromIndex)
	{
		[path addObject:[[GameController GetTiles] objectAtIndex:current.tileIndex]];
		current = *(current.parent);
	}
	[path addObject:[[GameController GetTiles] objectAtIndex:current.tileIndex]];

	return [path autorelease];
}


// Strict manhattan distance between two tiles
+ (NSInteger)MDistance:(NSInteger)direction fromIndex:(NSInteger)from toIndex:(NSInteger)to
{
	NSInteger width = [GameController GetCurrentLevel].width;
	NSInteger height = [GameController GetCurrentLevel].height;
	
	NSInteger from_row = floor(from / width);
	NSInteger from_col = (from % width);

	NSInteger to_row = floor(to / width);
	NSInteger to_col = (to % width);
	
	if (direction == NORTH) from_row--;
	else if (direction == SOUTH) from_row++;
	else if (direction == EAST) from_col++;
	else if (direction == WEST) from_col--;
	
	if (from_col < 0 || from_col >= width) return MAX_DISTANCE;
	if (from_row < 0 || from_row >= height) return MAX_DISTANCE;

	return ABS(to_row - from_row) + ABS(to_col - from_col);
}

@end
