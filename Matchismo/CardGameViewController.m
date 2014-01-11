//
//  CardGameViewController.m
//  Matchismo
//
//  Created by ian on 7/3/13.
//  Copyright (c) 2013 ian. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardCollectionViewCell.h"
#import "SetCardCollectionViewCell.h"



@interface CardGameViewController () <UICollectionViewDataSource>
@property (nonatomic) int flipCount;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UIButton *redealButton;


@end

@implementation CardGameViewController

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView
    numberOfItemsInSection:(NSInteger)section
{
    return self.game.numberOfCards;  // need to change this
}


-(UICollectionViewCell *) collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[self giveReuseID] forIndexPath:indexPath];
        Card *card = [self.game cardAtIndex:indexPath.item];
        self.currentCardIndex = indexPath.item;
        [self updateCell:cell usingCard:card];
        return cell;
}

-(NSString *)giveReuseID
{
    return nil;  //abstract
}

-(void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
{
    //abstract
}


-(CardMatchingGame *) game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.startingCardCount
                                                          usingDeck:[self createDeck]]; 
    return _game;
}

- (Deck *)createDeck{ return nil; } // abstract

-(void)updateUI
{
    if (self.cardCollectionView) {
        for (UICollectionViewCell *cell in [self.cardCollectionView visibleCells]) {
            NSIndexPath *indexPath = [self.cardCollectionView indexPathForCell:cell];
            Card *card = [self.game cardAtIndex:indexPath.item];
            [self updateCell:cell usingCard:card];
        }
    }
    
    if (self.setCardCollectionView) {
        for (UICollectionViewCell *cell in [self.setCardCollectionView visibleCells]) {
            NSIndexPath *indexPath = [self.setCardCollectionView indexPathForCell:cell];
            Card *card = [self.game cardAtIndex:indexPath.item];
            [self updateCell:cell usingCard:card];
            
            // loop below is to remove cards from the game
            for (int i = 1; i < self.game.numberOfCards; i++) {
                Card *card = [self.game cardAtIndex:i];
                if (card.isUnplayable) {
                    [self.game removeCardAtIndex:i];
                    [self.cardCollectionView deleteItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:i inSection:0]]];
                }
            }
            [self.setCardCollectionView reloadData];
        }
    }

    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];

    [self updateDisplay];
    
}

-(void)updateDisplay
{
    //abstract
}

