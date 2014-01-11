//
//  SetCardView.m
//  SuperCard
//
//  Created by ian on 8/19/13.
//  Copyright (c) 2013 ian. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

#define SYMBOL_PERCENT_OF_CARD_HEIGHT 0.25
#define PERCENT_OF_SYMBOL_HEIGHT_SHIFT 1.2
#define SYMBOL_PERCENT_OF_WIDTH 0.7
#define SET_CARD_SQUIGGLE_WIDTH_ADJUST_FOR_CURVES (0.9f)
#define SET_CARD_SQUIGGLE_HEIGHT_ADJUST_FOR_CURVES (0.66f)
#define STRIPE_EVERY_N_PERCENT (0.04f)
#define STRIPE_WIDTH 1.0

// how much the squiggle's parallelogram is pushed over in the x direction
// ex: p3 is to the right of p1 by TWICE this pshift value
#define SET_CARD_SQUIGGLE_PARALLELOGRAM_HALF_SHIFT_PERCENT (0.05f)
#define SET_CARD_SQUIGGLE_PARALLELOGRAM_CONTROL_POINT_SCALE_PERCENT (0.3f)

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

#pragma SETTERS

-(void)setColor:(NSString *)color
{
    _color = color;
    [self setNeedsDisplay];
    
}

-(void)setShape:(NSString *)shape
{
    _shape = shape;
    [self setNeedsDisplay];
}

-(void)setFill:(NSString *)fill
{
    _fill = fill;
    [self setNeedsDisplay];
}

-(void)setShapeCount:(NSUInteger)shapeCount
{
        _shapeCount = shapeCount;
        [self setNeedsDisplay];
    
}

-(void)setFaceUp:(BOOL)faceUp
{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

#pragma mark - Initialization

-(void)setup
{
    //do initialization here
}

-(void)awakeFromNib
{
    [self setup];
}

-(id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

#define CORNER_RADIUS_RATIO 0.08



- (void)drawRect:(CGRect)rect
{
    //this section draws the basic outline for a card
    
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:self.bounds.size.width * CORNER_RADIUS_RATIO];
    
    [roundedRect addClip];
    [[UIColor whiteColor] setFill];
    UIRectFill(self.bounds);
    
    [[UIColor blackColor] setStroke];
    [roundedRect stroke];
    
    [self positionDrawing:rect];
}

-(void)positionDrawing:(CGRect)rect
{
    NSMutableArray *heights = [[NSMutableArray alloc]init];
    
    if (self.shapeCount == 1)
        [heights addObject:[NSNumber numberWithFloat:0.0f]];
    
    if (self.shapeCount == 2) {
        [heights addObject:[NSNumber numberWithFloat:[self halfOfShapeHeight]*PERCENT_OF_SYMBOL_HEIGHT_SHIFT]];
        [heights addObject:[NSNumber numberWithFloat:-[self halfOfShapeHeight]*PERCENT_OF_SYMBOL_HEIGHT_SHIFT]];
    }
    
    if (self.shapeCount == 3) {
        [heights addObject:[NSNumber numberWithFloat:0.0f]];
        [heights addObject:[NSNumber numberWithFloat:[self shapeHeight]* PERCENT_OF_SYMBOL_HEIGHT_SHIFT]];
        [heights addObject:[NSNumber numberWithFloat:-[self shapeHeight]* PERCENT_OF_SYMBOL_HEIGHT_SHIFT]];
    }
    
    for (NSNumber *num in heights) {
    
        CGPoint centerPoint = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2 + [num floatValue]);
        
        if ([self.shape isEqualToString:@"diamond"])
            [self drawDiamondAtPoint:centerPoint];
        
        if ([self.shape isEqualToString:@"squiggle"])
            [self drawSquiggleAtPoint:centerPoint];
        
        if ([self.shape isEqualToString:@"oval"])
            [self drawOvalAtPoint:centerPoint];
    }
    
}

-(void)drawDiamondAtPoint:(CGPoint)centerPoint
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
    
    UIBezierPath *path = [[UIBezierPath alloc]init];
    
    [path moveToPoint:CGPointMake(-[self halfOfShapeWidth], 0)];
    [path addLineToPoint:CGPointMake(0, [self halfOfShapeHeight])];
    [path addLineToPoint:CGPointMake([self halfOfShapeWidth], 0)];
    [path addLineToPoint:CGPointMake(0, -[self halfOfShapeHeight])];
    [path closePath];
    
    [self paintPath:path];
    CGContextRestoreGState(context);
    
}

