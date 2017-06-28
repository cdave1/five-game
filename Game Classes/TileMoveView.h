//
//  TileMoveAnimatorDelegate.h
//  QuartzFeedback
//
//  Created by david on 4/12/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "Tile.h"
#import "StateChange.h"

@interface TileMoveViewAnimationDelegate : NSObject
{
	id<StateChange> stateChange;
	UIView* gameAreaView;
	UIView* animView;
}
@property(retain) UIView* gameAreaView;
@property(retain) UIView* animView;
@property(retain) id<StateChange> stateChange;
@end


@interface TileMoveView : UIView 
{
	NSInteger tileIndex;
	Piece* piece;
	UIView* gameAreaView;
}

@property(readwrite) NSInteger tileIndex;
@property(retain) Piece* piece;
@property(retain) UIView* gameAreaView;

-(id)initWithSuperView:(UIView *)superView;

@end
