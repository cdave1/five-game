//
//  CellTextField.h
//  ARTest
//
//  Created by david on 12/01/09.
//  Copyright 2009 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EditableTableViewCell.h"

// cell identifier for this custom cell
extern NSString *kCellTextField_ID;

@interface CellTextField : EditableTableViewCell <UITextFieldDelegate>
{
    UITextField *view;
}

@property (nonatomic, retain) UITextField *view;

@end
