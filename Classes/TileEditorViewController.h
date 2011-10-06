//
//  TileEditorViewController.h
//  ARTest
//
//  Created by david on 22/12/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MapTileView.h"
#import "CustomPicker.h"

@interface TileEditorViewController : UIViewController {
	MapTileView* tileView;
	CustomPicker *customPickerView;
}
@property(readwrite, retain) CustomPicker *customPickerView;
@property(readwrite, retain) MapTileView* tileView;


@end
