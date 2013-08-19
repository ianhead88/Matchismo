//
//  SetCard.h
//  Matchismo
//
//  Created by ian on 7/30/13.
//  Copyright (c) 2013 ian. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

@property (strong, nonatomic) NSString *shape;
@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) NSString *fill;
@property (nonatomic) NSUInteger shapeCount;


+(NSArray *)validShapes;
+(NSArray *)validColors;
+(NSArray *)validFills;


@end
