//
//  PointsActionView.m
//  ARTest
//
//  Created by david on 14/01/09.
//  Copyright 2009 n/a. All rights reserved.
//

#import "PointsActionView.h"


@implementation PointsActionView
- initWithPointsPaperworkAction:(PointsPaperworkAction*)action
{
	if ((self = [super init]) != nil)
	{
		lblPoints = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 120.0f, 30.0f)];
		lblPoints.backgroundColor = [UIColor clearColor];
		lblPoints.opaque = NO;
		lblPoints.textAlignment = UITextAlignmentCenter;
		
		lblPoints.textColor = [UIColor whiteColor];
		lblPoints.highlightedTextColor = [UIColor blackColor];
		lblPoints.font = [UIFont boldSystemFontOfSize:20];
		lblPoints.text = [NSString stringWithFormat:@"%d pts", action.points];
		
		[self addSubview:lblPoints];
	}
	return self;
}
@end
