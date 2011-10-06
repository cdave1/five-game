//
//  TileView.m
//  QuartzFeedback
//
//  Created by david on 28/11/08.
//  Copyright 2008 n/a. All rights reserved.
//
#import "MapTileView.h"
#import "MapViewController.h"
#import "PieceView.h"
#import "LevelEditor.h"

@implementation MapTileView

@synthesize tile, pieceImageView;

- initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]) != nil)
	{
		self.opaque = NO;
		self.pieceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, kMapTileWidth, kMapTileWidth)];
		[self addSubview:self.pieceImageView];
	}
	return self;
}


// Just init with the frame at the position retrieved from the GameAreaView
-(id)initWithTile:(Tile *)theTile
{
	CGPoint topLeft = [MapViewController tileIndexToCGPoint:theTile.position];
	self = [self initWithFrame:CGRectMake(topLeft.x, topLeft.y, kMapTileWidth, kMapTileWidth)];
	if (self != nil) {
		self.tile = theTile;
		
		if (theTile.type == NormalTile) {
			self.backgroundColor = [UIColor blueColor];
		}
	}
	
	return self;
}


- (void)drawRect:(CGRect)frame
{
	if (self.tile.piece == nil) 
	{
		self.pieceImageView.image = nil;
	}
	else if (self.tile.piece.type == NullPiece)
	{
		self.pieceImageView.image = nil;
	} 
	else {
		self.pieceImageView.image = [PieceView GetPieceImage:self.tile.piece.type];
	}
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


@end
