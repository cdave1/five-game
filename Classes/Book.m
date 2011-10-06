//
//  Book.m
//  ARTest
//
//  Created by david on 13/12/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import "Book.h"


@implementation Book
@dynamic title, author, copyright;

- (void) dealloc
{
	//[self.title release];
	//[self.author release];
	[super dealloc];
}

@end
