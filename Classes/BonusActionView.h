//
//  BonusActionView.h
//  ARTest
//
//  Created by david on 15/01/09.
//  Copyright 2009 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GoalClasses.h"

@interface BonusActionView : UIView {
UILabel *lblMessage;
}
- initWithBonusPaperworkAction:(BonusPaperworkAction*)action;
@end
