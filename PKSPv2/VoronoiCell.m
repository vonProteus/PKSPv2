//
//  VoronoiCell.m
//  DelaunayTest
//
//  Created by Mike Rotondo on 7/21/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import "VoronoiCell.h"
#import "DelaunayPoint.h"

@implementation VoronoiCell
@synthesize site;
@synthesize nodes;

+ (VoronoiCell *)voronoiCellAtSite:(DelaunayPoint *)site withNodes:(NSArray *)nodes
{
    VoronoiCell *cell = [[self alloc] init];
    
    cell.site = site;
    cell.nodes = nodes;
    
    return cell;
}

- (void)dealloc
{

}

- (void)drawInContext:(CGContextRef)ctx
{
    NSValue *prevPoint = [self.nodes lastObject];
    NSPoint p = [prevPoint pointValue];
    CGContextMoveToPoint(ctx, p.x, p.y);
    for ( NSValue *point in self.nodes)
    {
        NSPoint p = [point pointValue];
        CGContextAddLineToPoint(ctx, p.x, p.y);        
    }
}

- (float)area
{
    float xys = 0.0;
    float yxs = 0.0;
    
    NSValue *prevPoint = [self.nodes objectAtIndex:0];
    NSPoint prevP = [prevPoint pointValue];
    for ( NSValue *point in [self.nodes reverseObjectEnumerator])
    {
        NSPoint p = [point pointValue];
        xys += prevP.x * p.y;
        yxs += prevP.y * p.x;
        prevP = p;
    }
    
    return (xys - yxs) * 0.5;
}

@end
