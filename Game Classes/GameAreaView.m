//
//  GameplayAreaView.m
//  QuartzFeedback
//
//  Created by david on 20/11/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import "GameAreaView.h"

@implementation GameAreaView

@synthesize touchBeganTileIndex;
@synthesize tileMove;


- initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]) != nil)
	{
		self.touchBeganTileIndex = -1;
		self.opaque = NO;		
	}
	return self;
}


- (void)drawRect:(CGRect)rect 
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	// Ensure that the next DrawTiledImage call draws within these bounds.
	CGContextClipToRect(context, CGRectMake(0.0, 0.0, 320.0, 400.0));
	
	float tileXY = [GameController GetTileWidth];
	
	// Draw a square on the tile repping the start move point
	if (self.touchBeganTileIndex != -1)
	{
		CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 0.5);
		
		CGPoint p = [GameAreaView tileIndexToCGPoint:self.touchBeganTileIndex];
		CGContextFillEllipseInRect(context, CGRectMake(p.x - ((100.0f - tileXY)/2), p.y - ((100.0f - tileXY)/2), 100.0, 100.0));
		//CGContextFillRect(context, CGRectMake(p.x, p.y, 40.0, 40.0));
	}
	
	if (self.tileMove != nil)
	{
		
		CGFloat count = 0.0;
		for(Tile* t in self.tileMove.tilePath)
		{
			CGFloat opacity = count / self.tileMove.tilePath.count; 
			count += 1.0;
			
			CGContextSetRGBFillColor(UIGraphicsGetCurrentContext(), 1.0, 1.0, opacity, 1.0);
			CGPoint p = [GameAreaView tileIndexToCGPoint:t.index];
			CGContextFillRect(UIGraphicsGetCurrentContext(), CGRectMake(p.x, p.y, tileXY, tileXY));
		}

		CGContextSetRGBFillColor(UIGraphicsGetCurrentContext(), 1.0, 1.0, 1.0, 0.5);
		CGPoint p = [GameAreaView tileIndexToCGPoint:self.tileMove.toIndex];
		CGContextFillEllipseInRect(UIGraphicsGetCurrentContext(), CGRectMake(p.x - ((100.0f - tileXY)/2), p.y - ((100.0f - tileXY)/2), 100.0, 100.0));	
 
	}
	CGContextFlush(context);
	 
	context = nil;
} 


// Assigns indices to each of the tiles in this level.
- (void)LoadCurrentLevel
{
	[PieceView ClearPieces];
	NSArray* tiles = [GameController GetTiles];
	for (int i = 0; i < tiles.count; i++) {
		Tile *t = [tiles objectAtIndex:i];
		TileView *tileView = [[TileView alloc] initWithTile:t]; // no need to retrieve the tile anymore
		tileView.tag = t.index + 100;
		
		[self addSubview:tileView];
		[tileView release];
	}	
}


-(PieceView *)AddNewPiece:(Piece *)piece atIndex:(NSInteger)index
{
	CGPoint p = [GameAreaView tileIndexToCGPoint:index];
	PieceView *pieceView = [PieceView PieceViewMake:piece];
	[self addSubview:pieceView];
	
	float tileXY = [GameController GetTileWidth];
	pieceView.center = CGPointMake(p.x + (tileXY / 2), p.y + (tileXY / 2));
	return pieceView;
}


- (void)RemovePiece:(NSInteger)pos
{
	CGPoint p = [GameAreaView tileIndexToCGPoint:pos];
	PieceView *pieceView = [PieceView GetPieceViewAtPoint:p];
	[pieceView removeFromSuperview];
	pieceView = nil;
}


-(UIView *)GetTileViewAtIndex:(NSInteger)index
{
	return [self viewWithTag:index + 100];
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];	
	NSInteger to = [GameAreaView CGPointToTileIndex:[touch locationInView:self]];
	self.touchBeganTileIndex = to;
	
	//[GameController BeginMove];
	[self setNeedsDisplay];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];	
	NSInteger to = [GameAreaView CGPointToTileIndex:[touch locationInView:self]];

	self.tileMove = [GameController TryNextMove:self.touchBeganTileIndex to:to];
	
	[self setNeedsDisplay];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	UITouch *touch = [touches anyObject];	
	NSInteger to = [GameAreaView CGPointToTileIndex:[touch locationInView:self]];
	if ([GameController SetNextMove:[(TileView *)touch.view tileIndex] to:to]) {
		[GameController CompleteMove];
	}
	
	self.tileMove = nil;
	self.touchBeganTileIndex = -1;
	[self setNeedsDisplay];
}


// Translate a touchpoint to a position in the array.
+ (NSInteger)CGPointToTileIndex:(CGPoint)point
{
	float tileXY = [GameController GetTileWidth];
	
	int index = (floor(point.y / tileXY) * [GameController GetCurrentLevel].width) + floor(point.x / tileXY);
	return index;
}


// Translate a position in the array to point (top left of the tile)
+ (CGPoint)tileIndexToCGPoint:(NSInteger)tileIndex
{
	float tileXY = [GameController GetTileWidth];
	
	CGFloat x = (tileIndex % [GameController GetCurrentLevel].width) * tileXY;
	CGFloat y = floor(tileIndex / [GameController GetCurrentLevel].width) * tileXY;

	return CGPointMake(x, y);
}


@end


	
