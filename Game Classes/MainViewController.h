//
//  MainViewController.h
//
// I'm attempting to make the main view a controller
// that displays quartz objects in a quartz view. 
//
//  Created by david on 19/11/08.
//  Copyright n/a 2008. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditorViewController.h"
#import "GameViewController.h"

@interface MainViewController : UIViewController
{
	IBOutlet GameViewController *gameViewController;
	IBOutlet EditorViewController *editorViewController;
	IBOutlet UIView* chooseGameMenuView;
	IBOutlet UINavigationController *editorNavigationController;
}

@property (nonatomic, retain) UINavigationController *editorNavigationController;
@property (nonatomic, retain) GameViewController *gameViewController;
@property (nonatomic, retain) EditorViewController *editorViewController;
@property (nonatomic, retain) UIView *chooseGameMenuView;

+ (MainViewController *)sharedInstance;
+ (GameAreaView *)GetGameAreaView;


@end