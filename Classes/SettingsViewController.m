//
//  SettingsViewController.m
//  ARTest
//
//  Created by david on 12/01/09.
//  Copyright 2009 n/a. All rights reserved.
//

#import "SettingsViewController.h"
#import "Constants.h"
#import "CellTextField.h"
#import "SourceCell.h"
#import "LevelEditor.h"
#import "EditorViewController.h"

// the amount of vertical shift upwards keep the text field in view as the keyboard appears
#define kOFFSET_FOR_KEYBOARD					150.0



// the duration of the animation for the view shift
#define kVerticalOffsetAnimationDuration		0.30

#define kTxtMinLineSize					0
#define kTxtMovesLimit					1
#define kTxtPointsLimit					2

// Private interface for TextFieldController - internal only methods.
@interface SettingsViewController (Private)
- (void)setViewMovedUp:(BOOL)movedUp;
@end


@implementation SettingsViewController

@synthesize myTableView;

- init
{
	if ((self = [super initWithNibName:nil bundle:nil]) != nil)
	{
		self.title = @"Goals";
		self.navigationItem.hidesBackButton = YES;
	}
	return self;
}

- (void)dealloc
{
	[myTableView release];
	[txtMinLineSize release];
	[txtMovesLimit release];
	[txtPointsLimit release];
	
	[super dealloc];
}


- (void)loadView
{
	// setup our parent content view and embed it to your view controller
	UIView *contentView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	contentView.backgroundColor = [UIColor whiteColor];
	contentView.autoresizesSubviews = YES;
	self.view = contentView;
	[contentView release];
	
	// create and configure the table view
	CGRect bounds = CGRectMake(0.0f, 44.0f, 320.0f, 438.0f);
	myTableView = [[UITableView alloc] initWithFrame:bounds style:UITableViewStyleGrouped];	
	myTableView.delegate = self;
	myTableView.dataSource = self;
	
	myTableView.scrollEnabled = NO;	// no scrolling in this case, we don't want to interfere with touch events on edit fields
	[self.view addSubview: myTableView];
	
	// create our text fields to be recycled when UITableViewCells are created
	txtMinLineSize = [EditorViewController createNumericField];	
	txtMinLineSize.text = [[NSNumber numberWithInt:[LevelEditor getCurrentLevel].minlinesize] stringValue];
	txtMovesLimit = [EditorViewController createNumericField];
	txtMovesLimit.text = [[NSNumber numberWithInt:[LevelEditor getCurrentLevel].moveslimit] stringValue];
	txtPointsLimit = [EditorViewController createNumericField];
	txtPointsLimit.text = [[NSNumber numberWithInt:[LevelEditor getCurrentLevel].pointslimit] stringValue];
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
		case kTxtMinLineSize:
		{
			title = @"Minimum Winning Line Count";
			break;
		}
		case kTxtMovesLimit:
		{
			title = @"Maximum Moves to Complete";
			break;
		}
		case kTxtPointsLimit:
		{
			title = @"Points required to complete";
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
		case kTxtMinLineSize:
		{
			if (row == 0)
			{
				// this cell hosts the text field control
				((CellTextField *)sourceCell).view = txtMinLineSize;
			}
			else
			{	
				// this cell hosts the info on where to find the code
				((SourceCell *)sourceCell).sourceLabel.text = @"Minimum number of items in a line to complete it";
			}
			txtMinLineSizeCell = (CellTextField *)sourceCell;	// kept track for editing
			break;
		}
			
		case kTxtMovesLimit:
		{
			if (row == 0)
			{
				// this cell hosts the rounded text field control
				((CellTextField *)sourceCell).view = txtMovesLimit;
			}
			else
			{
				// this cell hosts the info on where to find the code
				((SourceCell *)sourceCell).sourceLabel.text = @"Number of moves allowed to complete the level";
			}
			txtMovesLimitCell = (CellTextField *)sourceCell;	// kept track for editing
			break;	
		}
			
		case kTxtPointsLimit:
		{
			// we are creating a new cell, setup its attributes
			if (row == 0)
			{
				// this cell hosts the secure text field control
				((CellTextField *)sourceCell).view = txtPointsLimit;
			}
			else
			{
				// this cell hosts the info on where to find the code
				((SourceCell *)sourceCell).sourceLabel.text = @"Points required before the level is done";
			}
			txtPointsLimitCell = (CellTextField *)sourceCell;	// kept track for editing
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
    if (![cell isEqual:txtMinLineSizeCell])
		[txtMinLineSizeCell stopEditing];
    if (![cell isEqual:txtMovesLimitCell])
		[txtMovesLimitCell stopEditing];
    if (![cell isEqual:txtPointsLimitCell])
		[txtPointsLimitCell stopEditing];
	
    return self.editing;
}

- (void)cellDidEndEditing:(EditableTableViewCell *)cell
{
	//NSScanner *scanner 
	int val = 0;
	
	if ([cell isEqual:txtMinLineSizeCell]) 
	{
		[[NSScanner scannerWithString:txtMinLineSize.text] scanInt:&val];
		[LevelEditor getCurrentLevel].minlinesize = val;
	} 
	else if ([cell isEqual:txtMovesLimitCell])
	{
		[[NSScanner scannerWithString:txtMovesLimit.text] scanInt:&val];
		[LevelEditor getCurrentLevel].moveslimit = val;
	} 
	else if ([cell isEqual:txtPointsLimitCell]) 
	{
		[[NSScanner scannerWithString:txtPointsLimit.text] scanInt:&val];
		[LevelEditor getCurrentLevel].pointslimit = val;
	}
	
	
	if ([cell isEqual:txtMovesLimitCell] || [cell isEqual:txtPointsLimitCell])
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
        [txtMinLineSizeCell stopEditing];
        [txtMovesLimitCell stopEditing];
        [txtPointsLimitCell stopEditing];
    }
}

- (void)keyboardWillShow:(NSNotification *)notif
{
    // The keyboard will be shown. If the user is editing the author, adjust the display so that the
    // author field will not be covered by the keyboard.
    if ((txtMovesLimitCell.isInlineEditing || txtPointsLimitCell.isInlineEditing) && self.view.frame.origin.y >= 0)
	{
        [self setViewMovedUp:YES];
    }
	else if (!txtPointsLimitCell.isInlineEditing && self.view.frame.origin.y < 0)
	{
        [self setViewMovedUp:NO];
    }
}


#pragma mark - UIViewController delegate methods

- (void)viewWillAppear:(BOOL)animated
{
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


@end