- (IBAction)flipCard:(UIGestureRecognizer *)gesture
{    
    CGPoint taplocation;
    NSIndexPath *indexPath;
    if (self.cardCollectionView) {
        taplocation = [gesture locationInView:self.cardCollectionView];
        indexPath = [self.cardCollectionView indexPathForItemAtPoint:taplocation];
        [self.game flipCardAtIndex:indexPath.item];
        
        //logic below sets the display
        
        Card *card = [self.game cardAtIndex:indexPath.item];
        if ([card isKindOfClass:[PlayingCard class]]) {
            PlayingCard *playingCard = (PlayingCard *)card;
        
            if (!self.game.priorCard && !self.game.match && !self.game.resetAfterMatch) {
     
                self.playingCardDisplay1.rank = playingCard.rank;
                self.playingCardDisplay1.suit = playingCard.suit;
                self.playingCardDisplay1.faceUp = playingCard.isFaceUp;
                
                self.playingCardDisplay1.hidden = NO;
            }
            else if (self.game.priorCard && self.game.match) {
                self.playingCardDisplay2.rank = playingCard.rank;
                self.playingCardDisplay2.suit = playingCard.suit;
                self.playingCardDisplay2.faceUp = playingCard.isFaceUp;
                self.playingCardDisplay2.hidden = NO;
                
                self.playingCardDisplay1.rank = ((PlayingCard *)self.game.priorCard).rank;
                self.playingCardDisplay1.suit = ((PlayingCard *)self.game.priorCard).suit;
                self.playingCardDisplay1.faceUp = ((PlayingCard *)self.game.priorCard).isFaceUp;
                
                self.PCardMatchLabel.hidden = NO;
                self.PCardMatchLabel.text = @"MATCH!";
            }
            else if (self.game.priorCard && !self.game.match && !self.game.resetAfterMatch) {
                self.playingCardDisplay2.hidden = NO;
                self.playingCardDisplay1.hidden = NO;
                
                self.playingCardDisplay2.rank = playingCard.rank;
                self.playingCardDisplay2.suit = playingCard.suit;
                self.playingCardDisplay2.faceUp = playingCard.isFaceUp;
                
                self.playingCardDisplay1.rank = ((PlayingCard *)self.game.priorCard).rank;
                self.playingCardDisplay1.suit = ((PlayingCard *)self.game.priorCard).suit;
                self.playingCardDisplay1.faceUp = !((PlayingCard *)self.game.priorCard).isFaceUp;
                
                self.PCardMatchLabel.hidden = NO;
                self.PCardMatchLabel.text = @"DON'T MATCH!";
                
            }
            else if (self.game.resetAfterMatch) {
                
                self.playingCardDisplay1.rank = playingCard.rank;
                self.playingCardDisplay1.suit = playingCard.suit;
                self.playingCardDisplay1.faceUp = playingCard.isFaceUp;
                
                self.playingCardDisplay2.hidden = YES;
                
                self.PCardMatchLabel.hidden = YES;
            }
        }
        [self updateUI];
    }
    
    if (self.setCardCollectionView) {
        taplocation = [gesture locationInView:self.setCardCollectionView];
        indexPath = [self.setCardCollectionView indexPathForItemAtPoint:taplocation];
        [self.game flipTwoCardsAtIndex:indexPath.item];
        
        // logic to set the display
        
        Card *card = [self.game cardAtIndex:indexPath.item];
        if ([card isKindOfClass:[SetCard class]]) {
            SetCard *setCard = (SetCard *)card;
            
            if (self.game.cardQueue.count==1) {
                
                self.setCardDisplay1.color = setCard.color;
                self.setCardDisplay1.shapeCount = setCard.shapeCount;
                self.setCardDisplay1.shape = setCard.shape;
                self.setCardDisplay1.fill = setCard.fill;
                            
                self.setCardDisplay1.hidden = NO;
                self.setCardDisplay2.hidden = YES;
                self.setCardDisplay3.hidden = YES;
                
                self.setCardMatchLabel.hidden = YES;
            }
            else if (self.game.cardQueue.count==2) {
                self.setCardDisplay2.color = setCard.color;
                self.setCardDisplay2.shapeCount = setCard.shapeCount;
                self.setCardDisplay2.shape = setCard.shape;
                self.setCardDisplay2.fill = setCard.fill;
                self.setCardDisplay2.hidden = NO;
            }
            else if (self.game.match) {
                self.setCardDisplay3.color = setCard.color;
                self.setCardDisplay3.shapeCount = setCard.shapeCount;
                self.setCardDisplay3.shape = setCard.shape;
                self.setCardDisplay3.fill = setCard.fill;
                self.setCardDisplay3.hidden = NO;
                
                self.setCardMatchLabel.hidden = NO;
                self.setCardMatchLabel.text = @"MATCH!";
            }
            else if (!self.game.match) {
                self.setCardDisplay3.color = setCard.color;
                self.setCardDisplay3.shapeCount = setCard.shapeCount;
                self.setCardDisplay3.shape = setCard.shape;
                self.setCardDisplay3.fill = setCard.fill;
                self.setCardDisplay3.hidden = NO;
                
                self.setCardMatchLabel.hidden = NO;
                self.setCardMatchLabel.text = @"DON'T MATCH!";
            }
            else if (self.game.resetAfterMatch) {
                self.setCardDisplay1.color = setCard.color;
                self.setCardDisplay1.shapeCount = setCard.shapeCount;
                self.setCardDisplay1.shape = setCard.shape;
                self.setCardDisplay1.fill = setCard.fill;
                
                self.setCardDisplay2.hidden = YES;
                self.setCardDisplay3.hidden = YES;
                
                self.setCardMatchLabel.hidden = YES;
            }
            
        }
        [self updateUI];
    }
}

- (IBAction)redeal:(UIButton *)sender {
    
    self.game = nil;
    self.playingCardDisplay1.hidden = YES;
    self.playingCardDisplay2.hidden = YES;
    self.PCardMatchLabel.hidden = YES;
    
    self.setCardDisplay1.hidden = YES;
    self.setCardDisplay2.hidden = YES;
    self.setCardDisplay3.hidden = YES;
    self.setCardMatchLabel.hidden = YES;
    
    [self updateUI];
    [self.setCardCollectionView reloadData];

    self.scoreLabel.text = [NSString stringWithFormat:@"Score: 0"];
}

@end
