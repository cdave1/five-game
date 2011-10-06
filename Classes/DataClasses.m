//
//  DataClasses.m
//  ARTest
//
//  Created by david on 23/12/08.
//  Copyright 2008 n/a. All rights reserved.
//

#import "DataClasses.h"
#import <stdlib.h>


// NON ARBase object.
@implementation Piece
@synthesize type, position;

- init
{
	if ((self = [super init]) != nil)
	{
		srand(CFAbsoluteTimeGetCurrent());
		self.type = rand() % 7;
	}
	return self; 
}

- initWithType:(PieceType)theType
{
	if ((self = [super init]) != nil)
	{
		self.type = theType;
	}
	return self; 
}
@end



@implementation Tile
@synthesize piece, index;
@dynamic isEmpty, position, type;
-(BOOL)isEmpty
{
	if (self.type.intValue == (int)WallTile) return NO;
	else return ([self piece] == nil);
}
+ (void)initialize
{
	[[self relationships] addObject:[ARRelationshipBelongsTo relationshipWithName:@"level"]];
}
@end


@implementation Goal
@dynamic tag, type, count, isOptional;
+ (void)initialize
{
	[[self relationships] addObject:[ARRelationshipBelongsTo relationshipWithName:@"level"]];
	[[self relationships] addObject:[ARRelationshipHasMany relationshipWithName:@"bonuses"]];
}
@end


@implementation Bonus
@dynamic tag, type, count;
+ (void)initialize
{
	[[self relationships] addObject:[ARRelationshipBelongsTo relationshipWithName:@"goal"]];
}
@end


@implementation Levelgroup
@dynamic name, description, imageName, created;
+ (void)initialize
{
	[[self relationships] addObject:[ARRelationshipHasMany relationshipWithName:@"levels"]];
	//[[self relationships] addObject:[ARRelationshipHasOne relationshipWithName:@"animal"]];
	//[[self relationships] addObject:[ARRelationshipHasManyThrough relationshipWithName:@"belgians" through:@"people"]];
}
@end


@implementation Levelitem
@dynamic containertype, piecetype, position;
+ (void)initialize
{
	[[self relationships] addObject:[ARRelationshipBelongsTo relationshipWithName:@"level"]];
}
@end



@implementation Level
@dynamic height, width, moveslimit, pointslimit, minlinesize;
+ (void)initialize
{
	[[self relationships] addObject:[ARRelationshipBelongsTo relationshipWithName:@"levelgroup"]];
	[[self relationships] addObject:[ARRelationshipHasMany relationshipWithName:@"goals"]];
	[[self relationships] addObject:[ARRelationshipHasMany relationshipWithName:@"tiles"]];
}
@end
