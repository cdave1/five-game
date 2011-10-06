//
//  BonusActionView.m
//  ARTest
//
//  Created by david on 15/01/09.
//  Copyright 2009 n/a. All rights reserved.
//

#import "BonusActionView.h"


@implementation BonusActionView
- initWithBonusPaperworkAction:(BonusPaperworkAction*)action
{
	if ((self = [super init]) != nil)
	{
		lblMessage = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 120.0f, 30.0f)];
		lblMessage.backgroundColor = [UIColor clearColor];
		lblMessage.opaque = NO;
		lblMessage.textAlignment = UITextAlignmentCenter;
		
		lblMessage.textColor = [UIColor whiteColor];
		lblMessage.highlightedTextColor = [UIColor blackColor];
		lblMessage.font = [UIFont boldSystemFontOfSize:40];
		lblMessage.text = [NSString stringWithFormat:@"%@", [action.bonus getMessage]];
		
		[self addSubview:lblMessage];
	}
	return self;
}
@end
