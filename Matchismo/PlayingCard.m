//
//  PlayingCard.m
//  Matchismo
//
//  Created by ian on 7/5/13.
//  Copyright (c) 2013 ian. All rights reserved.
//

#import "PlayingCard.h"
#import "SetCard.h"

@implementation PlayingCard
@synthesize suit = _suit;  //needed because we provide setter AND getter 

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if (otherCards.count == 1) {
        id otherCard = [otherCards lastObject];
        if ([otherCard isKindOfClass:[PlayingCard class]]) {
            PlayingCard *otherPlayingCard = otherCard;
            
            if ([otherPlayingCard.suit isEqualToString:self.suit]) {
                score = 2;
            } else if (otherPlayingCard.rank == self.rank) {
                score = 8;
            }
        }
    }
    return score;
}

- (int)matchSet:(NSSet *)otherCards
{
    int score = 0;

 /* ###### PROBABILITIES AND POINTS #######
  prob of pulling 2 of any suit = 1/4 or 2 points
  prob of pulling 2 of any rank = 1/17 or 8 points
  
  prob of pulling 3 of any suit = 1/20 = 12 or 10 points
  prob of pulling 2 out of 3 same suit  ~ 1/2 or   1 point
  prob of pulling 3 of any rank = 1/230 or 100 points
  prob of pulling 2 out of 3 same rank  1/21 = 9 points

  */
    
     if (otherCards.count == 3) {
         
        
        id otherCard = [otherCards anyObject];
         if ([otherCard isKindOfClass:[PlayingCard class]]) {
             NSArray *otherCardsArray = [otherCards allObjects];
             PlayingCard *firstCard = [otherCardsArray lastObject];
             NSMutableArray *mutableCopy1 = [[NSMutableArray alloc] initWithArray:otherCardsArray];
             [mutableCopy1 removeLastObject];
             PlayingCard *secondCard = [mutableCopy1 lastObject];
             NSMutableArray *mutableCopy2 = [[NSMutableArray alloc] initWithArray:mutableCopy1];
             [mutableCopy2 removeLastObject];
             PlayingCard *thirdCard = [mutableCopy2 lastObject];
             
             // to restore everything replace self.suit with thirdCard.suit
             
             if (firstCard.rank == thirdCard.rank && secondCard.rank == thirdCard.rank)
                 score = 100;
             else if (([firstCard.suit isEqualToString:thirdCard.suit] &&
                       [secondCard.suit isEqualToString:thirdCard.suit])
                      &&  !(firstCard.rank == thirdCard.rank | secondCard.rank == thirdCard.rank | firstCard.rank == secondCard.rank))
                 
                 score = 10;
             else if (firstCard.rank == thirdCard.rank | secondCard.rank == thirdCard.rank | firstCard.rank == secondCard.rank)
                 score = 9;
             else if  ([firstCard.suit isEqualToString:thirdCard.suit]|
                       [secondCard.suit isEqualToString:thirdCard.suit]|
                       [firstCard.suit isEqualToString:secondCard.suit])
                 score = 1;
         }

     }
    return score;
     
}

+(NSArray *)validSuits
{
    return @[@"♠",@"♣", @"♥", @"♦"];
}

+(NSArray *)rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+(NSUInteger) maxRank
{
    return [self rankStrings].count-1;
}

- (NSString *)contents
{
    return [[PlayingCard rankStrings][self.rank] stringByAppendingString: self.suit];
}

- (NSString *) suit
{
    return _suit ? _suit : @"?";
}

-(void)setSuit:(NSString *)suit
{
    if([[PlayingCard validSuits] containsObject:suit])
        _suit = suit;
}

-(void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}


@end
