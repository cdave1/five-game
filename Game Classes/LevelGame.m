//
//  LevelGame.m
//  QuartzFeedback
//
//  Created by david on 12/12/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import "LevelGame.h"
#import "MainViewController.h"
#import "GameViewController.h"
#import "LevelgroupIntroViewController.h"
#import "PlayerWonLevelgroupViewController.h"
#import "GameOverViewController.h"

@implementation LevelGame

@synthesize levelgroup;

- init
{
	if ((self = [super init]) != nil)
	{
		levelIndex = 0;
		levelgroupIndex = 0;
		
		[self AdvanceLevelgroup];
		[self AdvanceLevel];
		
		// Create some consecutive goals
		gameGoals = [[NSMutableArray alloc] init];
		
		ConsecutiveGoal *cg = [[ConsecutiveGoal alloc] init];		
		
		LinesGoal *anyPieceGoal = [[LinesGoal alloc] init];
		anyPieceGoal.requiredPieceType = NullPiece;
		anyPieceGoal.requiredCount = 2;
		GoalMultiplierBonus *mb = [[GoalMultiplierBonus alloc] init];
		mb.parentGoal = anyPieceGoal;
		anyPieceGoal.bonus = (id)mb;
		[cg.goals addObject:anyPieceGoal];
		[mb release];
		[anyPieceGoal release];
		
		// Creates each of the jewel collection algorithms.
		[GameController JewelLineGoalCreate:RedPiece forJewel:RedJewelItem forGoal:cg];
		[GameController JewelLineGoalCreate:OrangePiece forJewel:OrangeJewelItem forGoal:cg];
		[GameController JewelLineGoalCreate:YellowPiece forJewel:YellowJewelItem forGoal:cg];
		[GameController JewelLineGoalCreate:GreenPiece forJewel:GreenJewelItem forGoal:cg];
		[GameController JewelLineGoalCreate:BluePiece forJewel:BlueJewelItem forGoal:cg];
		[GameController JewelLineGoalCreate:IndigoPiece forJewel:IndigoJewelItem forGoal:cg];
		[GameController JewelLineGoalCreate:VioletPiece forJewel:VioletJewelItem forGoal:cg];
		
		[gameGoals addObject:cg];
		[cg release];
	}
	return self;
}


- (void)dealloc
{
	[gameGoals release];
	[super dealloc];
}	


- (void)LoadGameState
{
	srand(CFAbsoluteTimeGetCurrent());
	GameStart* gameStart = [[GameStart alloc] init];
	for(Tile* tile in currentLevel.startingPieces)
	{
		NewPiece* np = [self GenerateNewPieceAt:tile.index type:tile.piece.type];
		if (np == nil) break;
		[gameStart.newPieces addObject:np];
	}
	
	[gameStart Commit];
	[StateChangeTransactionAnimator AnimateGameStart:gameStart];
}


// Generates the next state of the game.
//
// The transaction can contain any number of state changes
// in any order. When one state change is commited, it may
// cause further state changes. The main example is when a
// move results in a "win" and pieces must be removed from
// the board.
//
// When a player makes a move, we want to work out
// what game actions take place based on this move.
- (void)DoPlayerAction:(PlayerAction *)action
{
	int newPieceCount = 3;
	if ([action isKindOfClass:[TileMove class]])
	{
		[action Commit];
		NSMutableArray *winningSets = [GameStateModel GetWinningTileSets];
		if (winningSets.count > 0)
		{
			[self DoWinningMove:winningSets parent:action];
		} 
		else
		{
			// Reset the local game goals if no winning moves.
			for(Goal* goal in gameGoals)
			{
				[goal ResetProgress];
			}
			
			// Add some more pieces to the board.
			while (newPieceCount-- > 0) {
				[action.gameActions addObject:[self DoNewPiece]];
			}			
		}
		[StateChangeTransactionAnimator AnimateTileMove:(TileMove *)action];
	}
	
	// Check if any goals have been achieved.
	// also, check the particular level variables:
	// - check level.pointslimit and level.moveslimit
	// PlayerWonLevel, simply updates the newPieceCount and minLineSize
	[[MainViewController sharedInstance].gameViewController SetPoints:totalPoints];
	
	if (currentLevel.pointslimit != -1 && totalPoints >= currentLevel.pointslimit)
	{
		[[MainViewController sharedInstance].gameViewController presentModalViewController:[[[PlayerWonLevelViewController alloc] init] autorelease] animated:YES];
	}
}


// Points - MUST be a paperwork action
- (int)DoPointsForWinningMove:(WinningMove *)move
{
	// Points per line:	
	return (move.removePieceActions.count + ((move.removePieceActions.count - [GameController GetMinimumWinningTileCount]) * 2)) * 10;
}


