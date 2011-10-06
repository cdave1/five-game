//
//  MapInteractionView.m
//  ARTest
//
//  Created by david on 7/01/09.
//  Copyright 2009 n/a. All rights reserved.
//

#import "MapInteractionView.h"
#import "MapViewController.h"
#import "LevelEditor.h"

@implementation MapInteractionView

@synthesize touchBeganTileIndex, touchEndedTileIndex, editorMode, mapView;


- initWithMapView:(CGRect)frame mapView:(MapView *)theMapView
{
	if ((self = [super initWithFrame:frame]) != nil) {
		self.editorMode = PointerEditorMode;
		self.mapView = theMapView;
		self.opaque = NO;
	}
	return self;
}


- (void)drawRect:(CGRect)rect 
{
	if (self.editorMode == PointerEditorMode)
	{
		[self DrawPointerMode];
	} 
	else if (self.editorMode == TilerEditorMode)
	{
		[self DrawTilerMode];
	}
	else if (self.editorMode == EraserEditorMode)
	{
		[self DrawEraseMode];
	}
	
} 


- (void)DrawPointerMode
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	// Draw a square on the tile repping the start move point
	CGPoint p;
	if (self.touchBeganTileIndex != -1 && self.touchEndedTileIndex == -1)
	{
		p = [MapViewController tileIndexToCGPoint:self.touchBeganTileIndex];
		CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 0.5);
		CGContextFillEllipseInRect(context, CGRectMake(p.x - ((100.0f - kMapTileWidth) / 2.0f), p.y - ((100.0f - kMapTileWidth) / 2.0f), 100.0, 100.0));
		CGContextSetRGBFillColor(UIGraphicsGetCurrentContext(), 1.0, 1.0, 1.0, 1.0);
		CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(p.x, p.y, kMapTileWidth, kMapTileWidth));
	}
	else if (self.touchEndedTileIndex != -1 && self.touchEndedTileIndex != -1)
	{
		p = [MapViewController tileIndexToCGPoint:self.touchEndedTileIndex];
		CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 0.5);
		CGContextFillEllipseInRect(context, CGRectMake(p.x - ((100.0f - kMapTileWidth) / 2.0f), p.y - ((100.0f - kMapTileWidth) / 2.0f), 100.0, 100.0));
		CGContextSetRGBFillColor(UIGraphicsGetCurrentContext(), 1.0, 1.0, 1.0, 1.0);
		CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(p.x, p.y, kMapTileWidth, kMapTileWidth));
	}
	context = nil;
}


- (void)DrawTilerMode
{
	[self DrawModifySquare];
}


- (void)DrawEraseMode
{
	[self DrawModifySquare];
}


- (void)DrawModifySquare
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	// Ensure that the next DrawTiledImage call draws within these bounds.
	CGContextClipToRect(context, CGRectMake(0.0f, 0.0f, (kMapTileWidth * kMapTilesWidthCount), (kMapTileWidth * kMapTilesHeightCount)));
	
	
	// Draw a square on the tile repping the start move point
	if (self.touchBeganTileIndex != -1)
	{
		CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 0.5);
		
		CGPoint p = [MapViewController tileIndexToCGPoint:self.touchBeganTileIndex];
		CGContextFillEllipseInRect(context, CGRectMake(p.x - ((100.0f - kMapTileWidth) / 2.0f), p.y - ((100.0f - kMapTileWidth) / 2.0f), 100.0, 100.0));
		
		CGContextSetRGBFillColor(UIGraphicsGetCurrentContext(), 1.0, 1.0, 1.0, 1.0);
		CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(p.x, p.y, kMapTileWidth, kMapTileWidth));
	}
	
	// Draw an ellipse at the ending point. 
	if (self.touchEndedTileIndex != -1 && self.touchEndedTileIndex != self.touchBeganTileIndex)
	{
		CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 0.5);
		CGPoint p = [MapViewController tileIndexToCGPoint:self.touchEndedTileIndex];
		CGContextFillEllipseInRect(context, CGRectMake(p.x - ((100.0f - kMapTileWidth) / 2.0f), p.y - ((100.0f - kMapTileWidth) / 2.0f), 100.0, 100.0));		
	}
	
	// Draw a square for the squares created
	if (self.touchEndedTileIndex != -1 && self.touchBeganTileIndex != -1) {
		short began_row = floor(self.touchBeganTileIndex / kMapTilesWidthCount);
		short began_col = (self.touchBeganTileIndex % kMapTilesWidthCount);
		
		short ended_row = floor(self.touchEndedTileIndex / kMapTilesWidthCount);
		short ended_col = (self.touchEndedTileIndex % kMapTilesWidthCount);
		
		short min_col = (began_col < ended_col) ? began_col : ended_col;
		short max_col = (began_col >= ended_col) ? began_col : ended_col;
		short min_row = (began_row < ended_row) ? began_row : ended_row;
		short max_row = (began_row >= ended_row) ? began_row : ended_row;
		
		for (int i = min_col; i <= max_col; i++)
		{
			for (int j = min_row; j <= max_row; j++)
			{
				CGPoint p = [MapViewController tileIndexToCGPoint:((j * kMapTilesWidthCount) + i)];
				CGContextSetRGBFillColor(UIGraphicsGetCurrentContext(), 1.0, 1.0, 1.0, 1.0);
				CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(p.x, p.y, kMapTileWidth, kMapTileWidth));		
			}
		}
	}
	
	CGContextFlush(context);
	context = nil;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];	
	self.touchBeganTileIndex = [MapViewController CGPointToTileIndex:[touch locationInView:self]];
	self.touchEndedTileIndex = self.touchBeganTileIndex;
	[self setNeedsDisplay];
	[[self nextResponder] touchesBegan:touches withEvent:event];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];	
	self.touchEndedTileIndex = [MapViewController CGPointToTileIndex:[touch locationInView:self]];
	[self setNeedsDisplay];
	[[self nextResponder] touchesMoved:touches withEvent:event];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];
	
	self.touchEndedTileIndex = [MapViewController CGPointToTileIndex:[touch locationInView:self]];

	if ([touch tapCount] == 2)
	{
		MapTileView *mapTileView = (MapTileView *)[self.mapView viewWithTag:self.touchEndedTileIndex + 100];
		[LevelEditor showTileEditorDialog:mapTileView];
	} 
	else 
	{
		if (self.editorMode == TilerEditorMode)
		{
			[self.mapView CreateTiles:self.touchBeganTileIndex to:self.touchEndedTileIndex];
		}
		else if (self.editorMode == EraserEditorMode)
		{
			[self.mapView EraseTiles:self.touchBeganTileIndex to:self.touchEndedTileIndex];
		}
	}
	
	self.touchBeganTileIndex = -1;
	self.touchEndedTileIndex = -1;
	[self setNeedsDisplay];
	
}

@end
