//
//  PlayingCardGameViewController.h
//  Matchismo
//
//  Created by ian on 8/19/13.
//  Copyright (c) 2013 ian. All rights reserved.
//

#import "CardGameViewController.h"



@interface PlayingCardGameViewController : CardGameViewController

- (Deck *)createDeck; // abstract
@property (nonatomic) NSUInteger startingCardCount; //abstract
-(void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card; //abstract
-(NSString *)giveReuseID; //abstract

-(void)updateDisplay; //abstract

@end
