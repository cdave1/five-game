//
//  GameActionAnimDelegate.m
//  ARTest
//
//  Created by david on 10/01/09.
//  Copyright 2009 n/a. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AnimationDelegates.h"
#import "PointsActionView.h"
#import "BonusActionView.h"

@implementation GameActionAnimDelegate
@synthesize index, gameAction, endDelegate, currView;


+ (void)AnimateGameAction:(GameAction *)action endDelegate:(id)endDelegate
{
	if (action.paperworkActions.count == 0) return;
	
	PaperworkAction *next = [action.paperworkActions objectAtIndex:0];
	
	GameActionAnimDelegate *delegate = [[GameActionAnimDelegate alloc] init];
	delegate.currView = [GameActionAnimDelegate GetNextView:next];
	CAAnimation* anim = [GameActionAnimDelegate GetNextAnimation:next];
	anim.delegate = delegate;
	delegate.index = 0;
	delegate.gameAction = action;
	delegate.endDelegate = endDelegate;
	[delegate release];
	[delegate.currView.layer addAnimation:anim forKey:@"anim1"];
}


- (void)animationDidStart:(CAAnimation *)theAnimation
{
	currView.alpha = 0.0;
}


// take the next animation on the state change set and run it, using self 
// as the delegate.
- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	//PaperworkAction *action = [self.gameAction.paperworkActions objectAtIndex:self.index];

	[currView removeFromSuperview];
	currView = nil;
	
	
	if (self.index < self.gameAction.paperworkActions.count) {	
		PaperworkAction *next = [self.gameAction.paperworkActions objectAtIndex:self.index + 1];
		currView = [GameActionAnimDelegate GetNextView:next];
		
		CAAnimation* anim = [GameActionAnimDelegate GetNextAnimation:next];
		anim.delegate = self;
		if (anim != nil) {
			if (currView == nil)
			{
				if (endDelegate == nil)
				{
					[self animationDidStop:nil finished:YES];
				} 
				else
				{
					anim.delegate = self.endDelegate;
				}
			} else {
				self.index += 1;
				[currView.layer addAnimation:anim forKey:@"anim1"];
			}
		}
	}
}


+ (CAAnimation *)GetNextAnimation:(PaperworkAction *)action
{
	if ([action isKindOfClass:[PointsPaperworkAction class]]) 
    {
		CAAnimationGroup *group = [CAAnimationGroup animation];	
		CAKeyframeAnimation *opacity = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
		
		NSNumber *a = [NSNumber numberWithFloat:1.0]; 
		NSNumber *b = [NSNumber numberWithFloat:1.0];
		NSNumber *c = [NSNumber numberWithFloat:1.0];
		
		opacity.values = [NSArray arrayWithObjects:a,b,c,nil];
		opacity.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.01], [NSNumber numberWithFloat:1.0], nil];
		opacity.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
		opacity.repeatCount = 1;
		opacity.duration = 0.8f;
		
		CAKeyframeAnimation *position = [CAKeyframeAnimation animationWithKeyPath:@"position"];
		CGMutablePathRef thePath = CGPathCreateMutable();
		
		int tileXY = [GameController GetTileWidth];

		// TODO: boundaries check. Could just check it in the middle of the screen?
		
		CGPathMoveToPoint(thePath, NULL, action.winningMove.center.x, action.winningMove.center.y + tileXY);
		CGPathAddLineToPoint(thePath, NULL,action.winningMove.center.x, action.winningMove.center.y - 10.0f);
		CGPathAddLineToPoint(thePath, NULL,[MainViewController sharedInstance].gameViewController.lblPoints.center.x, [MainViewController sharedInstance].gameViewController.lblPoints.center.y);

		opacity.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:0.95], [NSNumber numberWithFloat:1.0], nil];
		
		position.repeatCount = 1;
		position.path = thePath;
		position.duration = 0.8f;
		position.removedOnCompletion = NO;
		position.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
		CGPathRelease(thePath);
		
		group.animations = [NSArray arrayWithObjects:opacity, position, nil];
		group.repeatCount = 1;
		group.removedOnCompletion = NO;
		group.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
		group.duration = 0.8f;
		
		return group;
	} 
	else if ([action isKindOfClass:[BonusPaperworkAction class]]) 
	{
		CAKeyframeAnimation *anim = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
		NSNumber *a = [NSNumber numberWithFloat:0.0]; 
		NSNumber *b = [NSNumber numberWithFloat:1.0];
		anim.values = [NSArray arrayWithObjects:a,b,nil];
		anim.keyTimes = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0], [NSNumber numberWithFloat:1.0], nil];
		anim.repeatCount = 1;
		anim.removedOnCompletion = NO;
		anim.duration = 0.5f;
		return anim;
		
	} 
	else 
	{
		return nil;
	}
}


+ (UIView *)GetNextView:(PaperworkAction *)action
{
	if (action == nil) return nil;
	//PaperworkAction *action = [self.gameAction.paperworkActions objectAtIndex:self.index];
	
	if ([action isKindOfClass:[PointsPaperworkAction class]]) {
		PointsActionView *view = [[PointsActionView alloc] initWithPointsPaperworkAction:(PointsPaperworkAction *)action];
		
		CGPoint center = action.winningMove.center;
		view.frame = CGRectMake(center.x, center.y, 120.0f, 120.0f);
		[[MainViewController GetGameAreaView] addSubview:view];
		return [view autorelease];
		
	} 
	else if ([action isKindOfClass:[BonusPaperworkAction class]]) 
	{
		BonusActionView *view = [[BonusActionView alloc] initWithBonusPaperworkAction:(BonusPaperworkAction *)action];
		view.frame = CGRectMake(0.0f, 0.0f, 130.0f, 130.0f);
		view.center = [MainViewController GetGameAreaView].center;
		[[MainViewController GetGameAreaView] addSubview:view];
		return [view autorelease];
	} 
	else 
	{
		return nil;
	}
}

@end
