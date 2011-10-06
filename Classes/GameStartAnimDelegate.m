//
//  GameStartAnimDelegate.m
//  ARTest
//
//  Created by david on 10/01/09.
//  Copyright 2009 n/a. All rights reserved.
//

#import "AnimationDelegates.h"


@implementation GameStartAnimDelegate
@synthesize index, action;

- (void)animationDidStart:(CAAnimation *)theAnimation
{
	NewPiece *np = [self.action.newPieces objectAtIndex:self.index];
	UIView *currView = [StateChangeTransactionAnimator GetStateChangeView:np];
	currView.alpha = 1.0;
}


// take the next animation on the state change set and run it, using self 
// as the delegate.
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	if (self.index < self.action.newPieces.count) {	
		NewPiece *next = [self.action.newPieces objectAtIndex:self.index + 1];
		UIView *nextView = [StateChangeTransactionAnimator GetStateChangeView:next];
		
		CAAnimation* anim = [StateChangeTransactionAnimator GenerateAnimation:next];
		self.index += 1;
		anim.delegate = self;
		
		if (nextView == nil) {
			[self animationDidStop:nil finished:YES];
		} else {
			[nextView.layer addAnimation:anim forKey:@"anim1"];
		}
	}
}
@end
