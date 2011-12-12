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
#include "PlistConf.h"

@implementation Mesh
@synthesize numberOfPointsToAdd;
@synthesize bounds;
@synthesize nodeSizeX, nodeSizeY;

-(id) init{
    coreData = [CDModel sharedModel];
    n = [[coreData allNodes] count];
	polygon = (NSPoint *) calloc(n, sizeof(NSPoint));
    self.numberOfPointsToAdd = [[PlistConf valueForKey:@"numberOfPointsToAdd"] unsignedIntegerValue];
    self.nodeSizeX =  [[PlistConf valueForKey:@"nodeSizeX"] unsignedIntegerValue];
    self.nodeSizeY =  [[PlistConf valueForKey:@"nodeSizeY"] unsignedIntegerValue];
    
    {
        NSString* stringTMP = [NSString stringWithFormat:@"nsx %ld nsy %ld class %@\n", self.nodeSizeX, self.nodeSizeY, [PlistConf valueForKey:@"test"]];
        DLog(@"%@",stringTMP);
    }

    
    
    
    
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
    
//    [self dlogPolygon];
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
                Nodes* newNode = [coreData getNodeWithX:x 
                                                   andY:y 
                                                    inR:[[PlistConf valueForKey:@"rOfNode"] doubleValue]*3];
                if (newNode == Nil) {
                    newNode = [coreData addNewNode];
                    newNode.x = [NSNumber numberWithDouble:x];
                    newNode.y = [NSNumber numberWithDouble:y];
                }
            }
        }
    }
}


-(void) bildElements{
    DelaunayTriangulation *triangulation = [DelaunayTriangulation triangulation];
    NSArray* nodes = [coreData allNodes];
    Nodes* n = nil;
    double maxLenghtOfEadge = [[PlistConf valueForKey:@"maxLenghtOfEadge"] doubleValue];
    maxLenghtOfEadge *= maxLenghtOfEadge;

    for (NSUInteger a = 0; a < [nodes count]; ++a) {
        n = (Nodes*)[nodes objectAtIndex:a];
        
        double x = [n.x doubleValue];
        double y = [n.y doubleValue];
        
        DelaunayPoint *dP = [DelaunayPoint pointAtX:x 
                                               andY:y];
        
        [triangulation addPoint:dP];
    }
    
    for (DelaunayTriangle* t in triangulation.triangles) {
        NSUInteger a = 0;
        
        
        DelaunayPoint *p1 = Nil;
        DelaunayPoint *p2 = Nil;
        DelaunayPoint *p3 = Nil;
        DelaunayPoint *pTest = Nil;
        
        for (DelaunayPoint *pTmp in t.points) {
            switch (a) {
                case 0:
                    p1 = pTmp;
                    break;
                case 1:
                    p2 = pTmp;
                    break;
                case 2:
                    p3 = pTmp;
                    break;
                default:
                {
                    NSString* stringTMP = [NSString stringWithFormat:@"coś nie tak\n"];
                    DLog(@"%@",stringTMP);
                }
                    
                    break;
            }
            ++a;
            
        }
        
        
        if ([self distanceFromP1:[p1 nsPointValue] toP2:[p2 nsPointValue]] >= maxLenghtOfEadge) {
            continue;
        }
        
        if ([self distanceFromP1:[p2 nsPointValue] toP2:[p3 nsPointValue]] >= maxLenghtOfEadge) {
            continue;
        }
        
        if ([self distanceFromP1:[p1 nsPointValue] toP2:[p3 nsPointValue]] >= maxLenghtOfEadge) {
            continue;
        }
        
        
        pTest = p1;
        if (pTest.x >= 40000 || pTest.x == 0 || pTest.y >= 40000 || pTest.y == 0) {
            continue;
        }
        Nodes *n1 = [coreData getOrCreateNodeWithX:pTest.x andY:pTest.y];
//        [n1 dlog];
        
        
        pTest = p2;
        if (pTest.x >= 40000 || pTest.x == 0 || pTest.y >= 40000 || pTest.y == 0) {
            continue;
        }
        Nodes *n2 = [coreData getOrCreateNodeWithX:pTest.x andY:pTest.y];
//        [n2 dlog];
        
        pTest = p3;
        if (pTest.x >= 40000 || pTest.x == 0 || pTest.y >= 40000 || pTest.y == 0) {
            continue;
        }
        Nodes *n3 = [coreData getOrCreateNodeWithX:pTest.x
                                              andY:pTest.y];
//        [n3 dlog];
        
        
        [coreData makeElementFromNode1:n1 
                                 Node2:n2 
                                 Node3:n3];
        {
            NSString* stringTMP = [NSString stringWithFormat:@"dodano element\n"];
            DLog(@"%@",stringTMP);
        }

        
        [coreData saveCD];
    }
    
}

-(double) distanceFromP1:(NSPoint)p1 
                    toP2:(NSPoint)p2{
    NSPoint delta = NSMakePoint(p2.x - p1.x, p2.y - p1.y);
    return ((delta.x*delta.x) + (delta.y*delta.y));
}



@end
