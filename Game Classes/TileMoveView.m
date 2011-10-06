//
//  TileMoveAnimatorDelegate.m
//  QuartzFeedback
//
//  Created by david on 4/12/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import "TileMoveView.h"
#import "GameAreaView.h"



@implementation TileMoveViewAnimationDelegate

@synthesize animView, gameAreaView, stateChange;

- (void)animationDidStart:(CAAnimation *)theAnimation
{
	self.animView.hidden = NO;
}


- (void)animationDidStop:(CAAnimation *)theAnimation finished:(BOOL)flag
{
	for(NSNumber *n in [self.stateChange TilesChanged])
	{
		[[(GameAreaView *)self.gameAreaView GetTileViewAtIndex:n.intValue] setNeedsDisplay];
	}
	self.animView.hidden = YES;
}


@end



// When a move is completed, this delegate object will animate the move.
@implementation TileMoveView

@synthesize gameAreaView, tileIndex, piece;

-(id)initWithSuperView:(UIView *)superView
{
	if ((self = [super initWithFrame:CGRectMake(0.0f, 0.0f, 40.0f, 40.0f)]) != nil)
	{
		self.opaque = NO;
		self.hidden = YES;
		self.gameAreaView = superView;
		self.userInteractionEnabled = NO;
		[self.gameAreaView addSubview:self];
	}
	return self;
}







@end
