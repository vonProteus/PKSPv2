//
//  DelaunayTriangle.h
//  DelaunayTest
//
//  Created by Mike Rotondo on 7/17/11.
//  Copyright 2011 Stanford. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DelaunayPoint;
@class DelaunayEdge;
@class DelaunayTriangulation;

@interface DelaunayTriangle : NSObject {
    CFArrayRef nonretainingEdges;
    DelaunayPoint *startPoint;
    NSColor *color;
}

@property (nonatomic, assign) NSArray *edges;
@property (nonatomic, retain) DelaunayPoint *startPoint;
@property (nonatomic, retain) NSColor *color;
@property (nonatomic, retain) NSArray *cachedPoints;
@property (nonatomic, readonly) NSArray *points;

+ (DelaunayTriangle *) triangleWithEdges:(NSArray *)edges andStartPoint:(DelaunayPoint *)startPoint andColor:(NSColor *)color;
- (BOOL)containsPoint:(DelaunayPoint *)point;
- (NSPoint)circumcenter;
- (BOOL)inFrameTriangleOfTriangulation:(DelaunayTriangulation *)triangulation;
- (void)remove;
- (void)drawInContext:(CGContextRef)ctx;
- (NSSet *)neighbors;
- (DelaunayPoint *)pointNotInEdge:(DelaunayEdge *)edge;
- (DelaunayEdge *)edgeStartingWithPoint:(DelaunayPoint *)point;
- (DelaunayEdge *)edgeEndingWithPoint:(DelaunayPoint *)point;
- (DelaunayPoint *)startPointOfEdge:(DelaunayEdge *)edgeInQuestion;
- (DelaunayPoint *)endPointOfEdge:(DelaunayEdge *)edgeInQuestion;

- (BOOL)isEqual:(id)object;
- (NSUInteger)hash;

- (void)print;

@end
