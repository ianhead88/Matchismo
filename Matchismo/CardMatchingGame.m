//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by ian on 7/10/13.
//  Copyright (c) 2013 ian. All rights reserved.
//

#import "CardMatchingGame.h"


@interface CardMatchingGame()
@property (strong, nonatomic) NSMutableArray *cards; //only contains card objects
@property (strong, nonatomic) NSMutableArray *cardQueue;

@end

@implementation CardMatchingGame

- (void)removeCardAtIndex:(NSUInteger)index
{
    [self.cards removeObjectAtIndex:index];
}

- (int)numberOfCards
{
    return [self.cards count];
}

- (int)cardsLeftinDeck
{
    return [self.deck.cards count];
}

-(NSMutableArray *)cards{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
        return _cards;
}

- (id)initWithCardCount:(NSUInteger)count
             usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self) {
        for (int i = 0; i < count; i++) {
            Card *card = [deck drawRandomCard];
            if (!card) self = nil;
            else {
                self.cards[i] = card;
            }
        }
    }
    _deck = deck;
    //we need to keep a pointer to the deck around so that we can add more cards. Otherwise, "AddThreeCardsToGame would NOT WORK!
    return self;
}


#define MATCH_BONUS 4
#define MISMATCH_PENALTY 2
#define FLIP_COST 1

-(void)flipCardAtIndex:(NSUInteger)index  
{
    Card *card = [self cardAtIndex:index];
    self.currentCard = card;
    
    if (!card.isUnplayable) {
        if (!card.isFaceUp) {
            //see if flipping the card creates a match
            for (Card *otherCard in self.cards){
                self.match = NO;
                if (otherCard.isFaceUp && !otherCard.isUnplayable) {
                    self.priorCard = otherCard;
                    int matchScore = [card match:@[otherCard]];
                    if (matchScore) {
                        otherCard.unplayable = YES;
                        card.unplayable = YES;
                        self.score += matchScore * MATCH_BONUS;
                        self.match = YES;
                        self.resetAfterMatch = YES;
                        if (matchScore ==2) self.points = 8;
                        else if (matchScore ==8) self.points = 32;
                        
                    } else {
                        otherCard.faceUp = NO;
                        self.score -= MISMATCH_PENALTY;
                        self.match = NO;
                        self.resetAfterMatch = NO;

                    }
                break;
                }
            }
        }
        card.faceUp = !card.isFaceUp;
    }
    
}

-(NSMutableArray *) cardQueue
{
    if (_cardQueue == 0) _cardQueue = [[NSMutableArray alloc] init];
    return _cardQueue;
}

-(void) clearQueue
{
    [_cardQueue removeAllObjects];
}

-(void)flipTwoCardsAtIndex:(NSUInteger)index
{
    Card *card = [self cardAtIndex:index];
    
    if (!card.isUnplayable)
    {
        if (!card.isFaceUp)
        {     //this for loop turns all the cards back over
            for (Card *resetUnmatchedCard in self.cards) {
                if (!resetUnmatchedCard.unplayable && resetUnmatchedCard.isFaceUp) {
                    resetUnmatchedCard.faceUp = !resetUnmatchedCard.isFaceUp;
                }
            }
            self.match = NO;
            self.currentCard = card;
    
            [self.cardQueue addObject:card];
    
            if (self.cardQueue.count == 3) {
                NSArray *cardQueueCopy = [self.cardQueue copy];
                NSSet *cardSet = [[NSSet alloc] initWithArray:cardQueueCopy];
                int matchScore = [card matchSet:cardSet];
            
                Card *middleCard = [self.cardQueue objectAtIndex:1];
                Card *firstCard = [self.cardQueue objectAtIndex:0];
                self.priorCard = firstCard;
                self.priorPriorCard = middleCard;

                if (matchScore) {
                    self.score += matchScore * MATCH_BONUS;
                    card.unplayable = YES;
                    middleCard.unplayable = YES;
                    firstCard.unplayable = YES;
                    middleCard.faceUp = !middleCard.isFaceUp;
                    firstCard.faceUp = !firstCard.isFaceUp;
                    [self clearQueue];
                    self.match = YES;
                    self.resetAfterMatch = YES;
                }else {
                    self.score -= MISMATCH_PENALTY;
                    [self clearQueue];
                    self.match = NO;
                    self.resetAfterMatch = YES;
                }
            }
        }
    }
    card.faceUp = !card.isFaceUp;
}

-(void)addCardToGame
{
    if ([self.deck.cards count]>=3) {
        Card *newCard1 = [self.deck drawRandomCard];
        [self.cards addObject:newCard1];
    }

}

-(Card *)cardAtIndex:(NSUInteger)index
{
    return (index < self.cards.count) ? self.cards[index] : nil;
}

@end
