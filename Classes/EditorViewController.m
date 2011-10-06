//
//  TestViewController.m
//  ARTest
//
//  Created by david on 18/12/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import "ARTestAppDelegate.h"
#import "EditorViewController.h"
#import "LevelsViewController.h"

@implementation EditorViewController
@synthesize editButtons;

- init
{
	if ((self = [super initWithStyle:UITableViewStyleGrouped]) != nil)
	{
		//self.navigationController.navigationBar.barStyle = UIBarStyleBlackOpaque;
		self.title = @"Level Groups";
		
		toolbar = [UIToolbar new];
		toolbar.barStyle = UIBarStyleBlackOpaque;
		
		// size up the toolbar and set its frame
		[toolbar sizeToFit];
		CGFloat toolbarHeight = [toolbar frame].size.height;
		CGRect mainViewBounds = self.view.bounds;
		[toolbar setFrame:CGRectMake(CGRectGetMinX(mainViewBounds),
									 CGRectGetMinY(mainViewBounds) + CGRectGetHeight(mainViewBounds) - (toolbarHeight * 2.0) + 2.0,
									 CGRectGetWidth(mainViewBounds),
									 toolbarHeight)];
		
		[self.view addSubview:toolbar];
		
		UIBarButtonItem *addLevelGroupButton = [[UIBarButtonItem alloc] initWithTitle:@"+ Add Level Group" style:UIBarButtonItemStyleBordered target:self action:@selector(addLevelGroupButtonTouch:)];
		
		UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Save Changes" 
																	   style:UIBarButtonItemStyleDone 
																	  target:self 
																	  action:@selector(doneButtonTouch:)];
		
		NSArray *items = [NSArray arrayWithObjects:doneButton, addLevelGroupButton, nil];
		[toolbar setItems:items animated:NO];
		[addLevelGroupButton release];
		[doneButton release];

		
		/*
		UIView *buttonContainer = [[UIView alloc] initWithFrame:CGRectMake(5.0f, 20.0f, 120.0f, 40.0f)];
		UIImage *buttonBackground = [UIImage imageNamed:@"whiteButton.png"];
		UIImage *buttonBackgroundPressed = [UIImage imageNamed:@"blueButton.png"];
		
		CGRect frame = CGRectMake(80.0, 0.0, 34.0f, 34.0f);
		UIButton *addLevelGroupButton = [ARTestAppDelegate buttonWithTitle:@"+"
													  target:self
													selector:@selector(addLevelGroupButtonTouch:)
													   frame:frame
													   image:buttonBackground
												imagePressed:buttonBackgroundPressed
											   darkTextColor:YES];
		[buttonContainer addSubview:addLevelGroupButton];
		
		frame = CGRectMake(0.0, 0.0, 80.0f, 34.0f);
		
		UIButton *editLevelGroupsButton = [ARTestAppDelegate buttonWithTitle:@"Edit"
																		target:self
																	  selector:@selector(editLevelGroupButtonTouch:)
																		 frame:frame
																		 image:buttonBackground
																  imagePressed:buttonBackgroundPressed
																 darkTextColor:NO];	
		[buttonContainer addSubview:editLevelGroupsButton];
	
		self.editButtons = [[UIBarButtonItem alloc] initWithCustomView:buttonContainer];
		
		[addLevelGroupButton release];
		[buttonContainer release];
		 */
	}
	return self;
}


- (void)dealloc
{
	[self.editButtons release];
	[super dealloc];
}


- (void)loadView
{
	[super loadView];
}


- (void)addLevelGroupButtonTouch:(id)sender
{
	Levelgroup * group = [Levelgroup LevelgroupMake:@""];
	[LevelgroupEditor setCurrentLevelgroup:group];
	[LevelgroupEditor ReloadViews];	
	[[self navigationController] pushViewController:[LevelgroupEditor getLevelgroupViewController] animated:YES];
}


