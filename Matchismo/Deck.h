//
//  Deck.h
//  Matchismo
//
//  Created by ian on 7/3/13.
//  Copyright (c) 2013 ian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface Deck : NSObject

@property (strong, nonatomic) NSMutableArray *cards;

-(void)addCard:(Card *)card atTop:(BOOL)atTop;
-(Card *)drawRandomCard;


@end
