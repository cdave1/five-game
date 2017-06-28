//
//  EditorViewController.m
//  ARTest
//
//  Created by david on 20/12/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import "MapViewController.h"


@implementation MapViewController

@synthesize mapView;
@synthesize mapInteractionView;


// Translate a touchpoint to a position in the array.
+ (NSInteger)CGPointToTileIndex:(CGPoint)point
{
	NSInteger pos = (floor(point.y / kMapTileWidth) * kMapTilesWidthCount) + floor(point.x / kMapTileWidth);
	return pos;
}


// Translate a position in the array to point (top left of the tile)
+ (CGPoint)tileIndexToCGPoint:(NSInteger)tileIndex
{
	CGFloat x = (tileIndex % kMapTilesWidthCount) * kMapTileWidth;
	CGFloat y = (tileIndex / kMapTilesWidthCount) * kMapTileWidth;
	return CGPointMake(x, y);
}


- init
{
	if ((self = [super initWithNibName:nil bundle:nil]) != nil)
	{
		self.title = @"Map";
		self.navigationItem.hidesBackButton = YES;
	}
	return self;
}


- (void)loadView
{
	UIView *v = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];

	// width of 26x12, height of 26x16 = 312 x 416
	
	CGRect mapViewRect = CGRectMake(4.0f, 48.0f, (kMapTileWidth * kMapTilesWidthCount), (kMapTileWidth * kMapTilesHeightCount));
	
	mapView = [[MapView alloc] initWithFrame:mapViewRect];
	
	mapInteractionView = [[MapInteractionView alloc] initWithMapView:mapViewRect mapView:mapView];
	
	[v addSubview:mapInteractionView];
	[v addSubview:mapView];
	[v bringSubviewToFront:mapInteractionView];

	// HACK HACK HACK
	//
	// backgroundView is not a subview of mapView, but is created
	// there because the map view controls all of the drawing to it.
	// This needs to be refactored.
	//[v addSubview:mapView.backgroundView];
	
	// want a palette, photoshop style.
	// - select - select individual tile
	// tiles - paint a tile // touch and drag to create areas of tiles.
	// erase - remove a tile, or a piece on the tile
	// pieces: colours etc
	// There must be a border around the playarea that shows the max w/h of the play area.
	
	// button bar at bottom with controls for saving.
	buttonBar = [UIToolbar new];
	buttonBar.barStyle = UIBarStyleBlackTranslucent;
	[buttonBar sizeToFit];
	CGFloat buttonBarHeight = [buttonBar frame].size.height;
	CGRect mainViewBounds = v.bounds;
	[buttonBar setFrame:CGRectMake(CGRectGetMinX(mainViewBounds),
								   CGRectGetMinY(mainViewBounds) + CGRectGetHeight(mainViewBounds) - (buttonBarHeight * 2.0f),
								   CGRectGetWidth(mainViewBounds),
								   buttonBarHeight)];
	ptr = [[UIBarButtonItem alloc] initWithTitle:@"Ptr" style:UIBarButtonItemStyleBordered
															target:self 
															action:@selector(ptrTouch:)];
	tiler = [[UIBarButtonItem alloc] initWithTitle:@"Tile" style:UIBarButtonItemStylePlain
															target:self 
															action:@selector(tilerTouch:)];
	eraser = [[UIBarButtonItem alloc] initWithTitle:@"Erase" style:UIBarButtonItemStylePlain
															target:self 
															action:@selector(eraserTouch:)];
	NSArray *buttonItems = [NSArray arrayWithObjects:ptr, tiler, eraser, nil];
	[buttonBar setItems:buttonItems animated:NO];
	[v addSubview:buttonBar];
	
	
	
	
	
	// want a view on which you can click and drag a finger to create 
	
	
	self.view = v;
}


- (void)ptrTouch:(id)sender
{
	// set the editorMode property of mapView
	ptr.style = UIBarButtonItemStyleBordered;
	tiler.style = UIBarButtonItemStylePlain;
	eraser.style = UIBarButtonItemStylePlain;
	mapInteractionView.editorMode = PointerEditorMode;
}


- (void)tilerTouch:(id)sender
{
	ptr.style = UIBarButtonItemStylePlain;
	tiler.style = UIBarButtonItemStyleBordered;
	eraser.style = UIBarButtonItemStylePlain;
	mapInteractionView.editorMode = TilerEditorMode;
}


- (void)eraserTouch:(id)sender
{
	ptr.style = UIBarButtonItemStylePlain;
	tiler.style = UIBarButtonItemStylePlain;
	eraser.style = UIBarButtonItemStyleBordered;
	mapInteractionView.editorMode = EraserEditorMode;
}



@end
