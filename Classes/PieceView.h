//
//  PieceView.h
//  QuartzFeedback
//
//  Created by david on 8/12/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataClasses.h"
//#import "Tile.h"
//#import "GameAreaView.h"
//#import "Piece.h"


@interface PieceView : UIImageView {
	Piece* piece;
}

@property(retain) Piece* piece;

- initWithPiece:(Piece *)p;
+ (PieceView *)PieceViewMake:(Piece*)p;
+ (void)RemovePieceAtTileIndex:(int)tileIndex;
+ (PieceView *)GetPieceViewAtPoint:(CGPoint)point;
+ (void)ClearPieces;
+(UIImage *)GetPieceImage:(int)index;
+(NSMutableArray *)GetImageDatabase;

@end
