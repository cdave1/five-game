//
//  MapView.m
//  QuartzFeedback
//
//  Created by david on 6/12/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import "MapView.h"


@implementation MapView

@synthesize backgroundImageRef;

- initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]) != nil) {
		self.backgroundColor = [UIColor darkGrayColor];
	}
	return self;
}


- (void) dealloc
{
	[super dealloc];
}


- (void)loadLevel:(Level *)level
{
	for (NSInteger i = 0; i < level.tiles.count; i++) {
		Tile *t = [level.tiles objectAtIndex:i];
		if (t.type == NormalTile) {
			MapTileView *mapTileView = [[MapTileView alloc] initWithTile:t];
			mapTileView.tag = t.position + 100;
			[self addSubview:mapTileView];
			[mapTileView release];
		}
	}
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self setNeedsDisplay];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self setNeedsDisplay];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[self setNeedsDisplay];
}


- (void)CreateTiles:(NSInteger)touchBeganTileIndex to:(NSInteger)touchEndedTileIndex
{
	// Create a bunch of tiles.
	if (touchEndedTileIndex != -1 && touchBeganTileIndex != -1) {
		short began_row = floor(touchBeganTileIndex / kMapTilesWidthCount);
		short began_col = (touchBeganTileIndex % kMapTilesWidthCount);
		
		short ended_row = floor(touchEndedTileIndex / kMapTilesWidthCount);
		short ended_col = (touchEndedTileIndex % kMapTilesWidthCount);
		
		// not sure where the min/max functions are, if any.
		short min_col = (began_col < ended_col) ? began_col : ended_col;
		short max_col = (began_col >= ended_col) ? began_col : ended_col;
		short min_row = (began_row < ended_row) ? began_row : ended_row;
		short max_row = (began_row >= ended_row) ? began_row : ended_row;
		
		for (NSInteger i = min_col; i <= max_col; i++)
		{
			for (NSInteger j = min_row; j <= max_row; j++)
			{
				NSInteger index = ((j * kMapTilesWidthCount) + i);
				if ([self viewWithTag:index + 100] == nil) {
					Tile* tile = [[Tile alloc] init];
					tile.position = index;
					tile.type = NormalTile;
					MapTileView *mapTileView = [[MapTileView alloc] initWithTile:tile];
					mapTileView.tag = index + 100;
					[self addSubview:mapTileView];
					[mapTileView release];
				}	
			}
		}
	}
}


- (void)EraseTiles:(NSInteger)touchBeganTileIndex to:(NSInteger)touchEndedTileIndex
{
	// Create a bunch of tiles.
	if (touchEndedTileIndex != -1 && touchBeganTileIndex != -1) {
		short began_row = floor(touchBeganTileIndex / kMapTilesWidthCount);
		short began_col = (touchBeganTileIndex % kMapTilesWidthCount);
		
		short ended_row = floor(touchEndedTileIndex / kMapTilesWidthCount);
		short ended_col = (touchEndedTileIndex % kMapTilesWidthCount);
		
		// not sure where the min/max functions are, if any.
		short min_col = (began_col < ended_col) ? began_col : ended_col;
		short max_col = (began_col >= ended_col) ? began_col : ended_col;
		short min_row = (began_row < ended_row) ? began_row : ended_row;
		short max_row = (began_row >= ended_row) ? began_row : ended_row;
		
		for (NSInteger i = min_col; i <= max_col; i++)
		{
			for (NSInteger j = min_row; j <= max_row; j++)
			{
				NSInteger index = ((j * kMapTilesWidthCount) + i);
				UIView* view = [self viewWithTag:index + 100];
				if (view != nil) {
					[view removeFromSuperview];
				}	
			}
		}
	}
}


// Lose the mapTileViews.
- (void) resetView
{
	NSInteger count = [self subviews].count - 1;
	while(count >= 0)
	{
		[[[self subviews] objectAtIndex:count--] removeFromSuperview];
	}
}


@end
