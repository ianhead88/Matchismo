//
//  CardGameViewController.m
//  Matchismo
//
//  Created by ian on 7/3/13.
//  Copyright (c) 2013 ian. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"


@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipsLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (strong, nonatomic) CardMatchingGame *game;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusDisplay;
@property (weak, nonatomic) IBOutlet UIButton *redealButton;
@property (nonatomic) int selectorSwitch;
@property (weak, nonatomic) IBOutlet UISegmentedControl *selectorSwichLabel;

@end

@implementation CardGameViewController

-(CardMatchingGame *) game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count usingDeck:[[PlayingCardDeck alloc] init]];
 
    return _game;
}

-(void)setFlipCount:(int)flipCount
{
    _flipCount = flipCount;
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: %d", self.flipCount];
}


-(void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}

-(void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
    
        [cardButton setTitle:card.contents forState:UIControlStateSelected];
        [cardButton setTitle:card.contents forState:UIControlStateSelected|UIControlStateDisabled];
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0.3 : 1.0;
        
        if (cardButton.selected && !self.game.priorCard && !self.game.match)
            self.statusDisplay.text = [NSString stringWithFormat:@"Flipped up %@", [[self.game currentCard] contents]];
        
        else if (cardButton.selected && self.game.priorCard && self.game.match) {
            self.statusDisplay.text =
            [NSString stringWithFormat:@"Matched %@ & %@ for %d points",
              [[self.game currentCard] contents], [[self.game priorCard] contents], self.game.points];
            self.game.priorCard = nil;
        }
        else if (cardButton.selected && self.game.priorCard && !self.game.match) {
                self.statusDisplay.text =
                [NSString stringWithFormat:@"%@ and %@ don't match", [[self.game currentCard] contents], [[self.game priorCard] contents]];
                        
        }
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];
}


- (IBAction)flipCard:(UIButton *)sender
{
    self.selectorSwichLabel.enabled = 0;
    if (self.selectorSwitch == 1)
    [self.game flipTwoCardsAtIndex:[self.cardButtons indexOfObject:sender]];
    else
        [self.game flipCardAtIndex:[self.cardButtons indexOfObject:sender]];
    self.flipCount++;
    [self updateUI];
}

- (IBAction)redeal:(UIButton *)sender {
    
    self.selectorSwichLabel.enabled = 1;
    
    self.game = nil;
    
    for (UIButton *cardButton in self.cardButtons)
    {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        cardButton.selected = card.isFaceUp;
        cardButton.alpha = 1.0;
        cardButton.enabled = !card.isUnplayable;
    }
    
    self.statusDisplay.text = nil;
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: 0"];
    self.flipsLabel.text = [NSString stringWithFormat:@"Flips: 0"];
    self.flipCount = 0;
    
}
- (IBAction)gameMode:(UISegmentedControl *)sender {
    
    self.selectorSwitch = sender.selectedSegmentIndex;
}

@end
