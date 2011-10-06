//
//  DetailsViewController.h
//  ARTest
//
//  Created by david on 21/12/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CellTextField.h"
#import "SourceCell.h"


@interface LevelgroupViewController : UIViewController <UITextViewDelegate, UITextFieldDelegate,
UITableViewDelegate, UITableViewDataSource, EditableTableViewCellDelegate> {
	UITableView		*myTableView;
	UITextField		*savedFirstResponder;
	
	//UIView *levelsBox;
	//UILabel *lblLevelsMessage;
	//UIButton *btnEditLevels;
	//UITableViewCell *levelsBoxCell;
	
														
														
	UITextField		*txtName;
	EditableTableViewCell	*txtNameCell;			// kept track for editing
	
	UITextField		*txtDescription;
	EditableTableViewCell	*txtDescriptionCell;	// kept track for editing
	
	UITextField		*txtBonusItem;
	EditableTableViewCell	*txtBonusItemCell;	// kept track for editing
}

@property (nonatomic, retain) UITableView *myTableView;

@end
