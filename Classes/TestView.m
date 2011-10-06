//
//  TestView.m
//  ARTest
//
//  Created by david on 13/12/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import "TestView.h"
#import "Book.h"
#import "DataClasses.h"

@implementation TestView

@synthesize label, infoLabel;

- initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]) != nil)
	{
		UIButton *newBook = [[UIButton buttonWithType:UIButtonTypeRoundedRect] retain];
		newBook.frame = CGRectMake(5.0f, 40.0f, 220.0f, 50.0f);
		[newBook setTitle:@"New Level Group" forState:UIControlStateNormal];
		[newBook addTarget:self action:@selector(myButtonTouchInside:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:newBook];
		[newBook release];
		
		infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 90.0f, 300.0f, 50.f)];
		[self addSubview:infoLabel];
		

		
		label = [[UILabel alloc] initWithFrame:CGRectMake(5.0f, 120.0f, 300.0f, 200.0f)];
		[self addSubview:label];
		
	}
	return self;
}







@end
