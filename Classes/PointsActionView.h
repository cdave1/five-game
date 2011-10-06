//
//  PointsActionView.h
//  ARTest
//
//  Created by david on 14/01/09.
//  Copyright 2009 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StateChange.h"

// View for showing points that the player has earned.
@interface PointsActionView : UIView {
	UILabel *lblPoints;
}
- initWithPointsPaperworkAction:(PointsPaperworkAction*)action;
@end
