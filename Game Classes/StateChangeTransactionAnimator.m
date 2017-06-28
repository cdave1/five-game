//
//  StateChangeTransactionAnimator.m
//  QuartzFeedback
//
//  Created by david on 5/12/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimationDelegates.h"
#import "StateChangeTransactionAnimator.h"
#import "GameAreaView.h"
#import "TileView.h"
#import "MainViewController.h"

@implementation StateChangeTransactionAnimator


+ (void)AnimateGameStart:(GameStart *)action
{
	if (action.newPieces.count > 0) {
		NewPiece *next = [action.newPieces objectAtIndex:0];
		UIView *view = [StateChangeTransactionAnimator GetStateChangeView:next];
		
		GameStartAnimDelegate *del = [[GameStartAnimDelegate alloc] init];
		CAAnimation* anim = [StateChangeTransactionAnimator GenerateAnimation:next];
		del.action = action;
		del.index = 0;
		anim.delegate = del;
		[del release];
		[view.layer addAnimation:anim forKey:@"Game Start"];
	}
}


+ (void)AnimateTileMove:(TileMove *)tileMove
{
	UIView *view = [StateChangeTransactionAnimator GetStateChangeView:tileMove];
	
	if (view != nil) {
		CAAnimation* anim = [StateChangeTransactionAnimator GenerateTileMoveAnimation:tileMove];
		
		TileMoveAnimDelegate *del = [[TileMoveAnimDelegate alloc] init];
		del.tileMove = tileMove;
		anim.delegate = del;
		[del release];
		[view.layer addAnimation:anim forKey:@"anim1"];
	}
}


+ (void)AnimatePlayerAction:(PlayerAction *)action
{
	if (action.gameActions.count > 0) {
		PlayerActionAnimDelegate *del = [[PlayerActionAnimDelegate alloc] init];
		del.action = action;
		del.index = 0;
		
		GameAction *next = [action.gameActions objectAtIndex:0];
		if ([next isKindOfClass:[WinningMove class]] || [next isKindOfClass:[NewPiece class]])
		{
			[StateChangeTransactionAnimator AnimateGameAction:next endDelegate:[del autorelease]];
		} 
		else 
		{
			UIView *view = [StateChangeTransactionAnimator GetStateChangeView:next];
			
			CAAnimation* anim = [StateChangeTransactionAnimator GenerateAnimation:next];
			anim.delegate = del;
			[del release];
			[view.layer addAnimation:anim forKey:@"anim1"];
		}
	}
}


// Animate all of the paperwork action in the game action object.
// End delegate is called when last paperwork animation stops.
+ (void)AnimateGameAction:(GameAction *)action endDelegate:(id)del
{
	if ([action isKindOfClass:[WinningMove class]]) {
		CAAnimation* anim = [StateChangeTransactionAnimator GenerateRemovePieceAnimation:nil];
		
		WinningMoveAnimDelegate *delegate = [[WinningMoveAnimDelegate alloc] init];
		anim.delegate = delegate;
		delegate.index = 0;
		delegate.winningMove = (WinningMove *)action;
		delegate.endDelegate = del;
		
		for(int i = 0; i < ((WinningMove *)action).removePieceActions.count; i++)
		{
			RemovePiece *removePiece = [((WinningMove *)action).removePieceActions objectAtIndex:i];
			
			UIView *view = [StateChangeTransactionAnimator GetStateChangeView:removePiece];
			if (view!=nil) [view.layer addAnimation:anim forKey:@"WinningMoveAnimDelegate"];
		}
		[delegate release];
		[GameActionAnimDelegate AnimateGameAction:action endDelegate:del];
	} 
	else if ([action isKindOfClass:[NewPiece class]]) {
		UIView *view = [StateChangeTransactionAnimator GetStateChangeView:action];
		NewPieceAnimDelegate *delegate = [[NewPieceAnimDelegate alloc] init];
		CAAnimation* anim = [StateChangeTransactionAnimator GenerateAnimation:action];
		delegate.newPiece = (NewPiece *)action;
		delegate.index = 0;
		delegate.endDelegate = del;
		anim.delegate = delegate;
		[delegate release];
		[view.layer addAnimation:anim forKey:@"New Piece"];
	}
	else if (action.paperworkActions.count > 0) {
		[GameActionAnimDelegate AnimateGameAction:action endDelegate:del];
	}
}


