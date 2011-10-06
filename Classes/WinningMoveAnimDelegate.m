//
//  WinningMoveAnimDelegate.m
//  ARTest
//
//  Created by david on 10/01/09.
//  Copyright 2009 n/a. All rights reserved.
//

#import "AnimationDelegates.h"

@interface WinningMoveAnimDelegate (Private)
- (void)RemoveIndividualPieceStart;
- (void)RemoveAllStart;
- (void)RemoveIndividualPieceStopped;
- (void)RemoveAllStopped;
@end



@implementation WinningMoveAnimDelegate
@synthesize index, winningMove, endDelegate;

- (void)animationDidStart:(CAAnimation *)theAnimation
{
	[self RemoveAllStart];
}


// take the next animation on the state change set and run it, using self 
// as the delegate.
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	[self RemoveAllStopped];
}


- (void)RemoveIndividualPieceStart
{
	//TileView *view = [[(GameAreaView *)self.gameAreaView GetTileViewAtIndex:n.intValue];
	RemovePiece *removePiece = [self.winningMove.removePieceActions objectAtIndex:self.index];
	UIView *currView = [StateChangeTransactionAnimator GetStateChangeView:removePiece];
	if (currView != nil) currView.alpha = 0.0;
}


- (void)RemoveAllStart
{
	for(int i = 0; i < self.winningMove.removePieceActions.count; i++)
	{
		RemovePiece *removePiece = [self.winningMove.removePieceActions objectAtIndex:i];
		UIView *view = [StateChangeTransactionAnimator GetStateChangeView:removePiece];
		if (view != nil) view.alpha = 0.0;
	}
}


- (void)RemoveIndividualPieceStopped
{ 
	RemovePiece *removePiece = [self.winningMove.removePieceActions objectAtIndex:self.index];
	if (removePiece != nil) [PieceView RemovePieceAtTileIndex:removePiece.tileIndex];
	
	if (self.index + 1 < self.winningMove.removePieceActions.count) 
	{
		RemovePiece *next = [self.winningMove.removePieceActions objectAtIndex:self.index + 1];
		UIView *nextView = [StateChangeTransactionAnimator GetStateChangeView:next];
		
		CAAnimation* anim = [StateChangeTransactionAnimator GenerateAnimation:next];
		if (anim == nil) return;
		if (nextView == nil) // will occur if another move removed the view.
		{
			self.index += 1;
			[self animationDidStop:nil finished:YES];
		} else {
			self.index += 1;
			anim.delegate = self;
			[nextView.layer addAnimation:anim forKey:@"WinningMoveAnimDelegate"];
		}
	}
	else 
	{
		[self.endDelegate animationDidStop:nil finished:YES];
	}
}


- (void)RemoveAllStopped
{
	for(int i = 0; i < self.winningMove.removePieceActions.count; i++)
	{
		RemovePiece *removePiece = [self.winningMove.removePieceActions objectAtIndex:i];
		if (removePiece != nil) [PieceView RemovePieceAtTileIndex:removePiece.tileIndex];	
		//UIView *view = [StateChangeTransactionAnimator GetStateChangeView:removePiece];
		//CAAnimation* anim = [StateChangeTransactionAnimator GenerateAnimation:removePiece];
		//if (view!=nil) [view.layer addAnimation:anim forKey:@"WinningMoveAnimDelegate"];
	}
	
	[self.endDelegate animationDidStop:nil finished:YES];
}



@end
