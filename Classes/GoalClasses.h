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
	NSInteger requiredLength;
	NSInteger requiredCount;
	NSInteger progressCount;
}
@property(readwrite) PieceType requiredPieceType;
@property(readwrite) NSInteger requiredLength, requiredCount, progressCount;
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
	NSInteger requiredQuantity;
	NSInteger progressQuantity;
}
@property(readwrite) PieceType requiredPieceType;
@property(readwrite) NSInteger requiredQuantity, progressQuantity;
@end


@protocol Bonus
- (NSString *)getMessage;
- (NSInteger)applyBonus:(NSInteger)toPoints;
@end


@interface PointsBonus : NSObject <NSCoding, Bonus>
{
	NSInteger points;
}
@property (readwrite) NSInteger points;
@end


@interface MultiplierBonus : NSObject <NSCoding, Bonus>
{
	NSInteger multiplier;
}
@property (readwrite) NSInteger multiplier;
@end


@interface GoalMultiplierBonus : NSObject <Bonus>
{
	Goal* parentGoal;
}
@property (readwrite, retain) Goal* parentGoal;
@property (readonly) NSInteger multiplier;
@end


@interface ItemBonus : NSObject <NSCoding, Bonus>
{
	NSInteger points;
	BonusItemType bonusItemType;
}
@property (readwrite) NSInteger points;
@property (readwrite) BonusItemType bonusItemType;
@end


// Actions that update the player's points, give
// a bonus, among other things.
@interface BonusPaperworkAction : PaperworkAction <StateChange> 
{
	id bonus;
	NSInteger points;
}
@property(retain) id bonus;
@property(readwrite) NSInteger points;
@end