- (int)GoalCheck:(WinningMove *)move withPoints:(int)points
{
	int ret = points;
	
	for(Goal* goal in currentLevel.goals)
	{
		[goal AddWinningMove:move];
	}
	
	// Game goals are for consecutive winning moves - if 
	// not successful, then the goals are reset.
	for(Goal* goal in gameGoals)
	{
		[goal AddWinningMove:move];
		if ([goal isAchieved]) 
		{
			BonusPaperworkAction *bonusAction;
			for(id<Bonus> bonus in [goal GetBonuses])
			{
				if ([(NSObject *)bonus isKindOfClass:[ItemBonus class]]) 
				{
					// Add an action for the item.
				}
				bonusAction = [[BonusPaperworkAction alloc] init];
				bonusAction.bonus = bonus;
				bonusAction.points = points;
				[move.paperworkActions addObject:bonusAction];
				[bonusAction release];
				ret = [bonus applyBonus:ret];
			}
		}
	}
	return ret;
}


- (NewPiece *)DoNewPiece
{
	NewPiece *np = [self GenerateNewPiece];
	if (np == nil) return nil;
	
	[np Commit];
	NSMutableArray *winningSets = [GameStateModel GetWinningTileSets];
	if (winningSets.count > 0)
	{
		[self DoWinningMove:winningSets parent:np];
	}
	return np;
}


- (void)DoWinningMove:(NSMutableArray *)winningSets parent:(id<StateChange>)action
{	
	for(NSMutableArray *a in winningSets)
	{
		// - Calculate the points awarded for the winning tiles.
		WinningMove* win = [[WinningMove alloc] initWithTiles:a];
		int points = [self DoPointsForWinningMove:win];
		
		// - Check if the level had a reward for the type of items
		//   in the set or goal. Award a bonus if so.
		points = [self GoalCheck:win withPoints:points];
		
		PointsPaperworkAction *pointsAction = [[PointsPaperworkAction alloc] init];
		pointsAction.winningMove = win;
		pointsAction.points = points;
		[win.paperworkActions addObject:pointsAction];
		[pointsAction release];
		
		[win Commit];
		
		if ([(NSObject *)action isKindOfClass:[TileMove class]])
		{
			[((TileMove *)action).gameActions addObject:win];
		} 
		else if ([(NSObject *)action isKindOfClass:[NewPiece class]])
		{
			[((NewPiece *)action).gameActions addObject:win];
		}
	}
}


- (void)AddPointsToGame:(int)points
{
	totalPoints += points;
}


- (void)RemovePointsFromGame:(int)points
{
	totalPoints -= points;
}


// Sets the next level.
- (BOOL)AdvanceLevel
{
	if (levelIndex >= [levelgroup levels].count) return NO;
	totalPoints = 0;
	totalMoves = 0;
	
	self.currentLevel = [[levelgroup levels] objectAtIndex:levelIndex];
	levelIndex++;
	return YES;
}


- (BOOL)AdvanceLevelgroup
{
	if (levelgroupIndex >= [Levelgroup GetLevelGroups].count) return NO;
	totalPoints = 0;
	totalMoves = 0;
	levelIndex = 0;

	self.levelgroup = [[Levelgroup GetLevelGroups] objectAtIndex:levelgroupIndex];
	levelgroupIndex++;
	return YES;
}


- (void)PlayerWonLevel
{
	// TODO
}


- (void)PlayerWonLevelgroup
{
	// TODO
}


- (void)PlayerLostLevel
{
	[[MainViewController sharedInstance].gameViewController presentModalViewController:[[[GameOverViewController alloc] init] autorelease] animated:YES];
}


- (void)PlayerWonGame
{
    // TODO
}


- (NewPiece *)GenerateNewPiece
{
	int maxTiles = [GameController GetMaximumTilesForCurrentLevel];
	int index = (rand() % maxTiles);
	int count = 0;
	Tile* t = [currentLevel.tiles objectAtIndex:index];
	
	while(t.isEmpty == NO)
	{
		if (count++ >= maxTiles) break;
		index = (rand() % maxTiles);
		t = [currentLevel.tiles objectAtIndex:index];
	}
	if (count >= maxTiles) 
	{
		return nil;
	}
	
	NewPiece* np = [[NewPiece alloc] init];
	np.tileIndex = index;
	Piece* p = [[Piece alloc] init];
	np.piece = p;
	[p release];
	
	[np Commit];
	
	[[MainViewController GetGameAreaView] AddNewPiece:np.piece atIndex:index];
	
	return [np autorelease];
}


- (NewPiece *)GenerateNewPieceAt:(int)index type:(int)theType
{
	Tile* t = [currentLevel.tiles objectAtIndex:index];
	if (t == nil) return nil;
	
	NewPiece* np = [[NewPiece alloc] init];
	np.tileIndex = index;
	Piece* p = [[Piece alloc] initWithType:theType];
	np.piece = p;
	[p release];
	[np Commit];
	
	[[MainViewController GetGameAreaView] AddNewPiece:np.piece atIndex:index];
	
	return [np autorelease];
}


- (int) GetTileWidth
{
	return (int)floor(320.0 / [GameController GetCurrentLevel].width);
}


- (int)GetLevelgroupIndex
{
	return levelgroupIndex;
}

@end
