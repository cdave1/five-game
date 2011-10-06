/*
 
 File: CustomPicker.m
 Abstract: A custom UIPicker that shows text and images.
 
 Version: 1.7
 
 Disclaimer: IMPORTANT:  This Apple software is supplied to you by Apple Inc.
 ("Apple") in consideration of your agreement to the following terms, and your
 use, installation, modification or redistribution of this Apple software
 constitutes acceptance of these terms.  If you do not agree with these terms,
 please do not use, install, modify or redistribute this Apple software.
 
 In consideration of your agreement to abide by the following terms, and subject
 to these terms, Apple grants you a personal, non-exclusive license, under
 Apple's copyrights in this original Apple software (the "Apple Software"), to
 use, reproduce, modify and redistribute the Apple Software, with or without
 modifications, in source and/or binary forms; provided that if you redistribute
 the Apple Software in its entirety and without modifications, you must retain
 this notice and the following text and disclaimers in all such redistributions
 of the Apple Software.
 Neither the name, trademarks, service marks or logos of Apple Inc. may be used
 to endorse or promote products derived from the Apple Software without specific
 prior written permission from Apple.  Except as expressly stated in this notice,
 no other rights or licenses, express or implied, are granted by Apple herein,
 including but not limited to any patent rights that may be infringed by your
 derivative works or by other works in which the Apple Software may be
 incorporated.
 
 The Apple Software is provided by Apple on an "AS IS" basis.  APPLE MAKES NO
 WARRANTIES, EXPRESS OR IMPLIED, INCLUDING WITHOUT LIMITATION THE IMPLIED
 WARRANTIES OF NON-INFRINGEMENT, MERCHANTABILITY AND FITNESS FOR A PARTICULAR
 PURPOSE, REGARDING THE APPLE SOFTWARE OR ITS USE AND OPERATION ALONE OR IN
 COMBINATION WITH YOUR PRODUCTS.
 
 IN NO EVENT SHALL APPLE BE LIABLE FOR ANY SPECIAL, INDIRECT, INCIDENTAL OR
 CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
 GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
 ARISING IN ANY WAY OUT OF THE USE, REPRODUCTION, MODIFICATION AND/OR
 DISTRIBUTION OF THE APPLE SOFTWARE, HOWEVER CAUSED AND WHETHER UNDER THEORY OF
 CONTRACT, TORT (INCLUDING NEGLIGENCE), STRICT LIABILITY OR OTHERWISE, EVEN IF
 APPLE HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 
 Copyright (C) 2008 Apple Inc. All Rights Reserved.
 
 */

#import "CustomPicker.h"
#import "CustomView.h"

@implementation CustomPicker

@synthesize pieceType;

- (id)initWithFrame:(CGRect)frame
{
	self = [super initWithFrame:frame];
	if (self)
	{
		self.delegate = self;	
		
		pickerViews = [[NSMutableArray alloc] init];
		
		CustomView *menuItemView = [[CustomView alloc] initWithFrame:CGRectZero];
		menuItemView.title = @"Red";
		menuItemView.image = [UIImage imageNamed:@"marker_red.png"];
		menuItemView.pieceType = RedPiece;
		[pickerViews addObject:menuItemView];
		[menuItemView release];
		
		menuItemView = [[CustomView alloc] initWithFrame:CGRectZero];
		menuItemView.title = @"Orange";
		menuItemView.image = [UIImage imageNamed:@"marker_orange.png"];
		menuItemView.pieceType = OrangePiece;
		[pickerViews addObject:menuItemView];
		[menuItemView release];
		
		menuItemView = [[CustomView alloc] initWithFrame:CGRectZero];
		menuItemView.title = @"Yellow";
		menuItemView.image = [UIImage imageNamed:@"marker_yellow.png"];
		menuItemView.pieceType = YellowPiece;
		[pickerViews addObject:menuItemView];
		[menuItemView release];
		
		menuItemView = [[CustomView alloc] initWithFrame:CGRectZero];
		menuItemView.title = @"Green";
		menuItemView.image = [UIImage imageNamed:@"marker_green.png"];
		menuItemView.pieceType = GreenPiece;
		[pickerViews addObject:menuItemView];
		[menuItemView release];	

		menuItemView = [[CustomView alloc] initWithFrame:CGRectZero];
		menuItemView.title = @"Blue";
		menuItemView.image = [UIImage imageNamed:@"marker_blue.png"];
		menuItemView.pieceType = BluePiece;
		[pickerViews addObject:menuItemView];
		[menuItemView release];	
		
		menuItemView = [[CustomView alloc] initWithFrame:CGRectZero];
		menuItemView.title = @"Indigo";
		menuItemView.image = [UIImage imageNamed:@"marker_indigo.png"];
		menuItemView.pieceType = IndigoPiece;
		[pickerViews addObject:menuItemView];
		[menuItemView release];	
		
		menuItemView = [[CustomView alloc] initWithFrame:CGRectZero];
		menuItemView.title = @"Violet";
		menuItemView.image = [UIImage imageNamed:@"marker_violet.png"];
		menuItemView.pieceType = VioletPiece;
		[pickerViews addObject:menuItemView];
		[menuItemView release];	
	}
	return self;
}

- (void)dealloc
{
	[pickerViews release];
	[super dealloc];
}


#pragma mark UIPicker delegate methods

// tell the picker how many rows are available for a given component (in our case we have one component)
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
	NSUInteger numRows;
	if (component == 0)
	{
		numRows = (NSUInteger)[pickerViews count];
	}
	return numRows;
}

// tell the picker which view to use for a given component and row, we have an array of color views to show
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row
		  forComponent:(NSInteger)component reusingView:(UIView *)view
{
	UIView *viewToUse = nil;
	if (component == 0)
	{
		viewToUse = [pickerViews objectAtIndex:row];
	}
	return viewToUse;
}

// tell the picker how many components it will have (in our case we have one component)
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
	return 1;
}

// tell the picker the title for a given component (in our case we have one component)
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
	NSString *title;
	if (component == 0)
	{
		title = @"color";
	}
	return title;
}

// tell the picker the width of each row for a given component (in our case we have one component)
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
	CustomView *viewToUse = [pickerViews objectAtIndex:0];
	return viewToUse.bounds.size.width;
}

// tell the picker the height of each row for a given component (in our case we have one component)
- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
	CustomView *viewToUse = [pickerViews objectAtIndex:0];
	return viewToUse.bounds.size.height;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
	CustomView *view = [pickerViews objectAtIndex:row];
	if (view != nil)
	{
		self.pieceType = view.pieceType;
	}
}

@end
