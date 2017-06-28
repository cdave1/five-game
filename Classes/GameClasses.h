//
//  GameClasses.h
//  ARTest
//
//  Created by david on 8/01/09.
//  Copyright 2009 n/a. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SaveGame;
@class Scoring;
@class Achievement;
@class Level;
@class Piece;
@class Tile;
@class Levelgroup;
@class Bonus;


typedef enum {
	NullPiece = -1,
	RedPiece = 0,
	OrangePiece = 1,
	YellowPiece = 2,
	GreenPiece = 3,
	BluePiece = 4,
	IndigoPiece = 5,
	VioletPiece = 6,
	WildcardPiece = 7,
	BombPiece = 8
} PieceType;


typedef enum {
	StartingPieces = 0,
	QueueContainer = 1,
	MagnetContainer = 2
} ContainerType;


typedef enum {
	NormalTile = 0,
	WallTile = 1
} TileType;


typedef enum {
	NonAchivement = 0
} AchievementType;


typedef enum {
	RedJewelItem = 0,
	OrangeJewelItem = 1,
	YellowJewelItem = 2,
	GreenJewelItem = 3,
	BlueJewelItem = 4,
	IndigoJewelItem = 5,
	VioletJewelItem = 6
} BonusItemType;


@interface Levelgroup : NSObject <NSCoding>
{
	NSString *name;
	NSString *description;
	NSString *imageName;
	NSMutableArray *levels;
}

@property(nonatomic, copy) NSString *name, *description, *imageName;
@property(nonatomic, retain) NSMutableArray* levels;

+ (NSMutableArray *)GetLevelGroups;
+ (void)ReloadLevelGroups;
+ (BOOL)SaveLevelGroups;
+ (Levelgroup *)LevelgroupMake:(NSString *)name;
+ (Levelgroup *)GetLevelGroupWithName:(NSString *)name;

@end


@interface Level : NSObject <NSCoding>
{
	NSInteger order;
	NSInteger height;
	NSInteger width;
	NSInteger minlinesize;
	
	NSInteger moveslimit;
	NSInteger pointslimit;
	
	NSMutableArray* goals;
	NSMutableArray* startingPieces;
	NSMutableArray* tiles;
	Levelgroup* levelgroup;
}

@property NSInteger order, height, width, minlinesize;
@property NSInteger moveslimit, pointslimit;
@property(nonatomic, retain) NSMutableArray* goals;
@property(nonatomic, retain) NSMutableArray* tiles;
@property(nonatomic, retain) NSMutableArray* startingPieces;
@property(nonatomic, retain) Levelgroup* levelgroup;

@end


@interface Tile : NSObject <NSCoding>
{
	NSInteger index;
	NSInteger position;
	TileType type;
	Piece* piece;
}

@property NSInteger index;
@property NSInteger position;
@property TileType type;
@property(nonatomic, retain) Piece * piece;
@property BOOL isEmpty;

@end


@interface Piece : NSObject <NSCoding>
{
	PieceType type;
	NSInteger position;
}
- initWithType:(PieceType)theType;

@property NSInteger position;
@property PieceType type;

@end


@interface Achievement : NSObject 
{
	
}
@end


@interface SaveGame : NSObject <NSCoding> 
{
	NSInteger totalpoints;
	NSInteger levelpoints;
	NSInteger levellineCount;
	NSInteger levelmovesCount;
	Level* level;
}

@property NSInteger totalpoints, levelpoints, levellineCount, levelmovesCount;

+ (id)GetSavegameForLevelGroup:(Levelgroup *)levelgroup;

@end


@interface Scoring : NSObject <NSCoding>
{
	NSInteger type;
	NSInteger count;
	NSInteger points;
	NSInteger levelid;
	Achievement* achievement;
}

@property NSInteger type, count, points;

- (void)setLevel:(Level *)level;
- (Level *)level;
- (void)setAchievement:(Achievement *)achievement;
- (Achievement *)achievement;

@end
