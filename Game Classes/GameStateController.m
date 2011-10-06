//
//  GameStateController.m
//  QuartzFeedback
//
//  Created by david on 20/11/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import "GameStateController.h"


@implementation GameStateController

@synthesize gameStateModel; 

- init
{
	self = [super init];
	self.gameStateModel = [[GameStateModel alloc] init];
	return self;
}




@end
