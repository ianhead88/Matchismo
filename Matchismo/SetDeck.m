//
//  SetDeck.m
//  Matchismo
//
//  Created by ian on 7/30/13.
//  Copyright (c) 2013 ian. All rights reserved.
//

#import "SetDeck.h"
#import "SetCard.h"

@implementation SetDeck

-(id)init
{
    self = [super init];
    
    if (self) {
        for (NSString *color in [SetCard validColors]) {
            for (NSString *shape in [SetCard validShapes]) {
                for (NSString *fill in [SetCard validFills]) {
                    for (NSUInteger count = 1; count <= 3; count++) {
                        SetCard *card = [[SetCard alloc] init];
                        card.color = color;
                        card.shape = shape;
                        card.fill = fill;
                        card.shapeCount = count;
                        NSArray *prop = @[color, fill];
                        [card.otherProperties addObjectsFromArray:prop];
                        [self addCard:card atTop:YES];
                        
                    }
                }
            }
        }
    }
    return self;
}

@end
