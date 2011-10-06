//
//  TileMoveAnimDelegate.m
//  ARTest
//
//  Created by david on 10/01/09.
//  Copyright 2009 n/a. All rights reserved.
//

#import "AnimationDelegates.h"

@implementation TileMoveAnimDelegate

@synthesize tileMove;

- (void)animationDidStart:(CAAnimation *)theAnimation
{
	UIView *currView = [StateChangeTransactionAnimator GetStateChangeView:tileMove];
	TileView *tileView = (TileView *)[[MainViewController GetGameAreaView] GetTileViewAtIndex:tileMove.toIndex];
	currView.center = tileView.center;
}


// take the next animation on the state change set and run it, using self 
// as the delegate.
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	// Animate the attached player action
	[StateChangeTransactionAnimator AnimatePlayerAction:(PlayerAction *)tileMove];
}
@end
