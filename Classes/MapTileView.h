//
//  TileView.h
//  QuartzFeedback
//
//  Created by david on 28/11/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameClasses.h"
#import "Constants.h"


@interface MapTileView : UIView {
	Tile* tile;
	UIImageView *backgroundImageView;
	UIImageView *pieceImageView;
}

@property(readwrite, retain) Tile* tile;
@property(readwrite, retain) UIImageView *pieceImageView;

-(id)initWithTile:(Tile *)theTile;

@end
