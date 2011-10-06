//
//  SourceCell.m
//  ARTest
//
//  Created by david on 12/01/09.
//  Copyright 2009 n/a. All rights reserved.
//

#import "SourceCell.h"

// cell identifier for this custom cell
NSString *kSourceCell_ID = @"SourceCell_ID";

@implementation SourceCell

@synthesize sourceLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
	{
		// turn off selection use
		self.selectionStyle = UITableViewCellSelectionStyleNone;
		
		sourceLabel = [[UILabel alloc] initWithFrame:[self bounds]];
		sourceLabel.backgroundColor = [UIColor clearColor];
		sourceLabel.opaque = NO;
		sourceLabel.textAlignment = UITextAlignmentCenter;
		sourceLabel.textColor = [UIColor grayColor];
		sourceLabel.highlightedTextColor = [UIColor blackColor];
		sourceLabel.font = [UIFont systemFontOfSize:12];
		
		[self.contentView addSubview:sourceLabel];
	}
	return self;
}

- (void)layoutSubviews
{
	[super layoutSubviews];
	
	sourceLabel.frame = [self.contentView bounds];
}

- (void)dealloc
{
	[sourceLabel release];
	
    [super dealloc];
}

@end
