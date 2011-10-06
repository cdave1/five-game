//
//  GoalClasses.h
//  ARTest
//
//  Created by david on 13/01/09.
//  Copyright 2009 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StateChange.h"

@class Goal;
@class ResourceGoal;


@protocol GoalFunctions
@optional
- (BOOL)AddWinningMove:(WinningMove *)move;
- (BOOL)isAchieved;
- (NSString *)getMessage;
- (void)ResetProgress;
- (NSMutableArray *)GetBonuses;
@end


@interface Goal : NSObject <GoalFunctions>
{
	Bonus* bonus;
}

@property(readwrite, retain) Bonus* bonus;
@end


// Goal for completing a certain number of lines
// of a certain type or length.
@interface LinesGoal : Goal <NSCoding, GoalFunctions>
{
	PieceType requiredPieceType;
	int requiredLength;
	int requiredCount;
	int progressCount;
}
@property(readwrite) PieceType requiredPieceType;
@property(readwrite) int requiredLength, requiredCount, progressCount;
@end


@interface ConsecutiveGoal : Goal <GoalFunctions>
{
	NSMutableArray* goals;
}
@property(readwrite, retain) NSMutableArray* goals;

@end


// Collect a number of tiles of a certain type.
@interface ResourceGoal : Goal <NSCoding, GoalFunctions>
{
	PieceType requiredPieceType;
	int requiredQuantity;
	int progressQuantity;
}
@property(readwrite) PieceType requiredPieceType;
@property(readwrite) int requiredQuantity, progressQuantity;
@end


@protocol Bonus
- (NSString *)getMessage;
- (int)applyBonus:(int)toPoints;
@end


@interface PointsBonus : NSObject <NSCoding, Bonus>
{
	int points;
}
@property (readwrite) int points;
@end


@interface MultiplierBonus : NSObject <NSCoding, Bonus>
{
	int multiplier;
}
@property (readwrite) int multiplier;
@end


@interface GoalMultiplierBonus : NSObject <Bonus>
{
	Goal* parentGoal;
}
@property (readwrite, retain) Goal* parentGoal;
@property (readonly) int multiplier;
@end


@interface ItemBonus : NSObject <NSCoding, Bonus>
{
	int points;
	BonusItemType bonusItemType;
}
@property (readwrite) int points;
@property (readwrite) BonusItemType bonusItemType;
@end


// Actions that update the player's points, give
// a bonus, among other things.
@interface BonusPaperworkAction : PaperworkAction <StateChange> 
{
	id bonus;
	int points;
}
@property(retain) id bonus;
@property(readwrite) int points;
@end
