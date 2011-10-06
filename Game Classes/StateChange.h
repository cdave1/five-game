//
//  StateChange.h
//  QuartzFeedback
// 
// Retains two pointers to tiles, representing a move from one
// tile to another.
//
//  Created by david on 22/11/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameClasses.h"

@class WinningMove;


// Protocol for various changes of state that can occur to the game model.
@protocol StateChange

@required 
- (void)Commit;
- (void)Reverse;

@optional
- (NSArray *)TilesChanged;

@end


// An action initiated by the player
@interface PlayerAction : NSObject <StateChange>
{
	NSMutableArray* gameActions;
}
// Game actions resulting from the player action
@property(retain) NSMutableArray* gameActions;
@end


// An action initiated by the game
@interface GameAction : NSObject <StateChange>
{
	NSMutableArray* paperworkActions;
}
@property(retain) NSMutableArray* paperworkActions;
@end


// Actions that update the player's points, give
// a bonus, among other things.
@interface PaperworkAction : NSObject <StateChange> 
{
	WinningMove* winningMove;
}
@property(readwrite, retain) WinningMove* winningMove;
@end


@interface PointsPaperworkAction : PaperworkAction <StateChange> {
	int points;
}
@property(readwrite) int points;
@end





// When a piece moves from one place to another.
@interface TileMove : PlayerAction <StateChange> {
@public 
	int fromIndex;
	int toIndex;
	NSMutableArray* tilePath;
	Piece* piece;
}

@property(readwrite) int fromIndex;
@property(readwrite) int toIndex;
@property(retain) NSMutableArray* tilePath;
@property(retain) Piece* piece;
@end


// Created when the game is started. Reverse does nothing.
// Adds pieces to the board, and to the queue from the level
// object.
@interface GameStart : GameAction <StateChange>
{
	NSMutableArray* newPieces;
}
@property(retain) NSMutableArray* newPieces;
@end


// Winning move
@interface WinningMove : GameAction <StateChange>
{
	NSMutableArray* removePieceActions;
}
- (id)initWithTiles:(NSMutableArray *)set;

@property(retain) NSMutableArray* removePieceActions;
@property(readonly) PieceType type;
@property(readonly) CGPoint center;
@end


// Attached to a winning move.
@interface RemovePiece : GameAction <StateChange> {
@public 
	int tileIndex;
@private
	Piece* piece;
}
@property(readwrite) int tileIndex;
@property(retain) Piece* piece;
@end


// Represents the act of adding a new piece to the game board.
@interface NewPiece : GameAction <StateChange>
{
@public 
	int tileIndex;
	Piece* piece;
	NSMutableArray* gameActions;
	
}
@property(readwrite) int tileIndex;
@property(retain) Piece* piece;
@property(retain) NSMutableArray* gameActions;

@end
