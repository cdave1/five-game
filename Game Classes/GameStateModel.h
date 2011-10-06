//
//  GameStateModel.h
//  QuartzFeedback
//
// Keeps a model of the game in memory; handles saving of the state
// when the application is terminated.
//
//  Created by david on 20/11/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameClasses.h"
#import "StateChange.h"
#import "StateChangeTransaction.h"

#define MAX_DISTANCE 255

#define NORTH -([GameController GetCurrentLevel].width)
#define NORTHEAST -([GameController GetCurrentLevel].width)+1
#define EAST 1
#define SOUTHEAST ([GameController GetCurrentLevel].width)+1
#define SOUTH ([GameController GetCurrentLevel].width)
#define SOUTHWEST ([GameController GetCurrentLevel].width)-1
#define WEST -1
#define NORTHWEST -([GameController GetCurrentLevel].width)-1


@interface GameStateModel : NSObject {}
+ (BOOL)TryNextMove:(int)fromIndex to:(int)toIndex;
+ (TileMove *)TileMoveMake:(int)fromIndex to:(int)toIndex;
+ (NSMutableArray *)FindMovementPath:(int)fromIndex to:(int)toIndex;
+ (NSMutableArray *)GetWinningTileSets;
@end
