//
//  SetGameViewController.m
//  Matchismo
//
//  Created by ian on 7/30/13.
//  Copyright (c) 2013 ian. All rights reserved.
//

#import "SetGameViewController.h"
#import "CardMatchingGame.h"
#import "SetDeck.h"
#import "SetCard.h"

@interface SetGameViewController ()
@property (strong, nonatomic) CardMatchingGame *game;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;


@end

@implementation SetGameViewController



-(CardMatchingGame *) game
{
    if (!_game) _game = [[CardMatchingGame alloc] initWithCardCount:60 usingDeck:[[SetDeck alloc] init]];
    
    return _game;
}

-(void)setCardButtons:(NSArray *)cardButtons
{
    _cardButtons = cardButtons;
    [self updateUI];
}
- (IBAction)flipCard:(UIButton *)sender {
    [self.game flipTwoCardsAtIndex:[self.cardButtons indexOfObject:sender]];
    [self updateUI];
}

-(NSAttributedString *)setDisplayContents:(Card *)card
{
    NSAttributedString *displayContents = [[NSAttributedString alloc] initWithString:card.contents];
    
    if ([[card.otherProperties objectAtIndex:0] isEqualToString:@"red"] &&
        [[card.otherProperties objectAtIndex:1] isEqualToString:@"solid"]) {
        displayContents = [[NSAttributedString alloc] initWithString:card.contents attributes:
                           @{NSFontAttributeName:[UIFont systemFontOfSize:20],
                                      NSForegroundColorAttributeName: [UIColor redColor]}];        
    }
    else if ([[card.otherProperties objectAtIndex:0] isEqualToString:@"red"] &&
             [[card.otherProperties objectAtIndex:1] isEqualToString:@"empty"]) {
        displayContents = [[NSAttributedString alloc] initWithString:card.contents attributes:
                           @{NSFontAttributeName:[UIFont systemFontOfSize:20],
                                          NSStrokeColorAttributeName: [UIColor redColor],
                                          NSStrokeWidthAttributeName: @10}];        
    }
    else if ([[card.otherProperties objectAtIndex:0] isEqualToString:@"red"] &&
             [[card.otherProperties objectAtIndex:1] isEqualToString:@"pattern"]) {
        displayContents = [[NSAttributedString alloc] initWithString:card.contents attributes:
                           @{NSFontAttributeName:[UIFont systemFontOfSize:20],
                                      NSForegroundColorAttributeName:[UIColor colorWithPatternImage:[UIImage imageNamed:@"redstripe.png"]]}];
    }
    else if ([[card.otherProperties objectAtIndex:0] isEqualToString:@"blue"] &&
             [[card.otherProperties objectAtIndex:1] isEqualToString:@"solid"]) {
        displayContents = [[NSAttributedString alloc] initWithString:card.contents attributes:
                           @{NSFontAttributeName:[UIFont systemFontOfSize:20],
                                      NSForegroundColorAttributeName: [UIColor blueColor]}];
    }
    else if ([[card.otherProperties objectAtIndex:0] isEqualToString:@"blue"] &&
             [[card.otherProperties objectAtIndex:1] isEqualToString:@"empty"]) {
        displayContents = [[NSAttributedString alloc] initWithString:card.contents attributes:
                           @{NSFontAttributeName:[UIFont systemFontOfSize:20],
                                          NSStrokeColorAttributeName: [UIColor blueColor],
                                          NSStrokeWidthAttributeName: @10}];
    }
    else if ([[card.otherProperties objectAtIndex:0] isEqualToString:@"blue"] &&
             [[card.otherProperties objectAtIndex:1] isEqualToString:@"pattern"]) {
        displayContents = [[NSAttributedString alloc] initWithString:card.contents attributes:
                           @{NSFontAttributeName:[UIFont systemFontOfSize:20],
                                      NSForegroundColorAttributeName:[UIColor colorWithPatternImage:[UIImage imageNamed:@"bluestripe.png"]]}];
    }
    else if ([[card.otherProperties objectAtIndex:0] isEqualToString:@"green"] &&
             [[card.otherProperties objectAtIndex:1] isEqualToString:@"solid"]) {
        displayContents = [[NSAttributedString alloc] initWithString:card.contents attributes:
                           @{NSFontAttributeName:[UIFont systemFontOfSize:20],
                                      NSForegroundColorAttributeName: [UIColor greenColor]}];
    }
    else if ([[card.otherProperties objectAtIndex:0] isEqualToString:@"green"] &&
             [[card.otherProperties objectAtIndex:1] isEqualToString:@"empty"]) {
        displayContents = [[NSAttributedString alloc] initWithString:card.contents attributes:
                           @{NSFontAttributeName:[UIFont systemFontOfSize:20],
                                          NSStrokeColorAttributeName: [UIColor greenColor],
                                          NSStrokeWidthAttributeName: @10}];
    }
    else if ([[card.otherProperties objectAtIndex:0] isEqualToString:@"green"] &&
             [[card.otherProperties objectAtIndex:1] isEqualToString:@"pattern"]) {
        displayContents = [[NSAttributedString alloc] initWithString:card.contents attributes:
                           @{NSFontAttributeName:[UIFont systemFontOfSize:20],
                                      NSForegroundColorAttributeName:[UIColor colorWithPatternImage:[UIImage imageNamed:@"greenstripe.png"]]}];

    }
return displayContents;
}


