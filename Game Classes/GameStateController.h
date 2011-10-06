//
//  GameStateController.h
//  QuartzFeedback
//
//  Created by david on 20/11/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GameStateModel.h"

@interface GameStateController : NSObject {
	IBOutlet GameStateModel* gameStateModel;
}

@property(retain) GameStateModel* gameStateModel;

//- (void)initWithGameStateModel;

@end
