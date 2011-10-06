//
//  DataClasses.h
//  ARTest
//
//  Created by david on 16/12/08.
//  Copyright 2008 n/a. All rights reserved.
//
/*
#import "ActiveRecord.h"
#import "Constants.h"







// Not an arbase object - not stored in the database, but created from items in the level container
@interface AR_Piece : NSObject 
{
	PieceType type;
	int position;
}
- initWithType:(PieceType)theType;
@property(readwrite) int position;
@property(readwrite) PieceType type;
@end


//CREATE TABLE savegames ("id" INTEGER PRIMARY KEY NOT NULL, "levelgroupId" integer DEFAULT NULL, 
//						"levelId" integer DEFAULT NULL, "totalpoints" integer DEFAULT 0, "levelpoints" integer DEFAULT 0, 
//						"levellineCount" integer DEFAULT 0, "levelmovesCount" integer DEFAULT 0);
// Add container items
// Add lines.
// Add achievements.
@interface AR_Savegame : ARBase {}
@property(readwrite) int totalpoints, levelpoints, levellineCount, levelmovesCount;
@end
@interface AR_Savegame (Accessors)
- (void)setLevelgroup:(AR_Levelgroup *)levelgroup;
- (AR_Levelgroup *)levelgroup;
- (void)setLevel:(AR_Level *)level;
- (Level *)level;
@end


//CREATE TABLE lines ("id" INTEGER PRIMARY KEY NOT NULL, "levelId" integer DEFAULT NULL, "type" integer DEFAULT NULL, 
//					"count" integer DEFAULT 0, "points" integer DEFAULT 0, "achievementId" integer DEFAULT NULL);
@interface AR_Scoring : ARBase {}
@property(readwrite) int type, count, points;
@end
@interface AR_Scoring (Accessors)
- (void)setLevel:(AR_Level *)level;
- (AR_Level *)level;
- (void)setAchievement:(AR_Achievement *)achievement;
- (Achievement *)achievement;
@end


// CREATE TABLE containeritems("id" INTEGER PRIMARY KEY NOT NULL, "containertype" integer DEFAULT 0, 
//							"piecetype" integer DEFAULT 0, "savegameId" DEFAULT NULL, "position" integer DEFAULT NULL);
@interface AR_Containeritem : ARBase {}
@property(readwrite) int containertype, piecetype, position;
@end
@interface AR_Containeritem (Accessors)
@end


// CREATE TABLE achievements ("id" INTEGER PRIMARY KEY NOT NULL, "savegameId" integer default NULL, 
//							"levelId" integer default NULL, "goalId" integer default NULL, "type" integer DEFAULT 0, 
//							"text" varchar(255) DEFAULT "");
// Set goal. 
// Set save game.
@interface AR_Achievement : ARBase {}
@end
@interface AR_Achievement (Accessors)
@end


// CREATE TABLE tiles ("id" INTEGER PRIMARY KEY NOT NULL, "index" integer DEFAULT NULL, "type" integer DEFAULT 0, 
//						"levelId" integer default NULL, "pieceId" integer default NULL);
@interface AR_Tile : ARBase 
{
	int index;
	Piece* piece;
}
@property(readonly) BOOL isEmpty;
@property(readwrite) int index;
@property(readwrite, retain) NSNumber *position, *type;
@property(readwrite, retain) Piece* piece;
@end
@interface AR_Tile (Accessors)
- (void)setLevel:(AR_Level *)level;
- (AR_Level *)level;
@end



//CREATE TABLE levelitems ("id" INTEGER PRIMARY KEY NOT NULL, "containertype" integer DEFAULT 0, "piecetype" integer DEFAULT 0, 
//						 "position" integer DEFAULT NULL, "levelId" integer default NULL);
@interface AR_Levelitem : ARBase {}
@property(readwrite) int containertype, piecetype, position;
@end
@interface AR_Levelitem (Accessors)
- (void)setLevel:(AR_Level *)level;
- (AR_Level *)level;
@end



// CREATE TABLE levels ("id" INTEGER PRIMARY KEY NOT NULL, "height" integer DEFAULT 1, "width" integer DEFAULT 1, 
//					 "moveslimit" integer DEFAULT -1, "pointslimit" integer DEFAULT -1, "piecerestrictions" varchar(255) DEFAULT NULL,
//					 "minlinesize" integer DEFAULT 0, "levelgroupId" integer DEFAULT NULL);
// Add an achievement.
@interface AR_Level : ARBase {}
@property(readwrite, retain) NSNumber *height, *width, *moveslimit, *pointslimit, *minlinesize;
@end
@interface AR_Level (Accessors)
- (NSArray *)goals;
- (NSArray *)tiles;
- (void)setTiles:(NSArray *)tiles;
//- (NSArray *)levelitems;
- (void)addGoal:(AR_Goal *)goal;
- (void)addTile:(AR_Tile *)tile;
//- (void)addLevelitem:(Levelitem *)levelitem;

- (void)setLevelgroup:(AR_Levelgroup *)levelgroup;
- (AR_Levelgroup *)levelgroup;
@end


@interface AR_Levelgroup : ARBase {}
@property(readwrite, assign) NSString *name, *description, *imageName;
@property(readwrite, retain) NSNumber *created;
@end

@interface AR_Levelgroup (Accessors)
- (NSArray *)levels;
- (void)setLevels:(NSArray *)levels;
- (void)addLevel:(AR_Level *)level;
@end


@interface AR_Bonus : ARBase {
}
@property(readwrite, assign) NSString *tag;
@property(readwrite) int type, count;
@end
@interface AR_Bonus (Accessors)
- (AR_Goal *)goal;
@end


@interface AR_Goal : ARBase {	
}
@property(readwrite, assign) NSString *tag;
@property(readwrite) int type, isOptional, count;
@end
@interface AR_Goal (Accessors)
- (AR_Level *)level;
- (void)addBonus:(AR_Bonus *)bonus;
- (NSArray *)bonuses;
@end

*/

