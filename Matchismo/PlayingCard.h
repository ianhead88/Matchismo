//
//  PlayingCard.h
//  Matchismo
//
//  Created by ian on 7/5/13.
//  Copyright (c) 2013 ian. All rights reserved.
//

#import "Card.h"

@interface PlayingCard : Card

@property (strong, nonatomic) NSString *suit;
@property (nonatomic) NSUInteger rank;

+(NSArray *)validSuits;
+(NSUInteger) maxRank;

@end
