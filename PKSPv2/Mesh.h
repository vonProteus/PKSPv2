//
//  Mesh.h
//  PKSPv2
//
//  Created by Maciej Krok on 2011-12-04.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "CDModel.h"

@interface Mesh : NSObject{
    CDModel* coreData;
    NSPoint *polygon;
    NSUInteger n;
    
}
@property (assign) NSUInteger numberOfPointsToAdd;
@property (assign) NSRect bounds;
@property (assign) NSUInteger nodeSizeX, nodeSizeY;

-(void) go;
-(void) dlogPolygon;
-(BOOL) pointIsInPolyhon:(NSPoint)p;
-(void) sizeMash;
-(void) randMesh;
-(void) bildElements;


-(double) distanceFromP1:(NSPoint)p1 
                    toP2:(NSPoint)p2;

@end
