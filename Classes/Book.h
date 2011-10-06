//
//  Book.h
//  ARTest
//
//  Created by david on 13/12/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActiveRecord.h"

@interface Book : ARBase
@property(readwrite, assign) NSString *title, *author;
@property(readwrite, assign) int copyright;
@end
