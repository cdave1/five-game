//
//  TileEditorViewController.m
//  ARTest
//
//  Created by david on 22/12/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import "TileEditorViewController.h"
#import "LevelEditor.h"

@implementation TileEditorViewController

@synthesize tileView;
@synthesize customPickerView;

- (void)loadView
{
	UIView* v = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	
	customPickerView = [[CustomPicker alloc] initWithFrame:CGRectZero];
	customPickerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	customPickerView.showsSelectionIndicator = YES;
	[v addSubview:customPickerView];
	
	CGRect mainViewBounds = [UIScreen mainScreen].bounds;
	UIToolbar *buttonBar = [UIToolbar new];
	buttonBar.barStyle = UIBarStyleBlackOpaque;
	[buttonBar sizeToFit];
	CGFloat buttonBarHeight = [buttonBar frame].size.height;
	[buttonBar setFrame:CGRectMake(CGRectGetMinX(mainViewBounds),
								   CGRectGetMinY(mainViewBounds) + CGRectGetHeight(mainViewBounds) - (buttonBarHeight * 2.0) + 2.0 + 22.0f,
								   CGRectGetWidth(mainViewBounds),
								   buttonBarHeight)];
	[v addSubview:buttonBar];
	
	
	UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" 
																   style:UIBarButtonItemStyleDone 
																  target:self 
																  action:@selector(doneButtonTouch:)];
	UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
																				  target:self 
																				  action:@selector(cancelButtonTouch:)];
	NSArray *buttonItems = [NSArray arrayWithObjects:doneButton, cancelButton, nil];
	[buttonBar setItems:buttonItems animated:NO];
	
	[doneButton release];
	[cancelButton release];
	
	self.view = v;
}


- (void)doneButtonTouch:(id)sender
{
	// Save the tile info
	// Get the selected value and set the piece view type
	if (self.tileView.tile.piece == nil)
	{
		Piece *p = [[Piece alloc] initWithType:self.customPickerView.pieceType];
		p.position = self.tileView.tile.position;
		self.tileView.tile.piece = p;
	} 
	else 
	{
		self.tileView.tile.piece.type = self.customPickerView.pieceType;
	}
	[self.tileView setNeedsDisplay];
	//self.tileView.backgroundColor = [UIColor redColor];
	
	[[LevelEditor getNavigationController] dismissModalViewControllerAnimated:YES];
}


- (void)cancelButtonTouch:(id)sender
{
	[[LevelEditor getNavigationController] dismissModalViewControllerAnimated:YES];
}

@end
