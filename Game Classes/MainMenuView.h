//
//  MainMenuView.h
//  QuartzFeedback
//
//  Created by david on 10/12/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChooseGameMenuView.h"


@interface MainMenuView : UIView {
	IBOutlet ChooseGameMenuView *chooseGameMenuView;
}

@property(retain) ChooseGameMenuView* chooseGameMenuView;

@end