// Function with side effects.
+ (CAAnimation *)GenerateAnimation:(NSObject<StateChange> *)stateChange
{
	if ([stateChange isKindOfClass:[TileMove class]]) {
		return [StateChangeTransactionAnimator GenerateTileMoveAnimation:(TileMove *)stateChange];
	} else if ([stateChange isKindOfClass:[NewPiece class]]) {
		return [StateChangeTransactionAnimator GenerateNewPieceAnimation:(NewPiece *)stateChange];
	} else if ([stateChange isKindOfClass:[WinningMove class]]) {
		return [StateChangeTransactionAnimator GenerateWinningMoveAnimation:(WinningMove *)stateChange];
	} else if ([stateChange isKindOfClass:[RemovePiece class]]) {
		return [StateChangeTransactionAnimator GenerateRemovePieceAnimation:(RemovePiece *)stateChange];
	} else return nil;
}


+ (CAAnimation *)GenerateTileMoveAnimation:(TileMove *)tileMovementPath
{
	CGPoint from = [GameAreaView tileIndexToCGPoint:tileMovementPath.fromIndex];
	CAKeyframeAnimation *move = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	CGMutablePathRef thePath = CGPathCreateMutable();
	CGPathMoveToPoint(thePath, NULL, from.x + 20.0, from.y + 20.0);
	
	// Path comes out in reverse order. TODO: use reverse Enumerator
	for(NSInteger i = tileMovementPath.tilePath.count - 1; i >= 0; i--)
	{
		Tile* t = [tileMovementPath.tilePath objectAtIndex:i];
		CGPoint p = [GameAreaView tileIndexToCGPoint:t.index];
		CGPathAddLineToPoint(thePath, NULL, p.x + 20.0f, p.y + 20.0f);
	}
	
	move.repeatCount = 1;
	move.path = thePath;
	move.removedOnCompletion = NO;
	move.duration = 0.05f * tileMovementPath.tilePath.count;
	CGPathRelease(thePath);
	return move;
}


+ (CAAnimation *)GenerateWinningMoveAnimation:(WinningMove *)action
{
	CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
	anim.removedOnCompletion = YES;
	return anim;
}


+ (CAAnimation *)GenerateNewPieceAnimation:(NewPiece *)newPiece
{
	CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
	anim.duration = 0.1f;
	anim.fromValue = [NSNumber numberWithFloat:0.0];
	anim.toValue = [NSNumber numberWithFloat:1.0];
	anim.removedOnCompletion = NO;
	return anim;
}


+ (CAAnimation *)GenerateRemovePieceAnimation:(RemovePiece *)removePiece
{
	CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
	anim.duration = 0.2f;	
	anim.fromValue = [NSNumber numberWithFloat:1.0];
	anim.toValue = [NSNumber numberWithFloat:0.0];
	anim.removedOnCompletion = NO;
	return anim;
}


+ (void)animateNewPiece666:(NewPiece *)newPiece
{
	CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"opacity"];
	anim.duration = 1.0f;
	anim.fromValue = [NSNumber numberWithFloat:0.0];
	anim.toValue = [NSNumber numberWithFloat:1.0];
}



+ (UIView *)GetStateChangeView:(NSObject<StateChange> *)stateChange
{
	if ([stateChange isKindOfClass:[TileMove class]]) {
		TileView *tileView = (TileView *)[[MainViewController GetGameAreaView] GetTileViewAtIndex:((TileMove *)stateChange).fromIndex];
		if (tileView == nil) return nil;
		return [PieceView GetPieceViewAtPoint:tileView.center];	
	} else if ([stateChange isKindOfClass:[NewPiece class]]) {
		TileView *tileView = (TileView *)[[MainViewController GetGameAreaView] GetTileViewAtIndex:((NewPiece *)stateChange).tileIndex];
		if (tileView == nil) return nil;
		return [PieceView GetPieceViewAtPoint:tileView.center];	
		
	} else if ([stateChange isKindOfClass:[RemovePiece class]]) {
		TileView *tileView = (TileView *)[[MainViewController GetGameAreaView] GetTileViewAtIndex:((RemovePiece *)stateChange).tileIndex];
		if (tileView == nil) return nil;
		return [PieceView GetPieceViewAtPoint:tileView.center];	
	} else return nil;
}



@end


