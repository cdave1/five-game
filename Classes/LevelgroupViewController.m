//
//  DetailsViewController.m
//  ARTest
//
//  Created by david on 21/12/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import "LevelgroupViewController.h"
#import "EditorViewController.h"
#import "LevelEditor.h"
#import "Constants.h"
#import "CellTextField.h"
#import "SourceCell.h"


// the amount of vertical shift upwards keep the text field in view as the keyboard appears
#define kOFFSET_FOR_KEYBOARD					150.0

// the duration of the animation for the view shift
#define kVerticalOffsetAnimationDuration		0.30

#define kTxtName					0
#define kTxtDescription					1
#define kTxtBonusItem					2


// Private interface for TextFieldController - internal only methods.
@interface LevelgroupViewController (Private)
- (void)setViewMovedUp:(BOOL)movedUp;
@end


@implementation LevelgroupViewController

@synthesize myTableView;

- init
{
	if ((self = [super initWithNibName:nil bundle:nil]) != nil)
	{
		if ([LevelgroupEditor getCurrentLevelgroup] == nil || [[LevelgroupEditor getCurrentLevelgroup].name length]== 0) {
			self.title = @"Add level group";
		} 
		else 
		{
			self.title = [LevelgroupEditor getCurrentLevelgroup].name;
		}
	}
	return self;
}


- (void)dealloc
{
	[myTableView release];
	[txtName release];
	[txtDescription release];
	[txtBonusItem release];
	
	[super dealloc];
}


#pragma mark - UIViewController delegate methods

- (void)viewWillAppear:(BOOL)animated
{
	//[self reloadLevelGroups];
	
	
	
    // watch the keyboard so we can adjust the user interface if necessary.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) 
												 name:UIKeyboardWillShowNotification object:self.view.window]; 
}


- (void)viewWillDisappear:(BOOL)animated
{
    //[self setEditing:NO animated:YES];
	
    // unregister for keyboard notifications while not visible.
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil]; 
}


- (void)loadView
{
	UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	contentView.backgroundColor = [UIColor whiteColor];
	contentView.autoresizesSubviews = YES;
	self.view = contentView;
	[contentView release];
	
	CGRect bounds;
	
	if ([LevelgroupEditor getCurrentLevelgroup] == nil || [[LevelgroupEditor getCurrentLevelgroup].name length]== 0) 
    {
		self.title = @"Add level group";
		bounds = CGRectMake(0.0f, 0.0f, 320.0f, 438.0f);
	} 
	else 
	{
		self.title = [LevelgroupEditor getCurrentLevelgroup].name;
		
		// Create the level editor box
		UIButton *btnEditLevels = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		btnEditLevels.frame = CGRectMake(5.0f, 10.0f, 120.0f, 18.0f);
		[btnEditLevels setTitle:@"Levels" forState:UIControlStateNormal];
		[btnEditLevels addTarget:self action:@selector(btnEditLevelsTouch:) forControlEvents:UIControlEventTouchUpInside];
		[self.view addSubview:btnEditLevels];
		
		bounds = CGRectMake(0.0f, 44.0f, 320.0f, 438.0f);
	}
	
	// create and configure the table view
	myTableView = [[UITableView alloc] initWithFrame:bounds style:UITableViewStyleGrouped];	
	myTableView.delegate = self;
	myTableView.dataSource = self;
	myTableView.scrollEnabled = NO;	// no scrolling in this case, we don't want to interfere with touch events on edit fields
	[self.view addSubview: myTableView];
	
	// create our text fields to be recycled when UITableViewCells are created
	txtName = [EditorViewController createTextField];	
	txtName.text = [LevelgroupEditor getCurrentLevelgroup].name; //[[NSNumber numberWithInt:[LevelEditor getCurrentLevel].minlinesize] stringValue];
	txtDescription = [EditorViewController createNumericField];
	txtDescription.text = [LevelgroupEditor getCurrentLevelgroup].description;  //[[NSNumber numberWithInt:[LevelEditor getCurrentLevel].moveslimit] stringValue];
	txtBonusItem = [EditorViewController createNumericField];
	txtBonusItem.text = @"0"; //[[NSNumber numberWithInt:[LevelEditor getCurrentLevel].pointslimit] stringValue];
}


- (void)btnEditLevelsTouch:(id)sender
{	
	//LevelsViewController *controller = levelsViewController;
	//[LevelgroupEditor ReloadViews];
	//[self presentModalViewController:[LevelgroupEditor getNavigationController] animated:YES];
	//[[LevelgroupEditor getNavigationController] loadView];
    [[self navigationController] pushViewController:[LevelgroupEditor getLevelsViewController] animated:YES];
    
	
    //[controller setEditing:NO animated:NO];
}


// if you want the entire table to just be re-orderable then just return UITableViewCellEditingStyleNone
//
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return UITableViewCellEditingStyleNone;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 3;
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
	NSString *title;
	switch (section)
	{
		case kTxtName:
		{
			title = @"Name";
			break;
		}
		case kTxtDescription:
		{
			title = @"Description";
			break;
		}
		case kTxtBonusItem:
		{
			title = @"Bonus Item";
			break;
		}
	}
	return title;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 2;
}


// to determine specific row height for each cell, override this.  In this example, each row is determined
// buy the its subviews that are embedded.
//
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	CGFloat result;
	
	switch ([indexPath row])
	{
		case 0:
		{
			result = kUIRowHeight;
			break;
		}
		case 1:
		{
			result = kUIRowLabelHeight;
			break;
		}
	}
	
	return result;
}


