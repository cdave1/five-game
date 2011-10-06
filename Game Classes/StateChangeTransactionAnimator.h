//
//  StateChangeTransactionAnimator.h
//  QuartzFeedback
//
//  Created by david on 5/12/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "GameAreaView.h"
#import "StateChangeTransaction.h"
#import "StateChange.h"
#import "TileView.h"
#import "PieceView.h"


@interface StateChangeTransactionAnimator : NSObject { }

+ (void)AnimateGameStart:(GameStart *)action;
+ (void)AnimatePlayerAction:(PlayerAction *)action;
+ (void)AnimateTileMove:(TileMove *)tileMove;
+ (void)AnimateGameAction:(GameAction *)action endDelegate:(id)del;



+ (CAAnimation *)GenerateAnimation:(NSObject<StateChange> *)stateChange;
+ (UIView *)GetStateChangeView:(NSObject<StateChange> *)stateChange;

+ (CAAnimation *)GenerateTileMoveAnimation:(TileMove *)tileMovementPath;
+ (CAAnimation *)GenerateNewPieceAnimation:(NewPiece *)newPiece;
+ (CAAnimation *)GenerateRemovePieceAnimation:(RemovePiece *)removePiece;
+ (CAAnimation *)GenerateWinningMoveAnimation:(WinningMove *)action;

@end



