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
	@private NSInteger touchBeganTileIndex;
	@private NSInteger touchEndedTileIndex;
	@private MapView* mapView;
	@private MapEditorMode editorMode;
}

- initWithMapView:(CGRect)frame mapView:(MapView *)theMapView;

@property(readwrite) MapEditorMode editorMode;
@property(readwrite, retain) MapView* mapView;
@property(readwrite) NSInteger touchBeganTileIndex;
@property(readwrite) NSInteger touchEndedTileIndex;

- (void)DrawModifySquare;
- (void)DrawTilerMode;
- (void)DrawPointerMode;
- (void)DrawEraseMode;


@end
