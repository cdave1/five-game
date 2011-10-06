//
//  ARTestAppDelegate.m
//  ARTest
//
//  Created by david on 13/12/08.
//  Copyright n/a 2008. All rights reserved.
//

#import "ARTestAppDelegate.h"
#import "ActiveRecord.h"

@implementation ARTestAppDelegate

@synthesize window;
@synthesize navigationController;
@synthesize masterViewController;


+ (UIButton *)buttonWithTitle:	(NSString *)title
					   target:(id)target
					 selector:(SEL)selector
						frame:(CGRect)frame
						image:(UIImage *)image
				 imagePressed:(UIImage *)imagePressed
				darkTextColor:(BOOL)darkTextColor
{	
	UIButton *button = [[UIButton alloc] initWithFrame:frame];
	// or you can do this:
	//		UIButton *button = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	//		button.frame = frame;
	
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
	
    // in case the parent view draws with a custom color or gradient, use a transparent color
	button.backgroundColor = [UIColor clearColor];
	
	return button;
}


- (void)applicationDidFinishLaunching:(UIApplication *)application {	
	[self createEditableCopyOfDatabaseIfNeeded];
	[self initDatabase];
	
	masterViewController = [[[MasterViewController alloc] initWithNibName:nil bundle:nil] autorelease];
	
	
	
	navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
	//[navigationController pushViewController:levelGroupsViewController animated:NO];

	[window addSubview:navigationController.view];
    //[window addSubview:[LevelEditor getTabBarController].view];
	[window makeKeyAndVisible];
}



- (void)initDatabase
{
	NSMutableDictionary *dbServerInfo = [[NSMutableDictionary alloc] init];
	//NSString* resourcePath = [[NSBundle mainBundle] pathForResource:@"db" ofType:@"sqllite"];
	
	NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:@"db.sqllite"];
	
	[dbServerInfo setObject:path forKey:@"path"];
	NSError *error;
	ARSQLiteConnection *connection = [ARSQLiteConnection openConnectionWithInfo:dbServerInfo error:&error];
	[ARBase setDefaultConnection:connection];
	[dbServerInfo release];
}



// Creates a writable copy of the bundled default database in the application Documents directory.
- (void)createEditableCopyOfDatabaseIfNeeded {
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:@"db.sqllite"];
    success = [fileManager fileExistsAtPath:writableDBPath];
    if (success) return;
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"db.sqllite"];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
}


- (void)dealloc {
	[window release];
	[super dealloc];
}


@end
