//
//  PointsPaperworkAction.m
//  ARTest
//
//  Created by david on 14/01/09.
//  Copyright 2009 n/a. All rights reserved.
//


#import "StateChange.h"
#import "GoalClasses.h"
#import "GameController.h"


// Goal classes
@implementation PointsPaperworkAction
@synthesize points;
- (void) Commit
{
	[GameController AddPointsToGame:self.points];
}


- (void) Reverse
{
	[GameController RemovePointsFromGame:self.points];
}
@end