// utility routine leveraged by 'cellForRowAtIndexPath' to determine which UITableViewCell to be used on a given row
//
- (UITableViewCell *)obtainTableCellForRow:(NSInteger)row
{
	UITableViewCell *cell = nil;
	
	if (row == 0)
		cell = [myTableView dequeueReusableCellWithIdentifier:kCellTextField_ID];
	else if (row == 1)
		cell = [myTableView dequeueReusableCellWithIdentifier:kSourceCell_ID];
	
	if (cell == nil)
	{
		if (row == 0)
		{
			cell = [[[CellTextField alloc] initWithFrame:CGRectZero reuseIdentifier:kCellTextField_ID] autorelease];
			((CellTextField *)cell).delegate = self;	// so we can detect when cell editing starts
		}
		else if (row == 1)
		{
			cell = [[[SourceCell alloc] initWithFrame:CGRectZero reuseIdentifier:kSourceCell_ID] autorelease];
		}
	}
	
	return cell;
}


// to determine which UITableViewCell to be used on a given row.
//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger row = [indexPath row];
	UITableViewCell *sourceCell = [self obtainTableCellForRow:row];
	
	switch (indexPath.section)
	{
		case kTxtName:
		{
			if (row == 0)
			{
				// this cell hosts the text field control
				((CellTextField *)sourceCell).view = txtName;
                txtNameCell = (CellTextField *)sourceCell;	// kept track for editing
			}
			else
			{	
				// this cell hosts the info on where to find the code
				((SourceCell *)sourceCell).sourceLabel.text = @"Name of level group";
			}
			
			break;
		}
			
		case kTxtDescription:
		{
			if (row == 0)
			{
				// this cell hosts the rounded text field control
				((CellTextField *)sourceCell).view = txtDescription;
                txtDescriptionCell = (CellTextField *)sourceCell;	// kept track for editing
			}
			else
			{
				// this cell hosts the info on where to find the code
				((SourceCell *)sourceCell).sourceLabel.text = @"Short description that will appear on save games";
			}
			
			break;	
		}
			
		case kTxtBonusItem:
		{
			// we are creating a new cell, setup its attributes
			if (row == 0)
			{
				// this cell hosts the secure text field control
				((CellTextField *)sourceCell).view = txtBonusItem;
                txtBonusItemCell = (CellTextField *)sourceCell;	// kept track for editing
			}
			else
			{
				// this cell hosts the info on where to find the code
				((SourceCell *)sourceCell).sourceLabel.text = @"Special bonus when player completes level goals";
			}
			
			break;
		}
	}
	
    return sourceCell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 37.0;
}


#pragma mark -
#pragma mark <EditableTableViewCellDelegate> Methods and editing management

- (BOOL)cellShouldBeginEditing:(EditableTableViewCell *)cell
{
    // notify other cells to end editing
    if (![cell isEqual:txtNameCell])
		[cell stopEditing];
    if (![cell isEqual:txtDescriptionCell])
		[cell stopEditing];
    if (![cell isEqual:txtBonusItemCell])
		[cell stopEditing];
	
    return self.editing;
}

- (void)cellDidEndEditing:(EditableTableViewCell *)cell
{
	//NSScanner *scanner 
	//int val = 0;
	
	if (cell == txtNameCell) 
	{
		//[[NSScanner scannerWithString:txtName.text] scanInt:&val];
		[LevelgroupEditor getCurrentLevelgroup].name = txtName.text;
	} 
	else if (cell == txtDescriptionCell)
	{
		//[[NSScanner scannerWithString:txtDescription.text] scanInt:&val];
		[LevelgroupEditor getCurrentLevelgroup].description = txtDescription.text;
	} 
	else if (cell == txtBonusItemCell) 
	{
		//[[NSScanner scannerWithString:txtBonusItem.text] scanInt:&val];
		//[LevelEditor getCurrentLevel].pointslimit = val;
	}
	
	
	if ([cell isEqual:txtDescriptionCell] || [cell isEqual:txtBonusItemCell])
	{
        // Restore the position of the main view if it was animated to make room for the keyboard.
        if  (self.view.frame.origin.y < 0)
		{
            [self setViewMovedUp:NO];
        }
    }
}

// Animate the entire view up or down, to prevent the keyboard from covering the author field.
- (void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    // Make changes to the view's frame inside the animation block. They will be animated instead
    // of taking place immediately.
    CGRect rect = self.view.frame;
    if (movedUp)
	{
        // If moving up, not only decrease the origin but increase the height so the view 
        // covers the entire screen behind the keyboard.
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
	else
	{
        // If moving down, not only increase the origin but decrease the height.
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if (!editing)
	{
        [txtNameCell stopEditing];
        [txtDescriptionCell stopEditing];
        [txtBonusItemCell stopEditing];
    }
}

- (void)keyboardWillShow:(NSNotification *)notif
{
    // The keyboard will be shown. If the user is editing the author, adjust the display so that the
    // author field will not be covered by the keyboard.
   /* if ((txtDescriptionCell.isInlineEditing || 
		 txtBonusItemCell.isInlineEditing) && 
		self.view.frame.origin.y >= 0)
	{
        [self setViewMovedUp:YES];
    }
	else if (!txtBonusItemCell.isInlineEditing && self.view.frame.origin.y < 0)
	{
        [self setViewMovedUp:NO];
    }*/
}


@end
