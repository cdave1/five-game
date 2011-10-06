//
//  LevelGame.h
//  QuartzFeedback
//
//  Created by david on 12/12/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransactedGameController.h"
#import "PlayerWonLevelViewController.h"


@interface LevelGame : TransactedGameController <GameControllerDelegate> {
	Levelgroup *levelgroup;
	int totalPoints;
	int totalMoves;
	int levelIndex;
	int levelgroupIndex;
	NSMutableArray* gameGoals;
}

@property(readwrite, retain) Levelgroup *levelgroup;

@end
