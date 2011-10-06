//
//  BonusPaperworkAction.m
//  ARTest
//
//  Created by david on 14/01/09.
//  Copyright 2009 n/a. All rights reserved.
//

#import "StateChange.h"
#import "GoalClasses.h"
#import "GameController.h"


// Goal classes
@implementation BonusPaperworkAction
@synthesize bonus, points;
- (void) Commit
{
	/*
	if ([(NSObject *)bonus isKindOfClass:[PointsBonus class]])
	{
		[GameController AddPointsToGame:((PointsBonus *)self.bonus).points];
	}
	else if ([(NSObject *)bonus isKindOfClass:[GoalMultiplierBonus class]])
	{
		int multiplier = ((GoalMultiplierBonus *)self.bonus).multiplier - 1;
		[GameController AddPointsToGame:multiplier * self.points];
	}
	 */
}


- (void) Reverse
{
	/*
	if ([(NSObject *)bonus isKindOfClass:[PointsBonus class]])
	{
		// Just remove points from the current level.
		[GameController RemovePointsFromGame:((PointsBonus *)self.bonus).points];
	}
	 */
}
@end
