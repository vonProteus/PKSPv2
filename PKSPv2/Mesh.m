//
//  Mesh.m
//  PKSPv2
//
//  Created by Maciej Krok on 2011-12-04.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Mesh.h"
#import "DelaunayTriangle.h"
#import "DelaunayPoint.h"
#import "DelaunayTriangulation.h"

@implementation Mesh
@synthesize numberOfPointsToAdd;
@synthesize bounds;
@synthesize nodeSizeX, nodeSizeY;

-(id) init{
    coreData = [CDModel sharedModel];
    n = [[coreData allNodes] count];
	polygon = (NSPoint *) calloc(n, sizeof(NSPoint));
    self.numberOfPointsToAdd = 100;
    self.nodeSizeX = 50;
    self.nodeSizeY = 50;
    
    
    
    
    NSArray *sorted = [[coreData allNodes] sortedArrayUsingComparator:^(id obj1, id obj2){
        
        if ([obj1 isKindOfClass:[Nodes class]] && [obj2 isKindOfClass:[Nodes class]]) {
            Nodes *n1 = (Nodes*)obj1;
            Nodes *n2 = (Nodes*)obj2;
            
            if ([n1.number unsignedIntegerValue] > [n2.number unsignedIntegerValue]) {
                return (NSComparisonResult)NSOrderedAscending;
            } else if ([n1.number unsignedIntegerValue] < [n2.number unsignedIntegerValue]) {
                return (NSComparisonResult)NSOrderedDescending;
            }
        }
        
        // TODO: default is the same?
        {
            NSString* stringTMP = [NSString stringWithFormat:@"sort err default is the same\n"];
            DLog(@"%@",stringTMP);
        }
        
        return (NSComparisonResult)NSOrderedSame;
    }];
    
    
    
	for(NSUInteger i = 0; i < n; ++i){
        Nodes* n = [sorted objectAtIndex:i];
        polygon[i] = [n pointValue];
    }
    
    {
        NSString* stringTMP = [NSString stringWithFormat:@"ok\n"];
        DLog(@"%@",stringTMP);
    }
    
    return self;
}

-(void) go{
    
    [self dlogPolygon];
    [self sizeMash];
    [self bildElements];
    [coreData saveCD];
    
}


-(void) dlogPolygon{
    for (NSUInteger a = 0; a < n; ++a) {
        {
            NSString* stringTMP = [NSString stringWithFormat:@"%ld: (%f,%f)\n", a, polygon[a].x, polygon[a].y];
            DLog(@"%@",stringTMP);
        }
    }
}


-(BOOL) pointIsInPolyhon:(NSPoint)p{
    
    NSUInteger counter = 0;
    NSUInteger i;
    double xinters;
    NSPoint p1,p2;
    
    p1 = polygon[0];
    for (i=1;i<=n;i++) {
        p2 = polygon[i % n];
        if (p.y > MIN(p1.y,p2.y)) {
            if (p.y <= MAX(p1.y,p2.y)) {
                if (p.x <= MAX(p1.x,p2.x)) {
                    if (p1.y != p2.y) {
                        xinters = (p.y-p1.y)*(p2.x-p1.x)/(p2.y-p1.y)+p1.x;
                        if (p1.x == p2.x || p.x <= xinters)
                            counter++;
                    }
                }
            }
        }
        p1 = p2;
    }
    
    if (counter % 2 == 0)
        return NO;
    else
        return YES;
    
}

-(void) randMesh{
    double rangeX = bounds.size.width;
    double rangeY = bounds.size.height;
    double maxRand = (double) RAND_MAX;
    
    for (NSUInteger numberOfPointAdded = 0; numberOfPointAdded < numberOfPointsToAdd;) {
        double x = (arc4random()/maxRand)*rangeX;
        double y = (arc4random()/maxRand)*rangeY;
        NSPoint p = NSMakePoint(x, y);
        
        if ([self pointIsInPolyhon:p]) {
            numberOfPointAdded++;
            Nodes* newNode = [coreData addNewNode];
            newNode.x = [NSNumber numberWithDouble:x];
            newNode.y = [NSNumber numberWithDouble:y];
        }
        
    }
}

-(void) sizeMash{
    for (NSUInteger x = 0; x < self.bounds.size.width; x += nodeSizeX) {
        for (NSUInteger y = 0; y < self.bounds.size.height; y += nodeSizeY) {
            NSPoint p = NSMakePoint(x, y);
            
            if ([self pointIsInPolyhon:p]) {
                Nodes* newNode = [coreData addNewNode];
                newNode.x = [NSNumber numberWithDouble:x];
                newNode.y = [NSNumber numberWithDouble:y];
            }
        }
    }
}


-(void) bildElements{
    DelaunayTriangulation *triangulation = [DelaunayTriangulation triangulation];
    
    for (Nodes* n in [coreData allNodes]) {
        [triangulation addPoint:<#(DelaunayPoint *)#>]
    }
    
}

-(double) distanceFromP1:(NSPoint)p1 
                    toP2:(NSPoint)p2{
    NSPoint delta = NSMakePoint(p2.x - p1.x, p2.y - p1.y);
    return ((delta.x*delta.x) + (delta.y*delta.y));
}



@end