-(void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        Card *card = [self.game cardAtIndex:[self.cardButtons indexOfObject:cardButton]];
        
        cardButton.selected = card.isFaceUp;
        cardButton.enabled = !card.isUnplayable;
        cardButton.alpha = card.isUnplayable ? 0 : 1.0;
        
        [cardButton setAttributedTitle:[self setDisplayContents:card] forState:UIControlStateNormal];
        [cardButton setAttributedTitle:[self setDisplayContents:card] forState:UIControlStateNormal|UIControlStateDisabled];
        
        NSMutableAttributedString *label = [[NSMutableAttributedString alloc] initWithAttributedString:[self setDisplayContents:card]];
        NSAttributedString *andSign = [[NSAttributedString alloc] initWithString:@" & "];
        NSAttributedString *match = [[NSAttributedString alloc] initWithString:@" Match!"];
        NSAttributedString *nomatch = [[NSAttributedString alloc] initWithString:@" Don't Match"];

        if (cardButton.selected && !self.game.priorCard && !self.game.match)
            self.statusLabel.attributedText = label;
        
        else if (cardButton.selected && self.game.priorCard && self.game.match) {
            NSMutableAttributedString *label1 = [[NSMutableAttributedString alloc] initWithAttributedString:[self setDisplayContents:[self.game priorCard]]];
            NSMutableAttributedString *label2 = [[NSMutableAttributedString alloc] initWithAttributedString:[self setDisplayContents:[self.game priorPriorCard]]];
            [label1 appendAttributedString:andSign];
            [label1 appendAttributedString:label2];
            [label1 appendAttributedString:andSign];
            [label1 appendAttributedString:label];
            [label1 appendAttributedString:match];
            self.game.priorPriorCard = nil;
            self.game.priorCard = nil;

            self.statusLabel.attributedText = label1;
        }
        
            else if (cardButton.selected && self.game.priorCard && !self.game.match) {
                NSMutableAttributedString *label1 = [[NSMutableAttributedString alloc] initWithAttributedString:[self setDisplayContents:[self.game priorCard]]];
                NSMutableAttributedString *label2 = [[NSMutableAttributedString alloc] initWithAttributedString:[self setDisplayContents:[self.game priorPriorCard]]];
                [label1 appendAttributedString:andSign];
                [label1 appendAttributedString:label2];
                [label1 appendAttributedString:andSign];
                [label1 appendAttributedString:label];
                [label1 appendAttributedString:nomatch];
                self.game.priorPriorCard = nil;
                self.game.priorCard = nil;
                
                self.statusLabel.attributedText = label1;

            }
            
    }
    
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %d", self.game.score];

}



@end
