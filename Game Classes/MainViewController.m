//
//  ViewController.m
//  
//
//  Created by david on 19/11/08.
//  Copyright n/a 2008. All rights reserved.
//

#import "MainViewController.h"

static MainViewController *sharedInstance;

@implementation MainViewController

@synthesize gameViewController, editorViewController, chooseGameMenuView;
@synthesize editorNavigationController;

- (void)loadView
{
	UIView *mainView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	mainView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	self.view = mainView;
	
	self.gameViewController = [[GameViewController alloc] init];
	self.editorViewController = [[EditorViewController alloc] init];
	self.editorNavigationController = [[UINavigationController alloc] initWithRootViewController:editorViewController];
	self.editorNavigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;

	UIButton *btnNewGame = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	btnNewGame.frame = CGRectMake(60.0f, 100.0f, 200.0f, 60.0f);
	[btnNewGame setTitle:@"New Game" forState:UIControlStateNormal];
	[btnNewGame addTarget:self action:@selector(btnNewGameTouchInside:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:btnNewGame];
	
	UIButton *btnEditor = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	btnEditor.frame = CGRectMake(60.0f, 180.0f, 200.0f, 60.0f);
	[btnEditor setTitle:@"Game Editor" forState:UIControlStateNormal];
	[btnEditor addTarget:self action:@selector(btnEditorTouchInside:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:btnEditor];
	
	UIButton *btnQuit = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	btnQuit.frame = CGRectMake(60.0f, 260.0f, 200.0f, 60.0f);
	[btnQuit setTitle:@"Quit" forState:UIControlStateNormal];
	[btnQuit addTarget:self action:@selector(btnQuitTouchInside:) forControlEvents:UIControlEventTouchUpInside];
	[self.view addSubview:btnQuit];
	
	self.chooseGameMenuView = [[UIView alloc] initWithFrame:CGRectMake(40.0f, 80.0f, 240.0f, 340.0f)];
	self.chooseGameMenuView.alpha = 0.8;
	self.chooseGameMenuView.backgroundColor = [UIColor blackColor];
	self.chooseGameMenuView.hidden = YES;
	
	UIButton *btnStandardGame = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	btnStandardGame.frame = CGRectMake(5.0f, 5.0f, 120.0f, 30.0f);
	[btnStandardGame setTitle:@"Standard Game" forState:UIControlStateNormal];
	[btnStandardGame addTarget:self action:@selector(btnStandardGameTouchInside:) forControlEvents:UIControlEventTouchUpInside];
	[self.chooseGameMenuView addSubview:btnStandardGame];
	
	UIButton *btnLevelGame = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	btnLevelGame.frame = CGRectMake(5.0f, 40.0f, 120.0f, 30.0f);
	[btnLevelGame setTitle:@"Level Game" forState:UIControlStateNormal];
	[btnLevelGame addTarget:self action:@selector(btnLevelGameTouchInside:) forControlEvents:UIControlEventTouchUpInside];
	[self.chooseGameMenuView addSubview:btnLevelGame];
	
	UIButton *btnCancel = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
	btnCancel.frame = CGRectMake(5.0f, 80.0f, 120.0f, 30.0f);
	[btnCancel setTitle:@"Cancel" forState:UIControlStateNormal];
	[btnCancel addTarget:self action:@selector(btnCancelGameTouchInside:) forControlEvents:UIControlEventTouchUpInside];
	[self.chooseGameMenuView addSubview:btnCancel];
	
	[self.view addSubview:self.chooseGameMenuView];
}


- (void)btnNewGameTouchInside:(id)sender
{
	[Levelgroup ReloadLevelGroups];
	self.chooseGameMenuView.hidden = NO;
	[self.chooseGameMenuView setNeedsDisplay];
	[self.view bringSubviewToFront:self.chooseGameMenuView];
}


- (void)btnEditorTouchInside:(id)sender
{
	[Levelgroup ReloadLevelGroups];
	[self presentModalViewController:self.editorNavigationController animated:YES];
}


- (void)btnQuitTouchInside:(id)sender
{
}


- (void)btnStandardGameTouchInside:(id)sender
{
	[self.gameViewController DestroyViews];
	[GameController Initialize:StandardGameType];
	[self.gameViewController SetupViewsForGame];
	[GameController LoadGameState];
	
	// simply need to push the game view controller on to the navigation stack...
	[self presentModalViewController:self.gameViewController animated:YES];
	self.chooseGameMenuView.hidden = YES;
}


- (void)btnLevelGameTouchInside:(id)sender
{
	[self.gameViewController DestroyViews];
	[GameController Initialize:LevelledGameType];
	[self.gameViewController SetupViewsForGame];
	[GameController LoadGameState];
	[self presentModalViewController:self.gameViewController animated:YES];
	self.chooseGameMenuView.hidden = YES;
}


- (void)btnCancelGameTouchInside:(id)sender
{
	self.chooseGameMenuView.hidden = YES;
}


+ (MainViewController *)sharedInstance
{
	if (sharedInstance == nil)
	{
		sharedInstance = [[MainViewController alloc] init];
	}
	return sharedInstance;
}


+ (GameAreaView *)GetGameAreaView
{
	return [MainViewController sharedInstance].gameViewController.gameAreaView;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation 
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)didReceiveMemoryWarning 
{
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}


- (void)dealloc 
{
	[gameViewController release];
	[editorViewController release];
	[chooseGameMenuView release];
    [super dealloc];
}

@end
