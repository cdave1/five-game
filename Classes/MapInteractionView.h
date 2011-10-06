//
//  MapInteractionView.h
//  ARTest
//
//  Created by david on 7/01/09.
//  Copyright 2009 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"
#import "MapView.h"

// Top level view that acts as an interaction layer - showing
// overlays and selection boxes.
@interface MapInteractionView : UIView {
	@private int touchBeganTileIndex;
	@private int touchEndedTileIndex;
	@private MapView* mapView;
	@private MapEditorMode editorMode;
}

- initWithMapView:(CGRect)frame mapView:(MapView *)theMapView;

@property(readwrite) MapEditorMode editorMode;
@property(readwrite, retain) MapView* mapView;
@property(readwrite) int touchBeganTileIndex;
@property(readwrite) int touchEndedTileIndex;

- (void)DrawModifySquare;
- (void)DrawTilerMode;
- (void)DrawPointerMode;
- (void)DrawEraseMode;


@end
