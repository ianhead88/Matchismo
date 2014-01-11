//
//  SetCard.m
//  Matchismo
//
//  Created by ian on 7/30/13.
//  Copyright (c) 2013 ian. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

+(NSArray *)validShapes
{
    return @[@"diamond",@"squiggle", @"oval"];
}

+(NSArray *)validColors
{
    return @[@"green",@"purple",@"red"];  
}

+(NSArray *)validFills
{
    return @[@"pattern",@"solid",@"empty"];  
}

-(void)setShape:(NSString *)shape
{
    if([[SetCard validShapes] containsObject:shape])
        _shape = shape;
}

-(void)setColor:(NSString *)color{
    
    if ([[SetCard validColors] containsObject:color])
        _color = color;
}

-(void)setFill:(NSString *)fill
{
    if ([[SetCard validFills] containsObject:fill])
        _fill = fill;
}

-(void)setShapeCount:(NSUInteger)shapeCount
{
    if (_shapeCount<=3)
        _shapeCount = shapeCount;
}

-(NSString *) contents
{
    NSString *shapeQty = @" ";
    
    if (self.shapeCount ==1) {
        shapeQty = self.shape;
    }
    else if (self.shapeCount ==2) {
        shapeQty = [self.shape stringByAppendingString:self.shape];
    }
    else if (self.shapeCount ==3) {
        shapeQty = [[self.shape stringByAppendingString:self.shape] stringByAppendingString:self.shape];
    }
    
    return shapeQty;
}

-(void)setOtherProperties:(NSMutableArray *)otherProperties
{
    [otherProperties addObject:self.color];
}

