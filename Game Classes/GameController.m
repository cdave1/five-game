//
//  GameController.m
//  QuartzFeedback
//
//	Views interact with the controller to update the Game Model.
//  
// The controller ensures that the game state changes are reflected
// in the views the represent the game state.
//
// Internally, the controller instantiates a particular game controller
// and passes messages to that controller.
//
//  Created by david on 5/12/08.
//  Copyright 2008 n/a. All rights reserved.
//


#import "GameController.h"
#import <Foundation/Foundation.h>
#import "MainViewController.h"


static TransactedGameController<GameControllerDelegate> *delegate;


@implementation GameController


+ (void)Initialize:(GameControllerType)type
{
	[Levelgroup ReloadLevelGroups];
	if (type == StandardGameType)
	{
		StandardGame* standardGame = [[StandardGame alloc] init];
		[standardGame AdvanceLevel];
		delegate = standardGame;
	} 
	else if (type == LevelledGameType)
	{
		LevelGame* levelGame = [[LevelGame alloc] init];

		delegate = levelGame;
	}
	else if (type == PuzzleGameType)
	{
		delegate = [[LevelGame alloc] init];
	}
}


+ (void) dealloc
{
	[delegate release];
	[super dealloc];
}


+ (void)LoadGameState
{
	[[MainViewController GetGameAreaView] LoadCurrentLevel]; // HACK HACK HACK
	[delegate LoadGameState];
}


+ (BOOL)AdvanceLevel
{
	return [delegate AdvanceLevel];
}


+ (BOOL)AdvanceLevelgroup
{
	return [delegate AdvanceLevelgroup];
}


+ (void)CompleteMove
{
	//[delegate CompleteMove];
}


+ (BOOL)ReverseMove
{
	return [delegate ReverseMove];
}


+ (void)PauseGame
{
}


+ (void)ResumeGame
{
}


+ (void)AddPointsToGame:(NSInteger)points
{
	[delegate AddPointsToGame:points];
}


+ (void)RemovePointsFromGame:(NSInteger)points
{
	[delegate RemovePointsFromGame:points];
}


+ (void)PlayerWonLevel
{
	[delegate PlayerWonLevel];
}


+ (void)PlayerWonLevelgroup
{
	[delegate PlayerWonLevelgroup];
}



+ (void)QuitGame
{
	[delegate release];
	delegate = nil;
}


+ (BOOL)SaveGame
{
	return YES;
}


+ (BOOL)LoadGame:(GameControllerType)type
{
	return YES;
}



// Convenience method.
+ (TileMove *)TryNextMove:(NSInteger)fromIndex to:(NSInteger)toIndex
{
	return [delegate TryNextMove:fromIndex to:toIndex];
}


// Set the next move as a tile move point to point. Assume the move is legal.
+ (BOOL)SetNextMove:(NSInteger)fromIndex to:(NSInteger)toIndex
{
	return [delegate SetNextMove:fromIndex to:toIndex];
}


+ (NSArray *)GetTiles
{
	return [delegate GetTiles];
}


+ (NSInteger)GetTileWidth
{
	return [delegate GetTileWidth];
}


+ (NSInteger)GetLevelgroupIndex
{
	return [delegate GetLevelgroupIndex];
}


+ (Level *)GetCurrentLevel
{
	return delegate.currentLevel;
}


+ (NSInteger)GetMaximumTilesForCurrentLevel
{
	return delegate.currentLevel.width * delegate.currentLevel.height;
}


+ (NSInteger)GetMinimumWinningTileCount
{
	return delegate.currentLevel.minlinesize;
}


+ (void)JewelLineGoalCreate:(PieceType)pieceType forJewel:(BonusItemType)jewel forGoal:(ConsecutiveGoal *)goal
{
	LinesGoal *pieceGoal = [[LinesGoal alloc] init];
	pieceGoal.requiredPieceType = OrangePiece;
	pieceGoal.requiredCount = 2;
	ItemBonus *bonus = [[ItemBonus alloc] init];
	bonus.points = 1000;
	bonus.bonusItemType = jewel;
	pieceGoal.bonus = (id)bonus;
	[goal.goals addObject:pieceGoal];
	[bonus release];
	[pieceGoal release];
}

@end
