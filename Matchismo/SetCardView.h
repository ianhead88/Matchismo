//
//  SetCardView.h
//  SuperCard
//
//  Created by ian on 8/19/13.
//  Copyright (c) 2013 ian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView

@property (strong, nonatomic) NSString *shape;
@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) NSString *fill;
@property (nonatomic) NSUInteger shapeCount;

@property (nonatomic) BOOL faceUp;


@end