- (int)matchSet:(NSSet *)otherCards
{
    int score = 0;
    id otherCard = [otherCards anyObject];

    if ([otherCard isKindOfClass:[SetCard class]]) {
        NSArray *otherCardsArray = [otherCards allObjects];
        SetCard *firstCard = [otherCardsArray lastObject];
        NSMutableArray *mutableCopy1 = [[NSMutableArray alloc] initWithArray:otherCardsArray];
        [mutableCopy1 removeLastObject];
        SetCard *secondCard = [mutableCopy1 lastObject];
        NSMutableArray *mutableCopy2 = [[NSMutableArray alloc] initWithArray:mutableCopy1];
        [mutableCopy2 removeLastObject];
        SetCard *thirdCard = [mutableCopy2 lastObject];
        
        BOOL everything_the_same = 0;  //count   color  fill  shape
        BOOL everything_different = 0;
        BOOL two_and_two_count_and_color_same = 0;
        BOOL two_and_two_color_and_fill_same = 0;
        BOOL two_and_two_fill_and_shape_same = 0;
        BOOL two_and_two_shape_and_count_same = 0;
        BOOL two_and_two_count_and_fill_same = 0;
        BOOL two_and_two_color_and_shape_same = 0;
        BOOL three_same_count_different = 0;
        BOOL three_same_color_different = 0;
        BOOL three_same_fill_different = 0;
        BOOL three_same_shape_different = 0;
        BOOL three_diff_count_same = 0;
        BOOL three_diff_color_same = 0;
        BOOL three_diff_fill_same = 0;
        BOOL three_diff_shape_same = 0;
        
        //color different, shape same, count same, fill ??
        
        
        if (firstCard.shapeCount == secondCard.shapeCount && secondCard.shapeCount == thirdCard.shapeCount && [firstCard.color isEqualToString:secondCard.color] && [secondCard.color isEqualToString:thirdCard.color] && [firstCard.fill isEqualToString:secondCard.fill] && [secondCard.fill isEqualToString:thirdCard.fill] && [firstCard.shape isEqualToString:secondCard.shape] && [secondCard.shape isEqualToString:thirdCard.shape])
            everything_the_same = 1;
        else if (firstCard.shapeCount != secondCard.shapeCount && secondCard.shapeCount != thirdCard.shapeCount && firstCard.shapeCount != thirdCard.shapeCount && ![firstCard.color isEqualToString:secondCard.color] && ![secondCard.color isEqualToString:thirdCard.color] && ![firstCard.color isEqualToString:thirdCard.color] && ![firstCard.fill isEqualToString:secondCard.fill] && ![secondCard.fill isEqualToString:thirdCard.fill] && ![firstCard.fill isEqualToString:thirdCard.fill] && ![firstCard.shape isEqualToString:secondCard.shape] && ![secondCard.shape isEqualToString:thirdCard.shape] && ![firstCard.shape isEqualToString:thirdCard.shape])
            everything_different = 1;
        else if (firstCard.shapeCount == secondCard.shapeCount && secondCard.shapeCount == thirdCard.shapeCount && [firstCard.color isEqualToString:secondCard.color] && [secondCard.color isEqualToString:thirdCard.color] && ![firstCard.fill isEqualToString:secondCard.fill] && ![secondCard.fill isEqualToString:thirdCard.fill] && ![firstCard.fill isEqualToString:thirdCard.fill] && ![firstCard.shape isEqualToString:secondCard.shape] && ![secondCard.shape isEqualToString:thirdCard.shape] && ![firstCard.shape isEqualToString:thirdCard.shape])
            two_and_two_count_and_color_same = 1;
        else if (firstCard.shapeCount != secondCard.shapeCount && secondCard.shapeCount != thirdCard.shapeCount && firstCard.shapeCount != thirdCard.shapeCount && [firstCard.color isEqualToString:secondCard.color] && [secondCard.color isEqualToString:thirdCard.color] && [firstCard.fill isEqualToString:secondCard.fill] && [secondCard.fill isEqualToString:thirdCard.fill] && ![firstCard.shape isEqualToString:secondCard.shape] && ![secondCard.shape isEqualToString:thirdCard.shape] && [firstCard.shape isEqualToString:thirdCard.shape])
            two_and_two_color_and_fill_same = 1;
        else if (firstCard.shapeCount != secondCard.shapeCount && secondCard.shapeCount != thirdCard.shapeCount && firstCard.shapeCount != thirdCard.shapeCount && ![firstCard.color isEqualToString:secondCard.color] && ![secondCard.color isEqualToString:thirdCard.color] && ![firstCard.color isEqualToString:thirdCard.color] && [firstCard.fill isEqualToString:secondCard.fill] && [secondCard.fill isEqualToString:thirdCard.fill] && [firstCard.shape isEqualToString:secondCard.shape] && [secondCard.shape isEqualToString:thirdCard.shape])
            two_and_two_fill_and_shape_same = 1;
        else if (firstCard.shapeCount == secondCard.shapeCount && secondCard.shapeCount == thirdCard.shapeCount && ![firstCard.color isEqualToString:secondCard.color] && ![secondCard.color isEqualToString:thirdCard.color] && ![firstCard.color isEqualToString:thirdCard.color] && ![firstCard.fill isEqualToString:secondCard.fill] && ![secondCard.fill isEqualToString:thirdCard.fill] && ![firstCard.fill isEqualToString:thirdCard.fill] && [firstCard.shape isEqualToString:secondCard.shape] && [secondCard.shape isEqualToString:thirdCard.shape])
            two_and_two_shape_and_count_same = 1;
        else if (firstCard.shapeCount == secondCard.shapeCount && secondCard.shapeCount == thirdCard.shapeCount && ![firstCard.color isEqualToString:secondCard.color] && ![secondCard.color isEqualToString:thirdCard.color] && ![firstCard.color isEqualToString:thirdCard.color] && [firstCard.fill isEqualToString:secondCard.fill] && [secondCard.fill isEqualToString:thirdCard.fill] && ![firstCard.shape isEqualToString:secondCard.shape] && ![secondCard.shape isEqualToString:thirdCard.shape] && ![firstCard.shape isEqualToString:thirdCard.shape])
            two_and_two_count_and_fill_same = 1;
        else if (firstCard.shapeCount != secondCard.shapeCount && secondCard.shapeCount != thirdCard.shapeCount && firstCard.shapeCount != thirdCard.shapeCount && [firstCard.color isEqualToString:secondCard.color] && [secondCard.color isEqualToString:thirdCard.color] && ![firstCard.fill isEqualToString:secondCard.fill] && ![secondCard.fill isEqualToString:thirdCard.fill] && ![firstCard.fill isEqualToString:thirdCard.fill] && [firstCard.shape isEqualToString:secondCard.shape] && [secondCard.shape isEqualToString:thirdCard.shape])
            two_and_two_color_and_shape_same = 1;
        
        else if (firstCard.shapeCount != secondCard.shapeCount && secondCard.shapeCount != thirdCard.shapeCount && firstCard.shapeCount != thirdCard.shapeCount && [firstCard.color isEqualToString:secondCard.color] && [secondCard.color isEqualToString:thirdCard.color] && [firstCard.fill isEqualToString:secondCard.fill] && [secondCard.fill isEqualToString:thirdCard.fill] && [firstCard.shape isEqualToString:secondCard.shape] && [secondCard.shape isEqualToString:thirdCard.shape])
            three_same_count_different = 1;
        else if (firstCard.shapeCount == secondCard.shapeCount && secondCard.shapeCount == thirdCard.shapeCount && ![firstCard.color isEqualToString:secondCard.color] && ![secondCard.color isEqualToString:thirdCard.color] && ![firstCard.color isEqualToString:thirdCard.color] && [firstCard.fill isEqualToString:secondCard.fill] && [secondCard.fill isEqualToString:thirdCard.fill] && [firstCard.shape isEqualToString:secondCard.shape] && [secondCard.shape isEqualToString:thirdCard.shape])
            three_same_color_different = 1;
        else if (firstCard.shapeCount == secondCard.shapeCount && secondCard.shapeCount == thirdCard.shapeCount && [firstCard.color isEqualToString:secondCard.color] && [secondCard.color isEqualToString:thirdCard.color] && ![firstCard.fill isEqualToString:secondCard.fill] && ![secondCard.fill isEqualToString:thirdCard.fill] && ![firstCard.fill isEqualToString:thirdCard.fill] && [firstCard.shape isEqualToString:secondCard.shape] && [secondCard.shape isEqualToString:thirdCard.shape])
            three_same_fill_different = 1;
        else if (firstCard.shapeCount == secondCard.shapeCount && secondCard.shapeCount == thirdCard.shapeCount && [firstCard.color isEqualToString:secondCard.color] && [secondCard.color isEqualToString:thirdCard.color] && [firstCard.fill isEqualToString:secondCard.fill] && [secondCard.fill isEqualToString:thirdCard.fill] && ![firstCard.shape isEqualToString:secondCard.shape] && ![secondCard.shape isEqualToString:thirdCard.shape] && ![firstCard.shape isEqualToString:thirdCard.shape])
            three_same_shape_different = 1;
        
        else if (firstCard.shapeCount == secondCard.shapeCount && secondCard.shapeCount == thirdCard.shapeCount && ![firstCard.color isEqualToString:secondCard.color] && ![secondCard.color isEqualToString:thirdCard.color] && ![firstCard.color isEqualToString:thirdCard.color] && ![firstCard.fill isEqualToString:secondCard.fill] && ![secondCard.fill isEqualToString:thirdCard.fill] && ![firstCard.fill isEqualToString:thirdCard.fill] && ![firstCard.shape isEqualToString:secondCard.shape] && ![secondCard.shape isEqualToString:thirdCard.shape] && ![firstCard.shape isEqualToString:thirdCard.shape])
            three_diff_count_same = 1;
        else if (firstCard.shapeCount != secondCard.shapeCount && secondCard.shapeCount != thirdCard.shapeCount && firstCard.shapeCount != thirdCard.shapeCount && [firstCard.color isEqualToString:secondCard.color] && [secondCard.color isEqualToString:thirdCard.color] && ![firstCard.fill isEqualToString:secondCard.fill] && ![secondCard.fill isEqualToString:thirdCard.fill] && ![firstCard.fill isEqualToString:thirdCard.fill] && ![firstCard.shape isEqualToString:secondCard.shape] && ![secondCard.shape isEqualToString:thirdCard.shape] && ![firstCard.shape isEqualToString:thirdCard.shape])
            three_diff_color_same = 1;
        else if (firstCard.shapeCount != secondCard.shapeCount && secondCard.shapeCount != thirdCard.shapeCount && firstCard.shapeCount != thirdCard.shapeCount && ![firstCard.color isEqualToString:secondCard.color] && ![secondCard.color isEqualToString:thirdCard.color] && ![firstCard.color isEqualToString:thirdCard.color] && [firstCard.fill isEqualToString:secondCard.fill] && [secondCard.fill isEqualToString:thirdCard.fill] && ![firstCard.shape isEqualToString:secondCard.shape] && ![secondCard.shape isEqualToString:thirdCard.shape] && ![firstCard.shape isEqualToString:thirdCard.shape])
            three_diff_fill_same = 1;
        else if (firstCard.shapeCount != secondCard.shapeCount && secondCard.shapeCount != thirdCard.shapeCount && firstCard.shapeCount != thirdCard.shapeCount && ![firstCard.color isEqualToString:secondCard.color] && ![secondCard.color isEqualToString:thirdCard.color] && ![firstCard.color isEqualToString:thirdCard.color] && ![firstCard.fill isEqualToString:secondCard.fill] && ![secondCard.fill isEqualToString:thirdCard.fill] && ![firstCard.fill isEqualToString:thirdCard.fill] && [firstCard.shape isEqualToString:secondCard.shape] && [secondCard.shape isEqualToString:thirdCard.shape])
            three_diff_shape_same = 1;

        
        if (everything_the_same | everything_different | two_and_two_color_and_fill_same | two_and_two_color_and_shape_same |two_and_two_count_and_color_same | two_and_two_count_and_fill_same | two_and_two_fill_and_shape_same | two_and_two_shape_and_count_same | three_same_shape_different | three_same_fill_different | three_same_count_different | three_same_color_different | three_diff_count_same | three_diff_color_same | three_diff_fill_same | three_diff_shape_same)
            score = 200;
    }
    
    
    return score;
}

    @end
