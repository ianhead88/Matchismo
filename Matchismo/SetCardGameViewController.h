//
//  SetCardGameViewController.h
//  Matchismo
//
//  Created by ian on 8/21/13.
//  Copyright (c) 2013 ian. All rights reserved.
//

#import "CardGameViewController.h"

@interface SetCardGameViewController : CardGameViewController

- (Deck *)createDeck; 
@property (nonatomic) NSUInteger startingCardCount;
-(void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card;
-(NSString *)giveReuseID;

@end
