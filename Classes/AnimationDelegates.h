//
//  AnimationDelegates.h
//  ARTest
//
//  Created by david on 10/01/09.
//  Copyright 2009 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MainViewController.h"
#import "StateChange.h"


@interface TileMoveAnimDelegate : NSObject
{
	TileMove* tileMove;
}
@property(retain) TileMove* tileMove;
@end


// Animates each of the game actions in the player action
@interface PlayerActionAnimDelegate : NSObject
{
	int index;
	PlayerAction* action;
}

@property(readwrite) int index;
@property(retain) PlayerAction* action;
@end


// Animates each of the game actions in the player action
@interface GameStartAnimDelegate : NSObject
{
	int index;
	GameStart* action;
}

@property(readwrite) int index;
@property(retain) GameStart* action;
@end


@interface NewPieceAnimDelegate : NSObject
{
	int index;
	NewPiece* newPiece;
	id endDelegate;
}
@property(readwrite) int index;
@property(retain) NewPiece* newPiece;
@property(retain) id endDelegate;
@end


@interface WinningMoveAnimDelegate : NSObject
{
	int index;
	WinningMove* winningMove;
	id endDelegate;
}
@property(readwrite) int index;
@property(retain) WinningMove* winningMove;
@property(retain) id endDelegate;
@end


@interface GameActionAnimDelegate : NSObject
{
	int index;
	GameAction* gameAction; // action from which the things are taken.
	id endDelegate;
	UIView *currView;
}
+ (CAAnimation *)GetNextAnimation:(PaperworkAction *)action;
+ (void)AnimateGameAction:(GameAction *)action endDelegate:(id)endDelegate;
+ (UIView *)GetNextView:(PaperworkAction *)action;

@property(readwrite) int index;
@property(retain) GameAction* gameAction;
@property(retain) id endDelegate;
@property(retain) UIView *currView;
@end