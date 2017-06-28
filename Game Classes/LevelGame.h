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
	NSInteger totalPoints;
	NSInteger totalMoves;
	NSInteger levelIndex;
	NSInteger levelgroupIndex;
	NSMutableArray* gameGoals;
}

@property(readwrite, retain) Levelgroup *levelgroup;

@end
