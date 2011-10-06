//
//  PlayerActionAnimDelegate.m
//  ARTest
//
//  Created by david on 10/01/09.
//  Copyright 2009 n/a. All rights reserved.
//

#import "AnimationDelegates.h"

@implementation PlayerActionAnimDelegate
@synthesize index, action;

- (void)animationDidStart:(CAAnimation *)theAnimation
{
	GameAction *currAction = [self.action.gameActions objectAtIndex:self.index];
	UIView *currView = [StateChangeTransactionAnimator GetStateChangeView:currAction];
	
	if ([currAction isKindOfClass:[NewPiece class]]) {
		currView.alpha = 1.0;
	} else if ([currAction isKindOfClass:[RemovePiece class]]) {
		currView.alpha = 0.0;
	}
}


// take the next animation on the state change set and run it, using self 
// as the delegate.
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	if (self.index + 1 < self.action.gameActions.count) 
	{
		self.index += 1;
		GameAction *next = [self.action.gameActions objectAtIndex:self.index];
		[StateChangeTransactionAnimator AnimateGameAction:next endDelegate:self];
	} 
	else 
	{
		// Anim done	
	}
}
@end
