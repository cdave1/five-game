//
//  TileView.m
//  QuartzFeedback
//
//  Created by david on 28/11/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import "TileView.h"
#import "GameAreaView.h"

@implementation TileView

@dynamic tileIndex;

-(id)initWithTile:(Tile *)theTile
{
	CGPoint topLeft = [GameAreaView tileIndexToCGPoint:theTile.index];
	
	float tileXY = [GameController GetTileWidth];
	CGRect frame = CGRectMake(topLeft.x, topLeft.y, tileXY, tileXY);
	self = [super initWithFrame:frame];
	if (self != nil) {
		tile = theTile;
		if (theTile.type == WallTile) { self.backgroundColor = [UIColor whiteColor]; }
		else 
		{
			UIImageView* bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, tileXY, tileXY)];
			bgImageView.image = [UIImage imageNamed:@"grid2.png"];
			//bgImageView.alpha = 0.5;
			[self addSubview:bgImageView];
		}
		self.alpha = 0.75;
		self.opaque = NO;
	}
	return self;
}


// Just init with the frame at the position retrieved from the GameAreaView
-(id)initWithTileIndex:(NSInteger)index
{
	CGPoint topLeft = [GameAreaView tileIndexToCGPoint:index];
	
	float tileXY = [GameController GetTileWidth];

	self = [super initWithFrame:CGRectMake(topLeft.x, topLeft.y, tileXY, tileXY)];
	if (self != nil) {
		self.tileIndex = index;
		//self.opaque = NO;
	}
	return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[[self nextResponder] touchesBegan:touches withEvent:event];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[[self nextResponder] touchesMoved:touches withEvent:event];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[[self nextResponder] touchesEnded:touches withEvent:event];
}

-(NSInteger)tileIndex
{
	if (tile == nil) return -1;
	return tile.index;
}


@end
