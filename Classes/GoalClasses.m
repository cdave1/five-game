//
//  GoalClasses.m
//  ARTest
//
//  Created by david on 13/01/09.
//  Copyright 2009 n/a. All rights reserved.
//

#import "GoalClasses.h"

@implementation Goal
@synthesize bonus;
/*
- (void)dealloc
{
	if (bonus != nil) [bonus release];
	[super dealloc];
}
*/
@end


@implementation LinesGoal

- init
{
	if ((self = [super init]) != nil) {
		self.requiredCount = 1;
		self.requiredLength = -1;
		self.requiredPieceType = NullPiece;
	}
	return self;
}

@synthesize requiredPieceType, requiredLength, requiredCount, progressCount;
- (id)initWithCoder:(NSCoder *)coder
{
	if ((self = [super init]) != nil) {
		self.requiredPieceType = (PieceType)[coder decodeIntForKey:@"requiredPieceType"];
		self.requiredLength = [coder decodeIntForKey:@"requiredLength"];
		self.requiredCount = [coder decodeIntForKey:@"requiredCount"];		
	}
	return self;
}


- (void)encodeWithCoder:(NSCoder *)coder
{
	//[super encodeWithCoder:coder];
	[coder encodeInt:(int)self.requiredPieceType forKey:@"requiredPieceType"];
	[coder encodeInt:self.requiredLength forKey:@"requiredLength"];
	[coder encodeInt:self.requiredCount forKey:@"requiredCount"];
}


- (BOOL)AddWinningMove:(WinningMove *)move 
{
	if (self.requiredPieceType == NullPiece)
	{
		if (self.requiredLength == -1)
		{
			self.progressCount += 1; // any type of any length
			return YES;
		} 
		else 
		{
			if (move.removePieceActions.count >= self.requiredLength) 
			{
				self.progressCount += 1;
				return YES;
			}
		}
	} 
	else 
	{
		if (self.requiredLength == -1)
		{
			if (move.type == WildcardPiece || move.type == self.requiredPieceType)
			{
				self.progressCount += 1;
				return YES;
			}
		} 
		else 
		{
			if (move.type == WildcardPiece || move.type == self.requiredPieceType)
			{
				if (move.removePieceActions.count >= self.requiredLength) 
				{
					self.progressCount += 1;
					return YES;
				}
			}
		}
	}
	return NO;
}


- (BOOL)isAchieved
{
	return (progressCount >= requiredCount);
}


- (NSString *)getMessage
{
	return @"a line";
}


- (void)ResetProgress
{
	self.progressCount = 0;
}
@end



@implementation ConsecutiveGoal
@synthesize goals;

- init
{
	if ((self = [super init]) != nil)
	{
		self.goals = [[NSMutableArray alloc] init];
	}
	return self;
}


- (void) dealloc
{
	[self.goals release];
	[super dealloc];
}


- (BOOL)AddWinningMove:(WinningMove *)move 
{
	// For each goal, check if the winning move returns true.
	// if not, then call ResetProgress.
	BOOL ret = NO;
	for(Goal *goal in self.goals)
	{
		if ([goal AddWinningMove:move] == NO) [goal ResetProgress];
		else ret = YES;
	}
	return ret;
}


- (void)ResetProgress
{
	for(Goal *goal in self.goals)
	{
		[goal ResetProgress];
	}
}


- (BOOL)isAchieved
{
	BOOL ret = NO;
	for(Goal *goal in self.goals)
	{
		if ([goal isAchieved]) {
			ret = YES;
			break;
		}
	}
	return ret;
}


- (NSMutableArray *)GetBonuses
{
	NSMutableArray *b = [NSMutableArray array];
	for(Goal *goal in self.goals)
	{
		if ([goal isAchieved] == YES) {
			[b addObject:[goal bonus]];
		}
	}
	return b;
}


@end



@implementation ResourceGoal
@synthesize requiredPieceType, requiredQuantity, progressQuantity;
- (id)initWithCoder:(NSCoder *)coder
{
	if ((self = [super init]) != nil) {
		self.requiredPieceType = (PieceType)[coder decodeIntForKey:@"requiredPieceType"];
		self.requiredQuantity = [coder decodeIntForKey:@"requiredQuantity"];	
	}
	return self;
}


- (void)encodeWithCoder:(NSCoder *)coder
{
	//[super encodeWithCoder:coder];
	[coder encodeInt:(int)self.requiredPieceType forKey:@"requiredPieceType"];
	[coder encodeInt:self.requiredQuantity forKey:@"requiredQuantity"];
}


- (BOOL)AddWinningMove:(WinningMove *)move 
{
	if (requiredPieceType == NullPiece)
	{
		self.progressQuantity += move.removePieceActions.count;
		return YES;
	} 
	else 
	{
		if (move.type == WildcardPiece || move.type == self.requiredPieceType)
		{
			self.progressQuantity += move.removePieceActions.count;
			return YES;
		}
	}
	return NO;
}


- (BOOL)isAchieved
{
	return (progressQuantity >= requiredQuantity);
}


- (NSString *)getMessage
{
	return @"a line";
}
@end



// ==========================================
// Bonus implementations

@implementation PointsBonus
@synthesize points;

- (id)initWithCoder:(NSCoder *)coder
{
	if ((self = [super init]) != nil) {
		self.points = [coder decodeIntForKey:@"points"];
	}
	return self;
}


- (void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeInt:self.points forKey:@"points"];
}


- (NSString *)getMessage
{
	return [NSString stringWithFormat:@"+%d", self.points];
}


- (int)applyBonus:(int)toPoints
{
	return self.points + toPoints;
}
@end


@implementation MultiplierBonus
@synthesize multiplier;

- (id)initWithCoder:(NSCoder *)coder
{
	if ((self = [super init]) != nil) {
		self.multiplier = [coder decodeIntForKey:@"multiplier"];
	}
	return self;
}


- (void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeInt:self.multiplier forKey:@"multiplier"];
}


- (NSString *)getMessage
{
	return [NSString stringWithFormat:@"x%d", self.multiplier];
}


- (int)applyBonus:(int)toPoints
{
	return self.multiplier * toPoints;
}
@end


@implementation ItemBonus 
@synthesize points;
@synthesize bonusItemType;

- (id)initWithCoder:(NSCoder *)coder
{
	if ((self = [super init]) != nil) {
		self.points = [coder decodeIntForKey:@"points"];
		self.bonusItemType = (BonusItemType)[coder decodeIntForKey:@"bonusItemType"];
	}
	return self;
}


- (void)encodeWithCoder:(NSCoder *)coder
{
	[coder encodeInt:self.points forKey:@"points"];
	[coder encodeInt:(int)self.bonusItemType forKey:@"bonusItemType"];
}


- (NSString *)getMessage
{
	return [NSString stringWithFormat:@"+%d", self.points];
}


- (int)applyBonus:(int)toPoints
{
	return self.points + toPoints;
}

@end



@implementation GoalMultiplierBonus
@synthesize parentGoal;
@dynamic multiplier;
-(int)multiplier
{
	if ([parentGoal isKindOfClass:[LinesGoal class]])
		return ((LinesGoal *)parentGoal).progressCount;
	else return 1;
}
- (NSString *)getMessage
{
	return [NSString stringWithFormat:@"x%d", self.multiplier];
}
- (int)applyBonus:(int)toPoints
{
	return self.multiplier * toPoints;
}
@end

