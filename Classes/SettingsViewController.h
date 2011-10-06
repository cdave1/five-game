//
//  SettingsViewController.h
//  ARTest
//
//  Created by david on 12/01/09.
//  Copyright 2009 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellTextField.h"
#import "SourceCell.h"

@interface SettingsViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate,
														UITableViewDelegate, UITableViewDataSource,
														EditableTableViewCellDelegate> {
	UITableView		*myTableView;
	UITextField		*savedFirstResponder;
	
	UITextField		*txtMinLineSize;
	CellTextField	*txtMinLineSizeCell;			// kept track for editing
	
	UITextField		*txtMovesLimit;
	CellTextField	*txtMovesLimitCell;	// kept track for editing
	
	UITextField		*txtPointsLimit;
	CellTextField	*txtPointsLimitCell;	// kept track for editing
}

@property (nonatomic, retain) UITableView *myTableView;

@end
