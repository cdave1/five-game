//
//  EditableTableCell.m
//  ARTest
//
//  Created by david on 12/01/09.
//  Copyright 2009 n/a. All rights reserved.
//
#import "EditableTableViewCell.h"

@implementation EditableTableViewCell

// Instruct the compiler to create accessor methods for the property.
// It will use the internal variable with the same name for storage.
@synthesize delegate;
@synthesize isInlineEditing;

// To be implemented by subclasses. 
- (void)stopEditing
{}

@end
