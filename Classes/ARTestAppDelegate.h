//
//  ARTestAppDelegate.h
//  ARTest
//
//  Created by david on 13/12/08.
//  Copyright n/a 2008. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "EditorViewController.h"


@class ARTestViewController;

@interface ARTestAppDelegate : NSObject <UIApplicationDelegate> {
	IBOutlet UIWindow *window;
	IBOutlet EditorViewController *editorViewController;
	IBOutlet UINavigationController *navigationController;
}

@property (nonatomic, retain) EditorViewController *editorViewController;


@property (nonatomic, retain) UINavigationController *navigationController;
@property (nonatomic, retain) UIWindow *window;


@end

