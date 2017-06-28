//
//  MapView.h
//  QuartzFeedback
//
//  Created by david on 6/12/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameClasses.h"
#import "MapTileView.h"
#import "Constants.h"



@interface MapView : UIView {
	@private CGImageRef backgroundImageRef;
}

@property(readwrite) CGImageRef backgroundImageRef;


- (void) resetView;
- (void)loadLevel:(Level *)level;

- (void)CreateTiles:(NSInteger)touchBeganTileIndex to:(NSInteger)touchEndedTileIndex;
- (void)EraseTiles:(NSInteger)touchBeganTileIndex to:(NSInteger)touchEndedTileIndex;


@end
