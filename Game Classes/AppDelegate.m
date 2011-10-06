//
//  AppDelegate.m
//
//  Created by david on 19/11/08.
//  Copyright n/a 2008. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "GameController.h"

@implementation AppDelegate

@synthesize window;
@synthesize viewController;



+ (UIButton *)buttonWithTitle:	(NSString *)title
					   target:(id)target
					 selector:(SEL)selector
						frame:(CGRect)frame
						image:(UIImage *)image
				 imagePressed:(UIImage *)imagePressed
				darkTextColor:(BOOL)darkTextColor
{	
	UIButton *button = [[UIButton alloc] initWithFrame:frame];
	
	button.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
	button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
	
	[button setTitle:title forState:UIControlStateNormal];
    
	if (darkTextColor)
	{
		[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
	}
	else
	{
		[button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
	}
	
	UIImage *newImage = [image stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:newImage forState:UIControlStateNormal];
	
	UIImage *newPressedImage = [imagePressed stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0];
	[button setBackgroundImage:newPressedImage forState:UIControlStateHighlighted];
	
	[button addTarget:target action:selector forControlEvents:UIControlEventTouchUpInside];
	
	button.backgroundColor = [UIColor clearColor];
	
	return button;
}


- (void)applicationDidFinishLaunching:(UIApplication *)application 
{  
	application.statusBarHidden = YES;
    
    self.viewController = [MainViewController sharedInstance];
	[self.viewController loadView];
    [window addSubview:self.viewController.view];
    [window makeKeyAndVisible];
}


- (void)dealloc 
{
    [viewController release];
    [window release];
    [super dealloc];
}


@end
