//
//  TestViewController.h
//  ARTest
//
//  Created by david on 18/12/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LevelsViewController.h"
#import "LevelgroupEditor.h"
#import "GameClasses.h"

@interface EditorViewController : UITableViewController {
	UIToolbar				*toolbar;
	
	IBOutlet UIBarButtonItem *editButtons;
}
@property(readwrite, retain) UIBarButtonItem *editButtons;
- (void)reloadLevelGroups;

+ (UITextField *)createNumericField;
+ (UITextField *)createTextField;
+ (UITextField *)createTextField:(int)rows;
@end
