//
//  Card.m
//  Matchismo
//
//  Created by ian on 7/3/13.
//  Copyright (c) 2013 ian. All rights reserved.
//

#import "Card.h"

@implementation Card

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    for (Card *card in otherCards) {
        if ([card.contents isEqualToString:self.contents]) {
        score = 1;
        }
    }
    
    return score;
}


- (int)matchSet:(NSSet *)otherCards
{
    int score = 0;
    return score;
}


-(NSMutableArray *) otherProperties
{
    if (_otherProperties == nil) 
        _otherProperties = [[NSMutableArray alloc] init];
    return _otherProperties;
}

@end
