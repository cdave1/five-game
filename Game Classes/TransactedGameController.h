//
//  TransactedGameController.h
//  QuartzFeedback
//
//  Created by david on 12/12/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
//#import "StateChange.h"
#import "GameStateModel.h"
#import "GoalClasses.h"


@class GameStateUpdate;


@interface TransactedGameController : NSObject {
	GameStateUpdate* lastGameUpdate;
	Level* currentLevel;
	NSObject* lock;
}

@property(readwrite, retain) Level* currentLevel;
@property(retain) GameStateUpdate* lastGameUpdate;
@property(retain) NSObject* lock;

// Move completion functions
- (TileMove *)TryNextMove:(int)fromIndex to:(int)toIndex;
- (BOOL)SetNextMove:(int)fromIndex to:(int)toIndex;
- (NSArray *)GetTiles;
- (BOOL)ReverseMove;
@end


@interface GameStateUpdate : NSObject {
	id<StateChange> stateChange;
	GameStateUpdate* previous;
	GameStateUpdate* next;
}
@property(retain) id<StateChange> stateChange;
@property(retain) GameStateUpdate* previous;
@property(retain) GameStateUpdate* next;
@end


@protocol GameControllerDelegate
@required
- (void)DoPlayerAction:(PlayerAction *)action;
- (void)LoadGameState;
- (NewPiece *)GenerateNewPiece;
- (NewPiece *)GenerateNewPieceAt:(int)index type:(int)theType;
- (int)GetTileWidth;
- (int)GetLevelgroupIndex;

@optional
- (void)DoPlayerAction:(PlayerAction *)action;
- (NewPiece *)DoNewPiece;
- (void)DoWinningMove:(NSMutableArray *)winningSets parent:(id<StateChange>)action;

- (void)AddPointsToGame:(int)points;
- (void)RemovePointsFromGame:(int)points;

- (int)DoPointsForWinningMove:(WinningMove *)move;
- (void)AddPointsForWinningMove:(NSMutableArray *)winningMoves;
- (void)PlayerWonLevel;
- (void)PlayerWonLevelgroup;
- (void)PlayerLostLevel;
- (void)PlayerWonGame;
- (BOOL)AdvanceLevel;
- (BOOL)AdvanceLevelgroup;

@end





