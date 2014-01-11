//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by ian on 7/10/13.
//  Copyright (c) 2013 ian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

-(id)initWithCardCount:(NSUInteger)cardCount
             usingDeck:(Deck *)deck;
//above is the designtated initializer

-(void)flipCardAtIndex:(NSUInteger)index;

-(void)addCardToGame;

- (int)cardsLeftinDeck;

- (void)removeCardAtIndex:(NSUInteger)index;

-(void)flipTwoCardsAtIndex:(NSUInteger)index;

-(NSMutableArray *) cardQueue;

-(Card *)cardAtIndex:(NSUInteger)index;

- (int)numberOfCards;

@property (nonatomic) int score;
@property (weak, nonatomic) Card *priorPriorCard;
@property (weak, nonatomic) Card *priorCard;
@property (weak, nonatomic) Card *currentCard;
@property (nonatomic) BOOL match;
@property (nonatomic) BOOL resetAfterMatch;
@property (nonatomic) int points;
@property (strong, nonatomic) Deck *deck;






@end
