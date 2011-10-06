//
//  TileView.h
//  QuartzFeedback
//
//  Created by david on 28/11/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameClasses.h"

@interface TileView : UIView {
	int tileIndex;
	Tile* tile;
}

@property(readwrite) int tileIndex;

-(id)initWithTile:(Tile *)theTile;
-(id)initWithTileIndex:(int)index;



@end
