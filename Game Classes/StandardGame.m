//
//  StandardGame.m
//  QuartzFeedback
//
//  Created by david on 12/12/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import "StandardGame.h"
#import "MainViewController.h"

@implementation StandardGame

- init
{
	if ((self = [super init]) != nil)
	{
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
		
		LinesGoal *redPieceGoal = [[LinesGoal alloc] init];
		redPieceGoal.requiredPieceType = RedPiece;
		redPieceGoal.requiredCount = 2;
		ItemBonus *bonus = [[ItemBonus alloc] init];
		bonus.points = 100;
		bonus.bonusItemType = RedJewelItem;
		redPieceGoal.bonus = (id)bonus;
		[cg.goals addObject:redPieceGoal];
		[bonus release];
		[redPieceGoal release];
		
		[gameGoals addObject:cg];
		[cg release];
	}
	return self;
}


- (void)dealloc
{
	[self.currentLevel release];
	self.currentLevel = nil;
	[gameGoals release];
	[super dealloc];
}	


- (BOOL)AdvanceLevel
{
	self.currentLevel = [[Level alloc] init];
	self.currentLevel.width = 8;
	self.currentLevel.height = 10;
	self.currentLevel.minlinesize = 3;
	
	self.currentLevel.tiles = [NSMutableArray arrayWithCapacity:80];
	int i = 0;
	while (i < 80)
	{
		Tile *t = [[Tile alloc] init];
		t.type = NormalTile;
		t.position = i;
		t.index = i;
		[self.currentLevel.tiles addObject:t];
		[t release];
		i++;
	}
	
	ResourceGoal *goal = [[ResourceGoal alloc] init];
	goal.requiredQuantity = 20;
	goal.requiredPieceType = RedPiece;
	[self.currentLevel.goals addObject:goal];
	[goal release];
	return YES;
}


- (void)LoadGameState
{
	srand(CFAbsoluteTimeGetCurrent());
	GameStart* gameStart = [[GameStart alloc] init];
	int i = 0;

	while (i++ < 6)
	{
		NewPiece* np = [self GenerateNewPiece];
		if (np == nil) break;
		[gameStart.newPieces addObject:np];
	}
	
	[gameStart Commit];
	[StateChangeTransactionAnimator AnimateGameStart:gameStart];
}


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


- (NewPiece *)GenerateNewPiece
{
	// TODO: change this; count the number of free tiles.
	// End the game if the count is zero; otherwise use the
	// rand() % tileCount to place the new piece.
	
	int index = (rand() % 80);
	
	Tile* t = [[self GetTiles] objectAtIndex:index];
	int count = 0;
	while(t.isEmpty == NO)
	{
		if (count++ >= 80) break;
		index = (rand() % 80);
		t = [[self GetTiles] objectAtIndex:index];
	}
	if (count >= 80) 
	{
		// End the game immediately - do not pass go, do not collect $200 dollars.
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
	Tile* t = [[self GetTiles] objectAtIndex:index];
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
	return floor(320.0 / [GameController GetCurrentLevel].width);
}


- (int)GetLevelgroupIndex
{
	return 0;
}


@end