-(void)drawSquiggleAtPoint:(CGPoint)centerPoint
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
    
    UIBezierPath *path = [[UIBezierPath alloc]init];

    
    // for a squiggle, we have four points, arranged in a parallelogram
    // clockwise, from top left, top right, bottom right, bottom left, they're called p1 p2 p3 p4
    // the parallelogram has a width and a height, but because our origin is in the centre
    // we often need half these values: let's call these half values pwidth and pheight
    
    CGFloat pwidth  = [self halfOfShapeWidth] * SET_CARD_SQUIGGLE_WIDTH_ADJUST_FOR_CURVES;
    CGFloat pheight = [self halfOfShapeHeight]* SET_CARD_SQUIGGLE_HEIGHT_ADJUST_FOR_CURVES;
    
    // the parallelogram has another value - pshift - which is how much it is slanted
    // i.e. how much it is pushed over in the x direction
    //    e.g. p3 is to the right of p1 by TWICE this pshift value
    
    CGFloat pshift = [self halfOfShapeWidth] * SET_CARD_SQUIGGLE_PARALLELOGRAM_HALF_SHIFT_PERCENT;
    
    CGPoint p1, p2, p3, p4;
    p1 = CGPointMake(-pwidth-pshift, -pheight);
    p2 = CGPointMake( pwidth-pshift, -pheight);
    
    p3 = CGPointMake( pwidth+pshift,  pheight);
    p4 = CGPointMake(-pwidth+pshift,  pheight);
    
    // then we have the control points for the curves (cp1, cp2, ...)
    // there are two kinds of curves: the horizontal waves
    //                                and the vertical ends
    
    // horizontal wave: the control points for p1 is 45 degrees up   and right of p1
    // horizontal wave: the control points for p2 is 45 degrees down and left  of p2
    
    // vertical end: the control points for p2 is 45 degrees right and up of p2
    // vertical end: the control points for p3 is 45 degrees right and up of p3
    
    // the length of the control point vector (between p1 and cp1) is proportional to the height/width
    // this is the same value for both x and the y because we're using 45 degrees
    CGFloat controlPointOffset = [self halfOfShapeWidth] * SET_CARD_SQUIGGLE_PARALLELOGRAM_CONTROL_POINT_SCALE_PERCENT;
    
    [path moveToPoint:p1];
    // top
    [path addCurveToPoint:p2
            controlPoint1:CGPointMake(p1.x+controlPointOffset, p1.y-controlPointOffset)
            controlPoint2:CGPointMake(p2.x-controlPointOffset, p2.y+controlPointOffset)];
    // rhs
    [path addCurveToPoint:p3
            controlPoint1:CGPointMake(p2.x+controlPointOffset, p2.y-controlPointOffset)
            controlPoint2:CGPointMake(p3.x+controlPointOffset, p3.y-controlPointOffset)];
    // bottom
    [path addCurveToPoint:p4
            controlPoint1:CGPointMake(p3.x-controlPointOffset, p3.y+controlPointOffset)
            controlPoint2:CGPointMake(p4.x+controlPointOffset, p4.y-controlPointOffset)];
    // lhs
    [path addCurveToPoint:p1
            controlPoint1:CGPointMake(p4.x-controlPointOffset, p4.y+controlPointOffset)
            controlPoint2:CGPointMake(p1.x-controlPointOffset, p1.y+controlPointOffset)];
    [path closePath];
    
    [self paintPath:path];
    CGContextRestoreGState(context);
}

-(void)drawOvalAtPoint:(CGPoint)centerPoint
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, centerPoint.x, centerPoint.y);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(-[self halfOfShapeWidth], -[self halfOfShapeHeight],
                                                                            [self shapeWidth],      [self shapeHeight])
                                                    cornerRadius:[self halfOfShapeWidth]];
    [self paintPath:path];
    CGContextRestoreGState(context);
}

-(void)paintPath:(UIBezierPath *)path
{
    if ([self.fill isEqualToString:@"solid"]) {
        [[self symbolUIColor] setFill];
        [path fill];
    }
    else if ([self.fill isEqualToString:@"empty"]) {
        [[self symbolUIColor] setStroke];
        [path stroke];
    }
    else if ([self.fill isEqualToString:@"pattern"]) {
        
        [[self symbolUIColor] setStroke];
        [path stroke];
        [path addClip];
        
        //draw dashed line from left to right
        
        CGContextRef context = UIGraphicsGetCurrentContext();
        UIBezierPath *stripes = [[UIBezierPath alloc]init];
        
        CGFloat dashes[] = {STRIPE_WIDTH, roundl(self.bounds.size.width * STRIPE_EVERY_N_PERCENT)};
        CGContextSetLineDash(context, 0.0, dashes, 2);
        
        [stripes setLineWidth:path.bounds.size.height];
        
        [stripes moveToPoint:CGPointMake(-path.bounds.size.width, 0)];
        [stripes addLineToPoint:CGPointMake(path.bounds.size.width, 0)];
        
        [stripes stroke];
    }
}

-(UIColor *)symbolUIColor
{
    if ([self.color isEqualToString:@"red"]) 
        return [UIColor colorWithRed:1.0 green:0.0 blue:(128.0/255.0) alpha:1.0];
    else if ([self.color isEqualToString:@"green"])
        return [UIColor colorWithRed:0.262 green:0.83 blue:0.3 alpha:1.0];
    else if ([self.color isEqualToString:@"purple"])
        return [UIColor colorWithRed:(204.0/255.0) green:(102.0/255.0) blue:(1.0) alpha:1.0];
    else return [UIColor blackColor];
}


-(CGFloat) shapeHeight
{
    return self.bounds.size.height * SYMBOL_PERCENT_OF_CARD_HEIGHT;
}

-(CGFloat)halfOfShapeHeight
{
    return [self shapeHeight]/2;
}

-(CGFloat) shapeWidth
{
    return self.bounds.size.width * SYMBOL_PERCENT_OF_WIDTH;
}

-(CGFloat) halfOfShapeWidth
{
    return [self shapeWidth]/2;
}


@end






