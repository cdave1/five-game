//
//  PieceView.m
//  QuartzFeedback
//
//  Created by david on 8/12/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import "PieceView.h"
#import "GameAreaView.h"


static NSMutableDictionary* ImageDatabase;
static NSMutableArray* PieceViewList;


@implementation PieceView

@synthesize piece;

+(UIImage *)GetPieceImage:(PieceType)pieceType
{
	return [[PieceView GetImageDatabase] objectForKey:[NSNumber numberWithInt:(int)pieceType]];
}


+(NSMutableDictionary *)GetImageDatabase
{
	if (ImageDatabase == nil)
	{
		ImageDatabase = [[NSMutableDictionary alloc] init];
	
		NSString* resourcePath = [[NSBundle mainBundle] pathForResource:@"marker_red" ofType:@"png"];
		UIImage* red = [[UIImage alloc] initWithContentsOfFile:resourcePath];
		[ImageDatabase setObject:red forKey:[NSNumber numberWithInt:(int)RedPiece]];
		[red release];

		resourcePath = [[NSBundle mainBundle] pathForResource:@"marker_orange" ofType:@"png"];
		UIImage* orange = [[UIImage alloc] initWithContentsOfFile:resourcePath];
		[ImageDatabase setObject:orange forKey:[NSNumber numberWithInt:(int)OrangePiece]];
		[orange release];
		
		resourcePath = [[NSBundle mainBundle] pathForResource:@"marker_yellow" ofType:@"png"];
		UIImage* yellow = [[UIImage alloc] initWithContentsOfFile:resourcePath];
		[ImageDatabase setObject:yellow forKey:[NSNumber numberWithInt:(int)YellowPiece]];
		[yellow release];
		
		resourcePath = [[NSBundle mainBundle] pathForResource:@"marker_green" ofType:@"png"];
		UIImage* green = [[UIImage alloc] initWithContentsOfFile:resourcePath];
		[ImageDatabase setObject:green forKey:[NSNumber numberWithInt:(int)GreenPiece]];
		[green release];
		
		resourcePath = [[NSBundle mainBundle] pathForResource:@"marker_blue" ofType:@"png"];
		UIImage* lightblue = [[UIImage alloc] initWithContentsOfFile:resourcePath];
		[ImageDatabase setObject:lightblue forKey:[NSNumber numberWithInt:(int)BluePiece]];
		[lightblue release];
		
		resourcePath = [[NSBundle mainBundle] pathForResource:@"marker_indigo" ofType:@"png"];
		UIImage* darkblue = [[UIImage alloc] initWithContentsOfFile:resourcePath];
		[ImageDatabase setObject:darkblue forKey:[NSNumber numberWithInt:(int)IndigoPiece]];
		[darkblue release];
		
		resourcePath = [[NSBundle mainBundle] pathForResource:@"marker_violet" ofType:@"png"];
		UIImage* pink = [[UIImage alloc] initWithContentsOfFile:resourcePath];
		[ImageDatabase setObject:pink forKey:[NSNumber numberWithInt:(int)VioletPiece]];
		[pink release];
		
		/*
		resourcePath = [[NSBundle mainBundle] pathForResource:@"marker_black" ofType:@"png"];
		UIImage* black = [[UIImage alloc] initWithContentsOfFile:resourcePath];
		[ImageDatabase setObject:black forKey:[NSNumber numberWithInt:(int)BlackPiece]];
		[black release]; */
	}
	return ImageDatabase;
}

+ (void) dealloc
{
	[ImageDatabase release];
	ImageDatabase = nil;
	[super dealloc];
}


// PieceView has a handle to the piece for the lifetime of the view.
+ (PieceView *)PieceViewMake:(Piece*)p
{
	if (PieceViewList == nil)
	{
		PieceViewList = [[NSMutableArray alloc] init];
	}
	
	PieceView *pieceView = [[PieceView alloc] initWithPiece:p];
	[PieceViewList addObject:pieceView];
	return pieceView;
}


+ (PieceView *)GetPieceViewAtPoint:(CGPoint)point
{
	if (PieceViewList == nil) return nil;
	
	PieceView *ret = nil;
	
	for(PieceView* pieceView in PieceViewList)
	{
		if (pieceView.center.x == point.x && pieceView.center.y == point.y)
		{
			ret = pieceView;
			break;
		}
	}
	return ret;
}


+ (void)RemovePieceAtTileIndex:(NSInteger)tileIndex
{
	CGPoint pt = [GameAreaView tileIndexToCGPoint:tileIndex];
	
	float tileXY = [GameController GetTileWidth];
	
	PieceView *pieceView = [PieceView GetPieceViewAtPoint:CGPointMake(pt.x + (tileXY / 2), pt.y + (tileXY / 2))];
	if (pieceView != nil)
	{
		[pieceView removeFromSuperview];
		[PieceViewList removeObject:pieceView];
		[pieceView release];
	}
}


+ (void)ClearPieces
{
	[PieceViewList release];
	PieceViewList = nil;
}


- initWithPiece:(Piece *)p
{
	UIImage *img = [PieceView GetPieceImage:p.type];
	self = [super initWithImage:img];
	if (self != nil) {
		self.piece = p;
		self.alpha = 0.0f;
		self.opaque = NO;
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

@end
