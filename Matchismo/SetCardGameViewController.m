//
//  SetCardGameViewController.m
//  Matchismo
//
//  Created by ian on 8/21/13.
//  Copyright (c) 2013 ian. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetDeck.h"
#import "SetCardCollectionViewCell.h"
#import "SetCard.h"

@interface SetCardGameViewController ()
@property (weak, nonatomic) IBOutlet UIButton *deal3;

@end

@implementation SetCardGameViewController

-(NSString *)giveReuseID
{
    return @"SetCard";
}

- (Deck *)createDeck
{
    return [[SetDeck alloc] init];
}

-(NSUInteger) startingCardCount
{
    return 12;
}
- (IBAction)deal3:(UIButton *)sender {
    
    if (self.game.cardsLeftinDeck >= 4) {
    
        for (int i=1; i<=3; i++) {
            [self.game addCardToGame];
            [self.setCardCollectionView insertItemsAtIndexPaths:@[[NSIndexPath indexPathForItem:[self.game numberOfCards]-1 inSection:0]]];
        }
        [self.setCardCollectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:[self.game numberOfCards]-1 inSection:0]
                                           atScrollPosition:UICollectionViewScrollPositionBottom animated:YES];
        [self.setCardCollectionView reloadData];
    }
    else self.deal3.alpha = 0.3;
}

-(void)updateCell:(UICollectionViewCell *)cell usingCard:(Card *)card
{
    if ([cell isKindOfClass:[SetCardCollectionViewCell class]]) {
        SetCardView *setCardView = ((SetCardCollectionViewCell *)cell).setCardView;
        
        if ([card isKindOfClass:[SetCard class]]) {
            SetCard *setCard = (SetCard *)card;
        
            setCardView.color = setCard.color;
            setCardView.shape = setCard.shape;
            setCardView.fill = setCard.fill;
            setCardView.shapeCount = setCard.shapeCount;
            setCardView.faceUp = setCard.isFaceUp;
        }
    }
}


@end
