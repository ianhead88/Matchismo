//
//  CardGameViewController.h
//  Matchismo
//
//  Created by ian on 7/3/13.
//  Copyright (c) 2013 ian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "CardMatchingGame.h"
#import "PlayingCard.h"
#import "PlayingCardView.h"
#import "SetCard.h"
#import "SetCardView.h"

@interface CardGameViewController : UIViewController

- (Deck *)createDeck; // abstract
@property (nonatomic) NSUInteger startingCardCount; //abstract
-(void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card; //abstract
-(NSString *)giveReuseID; //abstract
-(void)updateDisplay; //abstract

@property (strong, nonatomic) CardMatchingGame *game;

@property (weak, nonatomic) IBOutlet UICollectionView *cardCollectionView;
@property (weak, nonatomic) IBOutlet UICollectionView *setCardCollectionView;
@property (nonatomic) NSUInteger currentCardIndex;
@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardDisplay1;
@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardDisplay2;
@property (weak, nonatomic) IBOutlet UILabel *PCardMatchLabel;

@property (weak, nonatomic) IBOutlet SetCardView *setCardDisplay1;
@property (weak, nonatomic) IBOutlet SetCardView *setCardDisplay2;
@property (weak, nonatomic) IBOutlet SetCardView *setCardDisplay3;
@property (weak, nonatomic) IBOutlet UILabel *setCardMatchLabel;


@end
