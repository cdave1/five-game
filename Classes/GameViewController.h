//
//  GameViewController.h
//  ARTest
//
//  Created by david on 23/12/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameAreaView.h"
#import "BackgroundView.h"
#import "GameBottomMenuView.h"
#import "InGameMenuView.h"

@interface GameViewController : UIViewController {
	UIView *mainView;
	IBOutlet InGameMenuView *inGameMenuView;
	UIView *gameTopMenuView;
	IBOutlet GameAreaView *gameAreaView;
	IBOutlet UIImageView *backgroundView;
	IBOutlet GameBottomMenuView *gameBottomMenuView;
	UILabel *lblPoints;
}

- (void)SetupViewsForGame;
- (void)DestroyViews;
- (void)SetPoints:(NSInteger)points;

@property(retain) InGameMenuView *inGameMenuView;
@property(retain) GameAreaView *gameAreaView;
@property(retain) GameBottomMenuView *gameBottomMenuView;
@property(retain) UIView *lblPoints;



@end
