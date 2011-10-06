//
//  GameplayAreaView.h
//  QuartzFeedback
//
//  Created by david on 20/11/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GameAreaView.h"
#import "GameController.h"
#import "TileView.h"
#import "TileMoveView.h"
#import "PieceView.h"
#import "StateChangeTransactionAnimator.h"

@interface GameAreaView : UIView {
	@private TileMove *tileMove;
	@private int touchBeganTileIndex;
}


@property(readwrite) int touchBeganTileIndex;
@property(retain) TileMove* tileMove;

- (void)LoadCurrentLevel;
-(UIView *)GetTileViewAtIndex:(int)index;
-(PieceView *)AddNewPiece:(Piece *)piece atIndex:(int)index;

+ (int)CGPointToTileIndex:(CGPoint)point;
+ (CGPoint)tileIndexToCGPoint:(int)tileIndexToPoint;

@end


