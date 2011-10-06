//
//  Animator.m
//  QuartzFeedback
//
//  Created by david on 1/12/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import "Animator.h"


@implementation Animator

// Problem: When the animation stops, the layer snaps back to the 
// original position. However, this occurs well before the 
// animationDidStop delegate event. 

// What this means is that the user sees a very brief flicker of the 
// old tile with the piece visible until setNeedsDisplay is called. I
// can't find a way to invoke setNeedsDisplay before the "snap back"
// occurs.
//
// The only way I can think of doing this is to NOT move the layer,
// but instead hide both the source and destination underneath a new
// movement animation layer that takes a copy of the piece and then
// performs the animation. Could even be another image of the piece.
// When the animation is done, we show the updated board. Given that
// I'm prevented from really doing what I want to do anyway, this might
// be the better option within the confines of the CA framework.
//
// BTW, this problem is far more prevalent on the iPhone than the 
// simulator, so it really is something I need to fix.
//
// Needs to draw a bunch of tiles.
//
// Needs to add a view at the "from" position, move it to the "to" position,
// and then on stop remove the view and update the game state.
- (void)AnimateTileMove:(TileMove *)move
{
	[CATransaction begin];
	// Set up a path animation
	CAKeyframeAnimation *move = [CAKeyframeAnimation animationWithKeyPath:@"position"];
	CGMutablePathRef thePath = CGPathCreateMutable();
	CGPathMoveToPoint(thePath, NULL, touch.view.center.x, touch.view.center.y);
	
	// Path comes out in reverse order. TODO: use reverse Enumerator
	for(int i = tilePath.count - 1; i >= 0; i--)
	{
		Tile* t = [tilePath objectAtIndex:i];
		CGPoint p = [GameAreaView tileIndexToCGPoint:t.index];
		CGPathAddLineToPoint(thePath, NULL, p.x + 20.0f, p.y + 20.0f);
	}
	move.delegate = self;
	move.repeatCount = 1;
	move.path = thePath;
	move.duration = 0.05f * tilePath.count;
	[self.layer addAnimation:move forKey:@"ttt"];
	[CATransaction commit];
}

@end
