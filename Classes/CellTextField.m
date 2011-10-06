//
//  CellTextField.m
//  ARTest
//
//  Created by david on 12/01/09.
//  Copyright 2009 n/a. All rights reserved.
//

#import "CellTextField.h"
#import "Constants.h"

// cell identifier for this custom cell
NSString *kCellTextField_ID = @"CellTextField_ID";

@implementation CellTextField

@synthesize view;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
	{
		// turn off selection use
		self.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	return self;
}

- (void)setView:(UITextField *)inView
{
	view = inView;
	[self.view retain];
	
	view.delegate = self;
	
	[self.contentView addSubview:inView];
	[self layoutSubviews];
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	CGRect contentRect = [self.contentView bounds];
	
	// In this example we will never be editing, but this illustrates the appropriate pattern
	CGRect frame = CGRectMake(	contentRect.origin.x + kCellLeftOffset,
							  contentRect.origin.y + kCellTopOffset,
							  contentRect.size.width - (kCellLeftOffset*2.0),
							  kTextFieldHeight);
	self.view.frame  = frame;
}

- (void)dealloc
{
    [view release];
    [super dealloc];
}

- (void)stopEditing
{
    [view resignFirstResponder];
    [self textFieldDidEndEditing:view];
}

#pragma mark -
#pragma mark <UITextFieldDelegate> Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    BOOL beginEditing = YES;
    // Allow the cell delegate to override the decision to begin editing.
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellShouldBeginEditing:)])
	{
        beginEditing = [self.delegate cellShouldBeginEditing:self];
    }
    // Update internal state.
    if (beginEditing)
		self.isInlineEditing = YES;
    return beginEditing;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // Notify the cell delegate that editing ended.
    if (self.delegate && [self.delegate respondsToSelector:@selector(cellShouldBeginEditing:)])
	{
        [self.delegate cellDidEndEditing:self];
    }
    // Update internal state.
    self.isInlineEditing = NO;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self stopEditing];
    return YES;
}

@end
