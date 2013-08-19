//
//  Card.h
//  Matchismo
//
//  Created by ian on 7/3/13.
//  Copyright (c) 2013 ian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property (strong, nonatomic) NSString *contents;
@property (strong, nonatomic) NSMutableArray *otherProperties;

@property (nonatomic, getter = isFaceUp) BOOL faceUp;
@property (nonatomic, getter = isUnplayable) BOOL unplayable;



- (int)match:(NSArray *)otherCards;
- (int)matchSet:(NSSet *)otherCards;

@end
