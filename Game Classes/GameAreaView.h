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
	@private NSInteger touchBeganTileIndex;
}


@property(readwrite) NSInteger touchBeganTileIndex;
@property(retain) TileMove* tileMove;

- (void)LoadCurrentLevel;
-(UIView *)GetTileViewAtIndex:(NSInteger)index;
-(PieceView *)AddNewPiece:(Piece *)piece atIndex:(NSInteger)index;

+ (NSInteger)CGPointToTileIndex:(CGPoint)point;
+ (CGPoint)tileIndexToCGPoint:(NSInteger)tileIndexToPoint;

@end


