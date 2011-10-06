//
//  NewPieceAnimDelegate.m
//  ARTest
//
//  Created by david on 10/01/09.
//  Copyright 2009 n/a. All rights reserved.
//

#import "AnimationDelegates.h"

@implementation NewPieceAnimDelegate

@synthesize index, newPiece, endDelegate;

- (void)animationDidStart:(CAAnimation *)theAnimation
{
	UIView *currView = [StateChangeTransactionAnimator GetStateChangeView:newPiece];
	if (currView.alpha != 1.0) currView.alpha = 1.0;
}


// take the next animation on the state change set and run it, using self 
// as the delegate.
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	if (self.index < self.newPiece.gameActions.count) 
	{
		GameAction *next = [self.newPiece.gameActions objectAtIndex:self.index];
		self.index += 1;
		[StateChangeTransactionAnimator AnimateGameAction:next endDelegate:self];
	} 
	else 
	{
		[self.endDelegate animationDidStop:nil finished:YES];
	}
}
@end
