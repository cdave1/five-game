//
//  EditableTableCell.h
//  ARTest
//
//  Created by david on 12/01/09.
//  Copyright 2009 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol EditableTableViewCellDelegate;

@interface EditableTableViewCell : UITableViewCell
{
    id <EditableTableViewCellDelegate> delegate;
    BOOL isInlineEditing;
}

// Exposes the delegate property to other objects.
@property (nonatomic, assign) id <EditableTableViewCellDelegate> delegate;
@property (nonatomic, assign) BOOL isInlineEditing;

// Informs the cell to stop editing, resulting in keyboard/pickers/etc. being ordered out 
// and first responder status resigned.
- (void)stopEditing;

@end

// Protocol to be adopted by an object wishing to customize cell behavior with respect to editing.
@protocol EditableTableViewCellDelegate <NSObject>

@optional

// Invoked before editing begins. The delegate may return NO to prevent editing.
- (BOOL)cellShouldBeginEditing:(EditableTableViewCell *)cell;
// Invoked after editing ends.
- (void)cellDidEndEditing:(EditableTableViewCell *)cell;

@end
