//
//  SourceCell.h
//  ARTest
//
//  Created by david on 12/01/09.
//  Copyright 2009 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>

// cell identifier for this custom cell
extern NSString *kSourceCell_ID;

@interface SourceCell : UITableViewCell
{
	UILabel	*sourceLabel;
}

@property (nonatomic, retain) UILabel *sourceLabel;

@end
