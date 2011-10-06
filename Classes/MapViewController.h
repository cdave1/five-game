//
//  EditorViewController.h
//  ARTest
//
//  Created by david on 20/12/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapView.h"
#import "MapInteractionView.h"
#import "Constants.h"

@interface MapViewController : UIViewController {
	MapView *mapView;
	MapInteractionView *mapInteractionView;
	UIToolbar *buttonBar;
	UIBarButtonItem *ptr;
	UIBarButtonItem *tiler;
	UIBarButtonItem *eraser;
	
}
+ (int)CGPointToTileIndex:(CGPoint)point;
+ (CGPoint)tileIndexToCGPoint:(int)tileIndexToPoint;

@property(retain) MapView *mapView;
@property(retain) MapInteractionView *mapInteractionView;

@end
