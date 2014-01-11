//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by ian on 8/19/13.
//  Copyright (c) 2013 ian. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "PlayingCardCollectionViewCell.h"

@interface PlayingCardGameViewController ()
@end

@implementation PlayingCardGameViewController

-(NSString *)giveReuseID
{
    return @"PlayingCard";
}

- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init]; 
}

-(NSUInteger)startingCardCount
{
    return 22;
}


-(void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
{
    if ([cell isKindOfClass:[PlayingCardCollectionViewCell class]]) {
        PlayingCardView *playingCardView = ((PlayingCardCollectionViewCell *)cell).playingCardView;
        if ([card isKindOfClass:[PlayingCard class]]) {
            PlayingCard *playingCard = (PlayingCard *)card;
            
            //above, we're changing the variable type of the variable named "card" from a "Card" class to a "PlayingCard" class. PlayingCard class is a subclass of card. This is necessary and important! It is called "casting"
            
            
            playingCardView.rank = playingCard.rank;
            playingCardView.suit = playingCard.suit;
            playingCardView.faceUp = playingCard.isFaceUp;
            playingCardView.alpha = playingCard.isUnplayable ? 0.3 : 1.0;
        }
    }
}

-(void)updateDisplay
{
//    PlayingCardView *view;
//    PlayingCard *playingCard;
    
  //  playingCard = (PlayingCard *)[self.game cardAtIndex:self.currentCardIndex];
    
//    view.faceUp = playingCard.isFaceUp;
   // view.rank = playingCard.rank;
 //   view.suit = playingCard.suit;
    
}

@end
