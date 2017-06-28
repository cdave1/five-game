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
	NSInteger tileIndex;
	Tile* tile;
}

@property(readwrite) NSInteger tileIndex;

-(id)initWithTile:(Tile *)theTile;
-(id)initWithTileIndex:(NSInteger)index;



@end
