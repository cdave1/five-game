//
//  StandardGame.h
//  QuartzFeedback
//
//  Created by david on 12/12/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransactedGameController.h"


@interface StandardGame : TransactedGameController <GameControllerDelegate> 
{
	int totalPoints;
	int totalMoves;
	NSMutableArray* gameGoals;
}


@end
