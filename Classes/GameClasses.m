//
//  GameClasses.m
//  ARTest
//
//  Created by david on 8/01/09.
//  Copyright 2009 n/a. All rights reserved.
//

#import "GameClasses.h"
#import <stdlib.h>


static NSMutableArray *levelgroups;


@implementation Levelgroup


@synthesize name, description, imageName, levels;
- (id)initWithCoder:(NSCoder *)coder
{
	if ((self = [super init]) != nil) {
		self.name = [coder decodeObjectForKey:@"name"];
		self.description = [coder decodeObjectForKey:@"description"];
		self.imageName = [coder decodeObjectForKey:@"imageName"];
		self.levels = [coder decodeObjectForKey:@"levels"];
	}
	return self;
}


- (void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeObject:name forKey:@"name"];
	[coder encodeObject:description forKey:@"description"];
	[coder encodeObject:imageName forKey:@"imageName"];
	[coder encodeObject:levels forKey:@"levels"];
}


+ (NSMutableArray *)GetLevelGroups
{
	if (levelgroups == nil)
	{
		NSFileManager *fileManager = [NSFileManager defaultManager];
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *path = [documentsDirectory stringByAppendingPathComponent:@"levelgroups.txt"];
	
		// Check if the file exists
		if ([fileManager fileExistsAtPath:path])
		{
			levelgroups = [[NSKeyedUnarchiver unarchiveObjectWithFile:path] retain];
		}
	}
	
	return levelgroups;
}


+ (void)ReloadLevelGroups
{
	levelgroups = nil;
}


+ (BOOL)SaveLevelGroups
{
	if  ([Levelgroup GetLevelGroups] != nil) {
		NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
		NSString *documentsDirectory = [paths objectAtIndex:0];
		NSString *path = [documentsDirectory stringByAppendingPathComponent:@"levelgroups.txt"];
	
		[NSKeyedArchiver archiveRootObject:levelgroups toFile:path];
		return YES;
	} else return NO;
}


+ (Levelgroup *)LevelgroupMake:(NSString *)name
{
	if ([Levelgroup GetLevelGroups] == nil)
	{
		levelgroups = [[NSMutableArray array] retain];
	}
	Levelgroup* levelgroup = [[Levelgroup alloc] init];
	levelgroup.name = name;
	levelgroup.levels = [NSMutableArray array];
	[levelgroups addObject:levelgroup];
	return levelgroup;
}


+ (Levelgroup *)GetLevelGroupWithName:(NSString *)name
{
	//[NSString 
	if ([Levelgroup GetLevelGroups] != nil) {
		for(Levelgroup *group in levelgroups)
		{
			if ([group.name compare:name] == 0) return group;
		}
		return nil;
	} else return nil;
}

@end


@implementation Level
@synthesize order, height, width, moveslimit, pointslimit, minlinesize, goals, startingPieces, tiles, levelgroup;
- init
{
	if ((self = [super init]) != nil) {
		self.goals = [[NSMutableArray alloc] init];
		self.startingPieces = [[NSMutableArray alloc] init];
		self.tiles = [[NSMutableArray alloc] init];
		self.minlinesize = 3;
		self.pointslimit = -1;
		self.moveslimit = -1;
	}
	return self;
}


- (void) dealloc
{
	[self.goals release];
	[self.startingPieces release];
	[self.tiles release];
	[super dealloc];
}


- (id)initWithCoder:(NSCoder *)coder
{
	if ((self = [self init]) != nil) {
		self.order = [coder decodeIntForKey:@"order"];
		self.height = [coder decodeIntForKey:@"height"];
		self.width = [coder decodeIntForKey:@"width"];
		self.moveslimit = [coder decodeIntForKey:@"moveslimit"];
		self.pointslimit = [coder decodeIntForKey:@"pointslimit"];
		self.minlinesize = [coder decodeIntForKey:@"minlinesize"];
		
		self.goals = [[coder decodeObjectForKey:@"goals"] retain];
		self.startingPieces = [[coder decodeObjectForKey:@"startingPieces"] retain];
		self.tiles = [[coder decodeObjectForKey:@"tiles"] retain];
	}
	return self;
}


- (void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeInt:self.order forKey:@"order"];
	[coder encodeInt:self.height forKey:@"height"];
	[coder encodeInt:self.width forKey:@"width"];
	[coder encodeInt:self.moveslimit forKey:@"moveslimit"];
	[coder encodeInt:self.pointslimit forKey:@"pointslimit"];
	[coder encodeInt:self.minlinesize forKey:@"minlinesize"];
	
	[coder encodeObject:self.goals forKey:@"goals"];
	[coder encodeObject:self.startingPieces forKey:@"startingPieces"];
	[coder encodeObject:self.tiles forKey:@"tiles"];
}
@end


@implementation Tile
@synthesize index, position, type, piece;
@dynamic isEmpty;
- (id)initWithCoder:(NSCoder *)coder
{
	if ((self = [super init]) != nil) {
		self.index = [coder decodeIntForKey:@"index"];
		self.position = [coder decodeIntForKey:@"position"];
		self.type = (TileType)[coder decodeIntForKey:@"type"];
		self.piece = [coder decodeObjectForKey:@"piece"];
	}
	return self;
}


- (void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeInt:self.index forKey:@"index"];
	[coder encodeInt:self.position forKey:@"position"];
	[coder encodeInt:(int)self.type forKey:@"type"];
	[coder encodeObject:self.piece forKey:@"piece"];
}


-(BOOL)isEmpty
{
	if (self.type == WallTile) return NO;
	else return ([self piece] == nil);
}
@end


@implementation Piece
@synthesize type, position;
- init
{
	if ((self = [super init]) != nil)
	{
		self.type = (PieceType)(rand() % 7);
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


- (id)initWithCoder:(NSCoder *)coder
{
	if ((self = [super init]) != nil) {
		self.position = [coder decodeIntForKey:@"position"];
		self.type = (TileType)[coder decodeIntForKey:@"type"];
	}
	return self;
}


- (void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeInt:self.position forKey:@"position"];
	[coder encodeInt:(int)self.type forKey:@"type"];
}
@end
