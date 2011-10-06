//
//  LevelgroupEditor.h
//  ARTest
//
//  Created by david on 21/12/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameClasses.h"
#import "LevelsViewController.h"
#import "LevelgroupViewController.h"

@interface LevelgroupEditor : UINavigationController {

}
+ (UINavigationController *)getNavigationController;
+ (LevelsViewController *)getLevelsViewController;
+ (LevelgroupViewController *)getLevelgroupViewController;

+ (void)ReloadViews;
+ (Levelgroup *)getCurrentLevelgroup;
+ (void)setCurrentLevelgroup:(Levelgroup *)levelgroup;



@end
