/*
 *  LevelEditor.h
 *  ARTest
 *
 *  Created by david on 21/12/08.
 *  Copyright 2008 n/a. All rights reserved.
 *
 */

#import <UIKit/UIKit.h>
#import "MapViewController.h"
#import "SettingsViewController.h"
#import "QueueViewController.h"
#import "GoalsViewController.h"
#import "BonusesViewController.h"
#import "TutorialsViewController.h"

#import "TileEditorViewController.h"
#import "GameClasses.h"

@interface LevelEditor : NSObject
{
}
+ (void)showTileEditorDialog:(MapTileView *)tv;
+ (UINavigationController *)getNavigationController;
+ (Level *)getCurrentLevel;
+ (void)setCurrentLevel:(Level *)level;

+ (Levelgroup *)getCurrentLevelgroup;
+ (void)setCurrentLevelgroup:(Levelgroup *)levelgroup;

@end