- (void)doneButtonTouch:(id)sender
{
	[Levelgroup SaveLevelGroups];
	[self.navigationController dismissModalViewControllerAnimated:YES];
}


- (void)cancelButtonClick:(id)sender
{
	[self.navigationController dismissModalViewControllerAnimated:YES];
}


- (void)reloadLevelGroups
{
	self.title = [NSString stringWithFormat:@"Level Groups (%d)", [Levelgroup GetLevelGroups].count];
}


// Update the table before the view displays.
- (void)viewWillAppear:(BOOL)animated 
{
	[self reloadLevelGroups];
	
	[self.navigationItem setRightBarButtonItem:self.editButtonItem];
    
	// Back button - closes the dialog
	UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelButtonClick:)];
	[self.navigationItem setLeftBarButtonItem:backButton animated:NO];
	[backButton release];
	
	[self.tableView reloadData];
}


-(NSInteger)numberOfSectionsInTableView:(UITableView*)tableView
{
	return 1;
}


- (NSInteger)tableView:(UITableView *)tv numberOfRowsInSection:(NSInteger)section 
{
    return [Levelgroup GetLevelGroups].count;
}


- (UITableViewCell *)tableView:(UITableView *)tv cellForRowAtIndexPath:(NSIndexPath *)indexPath 
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"EditorViewIdentifier"];
    if (cell == nil) 
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"EditorViewIdentifier"] autorelease];
    }
    Levelgroup *group = [[Levelgroup GetLevelGroups] objectAtIndex:indexPath.row];
    cell.textLabel.text = group.name;
    return cell;
}


- (NSIndexPath *)tableView:(UITableView *)tv willSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    Levelgroup *group = [[Levelgroup GetLevelGroups] objectAtIndex:indexPath.row];

	[LevelgroupEditor setCurrentLevelgroup:group];
	[LevelgroupEditor ReloadViews];
	
	[[self navigationController] pushViewController:[LevelgroupEditor getLevelgroupViewController] animated:YES];
    
	return nil;
}


- (void)tableView:(UITableView *)tv commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if (editingStyle == UITableViewCellEditingStyleDelete) 
    {
        Levelgroup *group = [[Levelgroup GetLevelGroups] objectAtIndex:indexPath.row];
		[[Levelgroup GetLevelGroups] removeObject:group];
		
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
		
		[self reloadLevelGroups];
    }
}


+ (UITextField *)createNumericField
{
	CGRect frame = CGRectMake(0.0, 0.0, kTextFieldWidth, kTextFieldHeight);
	UITextField *returnTextField = [[UITextField alloc] initWithFrame:frame];
    
	returnTextField.borderStyle = UITextBorderStyleRoundedRect;
    returnTextField.textColor = [UIColor blackColor];
	returnTextField.font = [UIFont systemFontOfSize:17.0];
    returnTextField.placeholder = @"<enter text>";
    returnTextField.backgroundColor = [UIColor whiteColor];
	
	returnTextField.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
	returnTextField.returnKeyType = UIReturnKeyDone;
	
	returnTextField.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
	
	return returnTextField;
}


+ (UITextField *)createTextField
{
	return [EditorViewController createTextField:1];
}


+ (UITextField *)createTextField:(int)rows
{
	CGRect frame = CGRectMake(0.0, 0.0, kTextFieldWidth, rows * kTextFieldHeight);
	UITextField *returnTextField = [[UITextField alloc] initWithFrame:frame];
    
	returnTextField.borderStyle = UITextBorderStyleRoundedRect;
    returnTextField.textColor = [UIColor blackColor];
	returnTextField.font = [UIFont systemFontOfSize:17.0];
    returnTextField.placeholder = @"<enter text>";
    returnTextField.backgroundColor = [UIColor whiteColor];
	
	returnTextField.keyboardType = UIKeyboardTypeAlphabet;
	returnTextField.returnKeyType = UIReturnKeyDone;
	
	returnTextField.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
	
	return returnTextField;
}

@end
