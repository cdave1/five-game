//
//  BackgroundView.m
//  QuartzFeedback
//
//  Created by david on 6/12/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import "BackgroundView.h"
#import "GameController.h"

@implementation BackgroundView

- initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]) != nil)
	{
		//UIImage *img = [UIImage imageNamed:@"grid2.png"];
		//tileImageRef = CGImageRetain(img.CGImage);
		
		//img = [UIImage imageNamed:@"bg_0.png"];
		//backgroundImageRef = CGImageRetain(img.CGImage);
		
		self.image = nil;
	}	
	return self;
}


- (void) dealloc
{
	CGImageRelease(backgroundImageRef);
	backgroundImageRef = nil;
	[super dealloc];
}


- (void)drawRect:(CGRect)rect 
{
	/*
	// Draw the main tile play area.
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	//self.backgroundColor = [UIColor blackColor];
	
	
	float tileXY = [GameController GetTileWidth];
	float height = [GameController GetCurrentLevel].height * tileXY;
	CGContextClipToRect(context, CGRectMake(0.0, 0.0, 320.0, height));
	
	
	CGRect imageRect;
	imageRect.origin = CGPointMake(0.0, tileXY);
	imageRect.size = CGSizeMake((tileXY * 2), (tileXY * 2));
	 
	CGContextDrawTiledImage(context, imageRect, tileImageRef);*/
} 


@end
