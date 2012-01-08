//
//  Elements+Metods.h
//  PKSPv2
//
//  Created by Maciej Krok on 2011-11-26.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Elements.h"
@class GlobalMatrix;

struct Si
{
    double A;
    double B;
    double C;
};

@interface Elements (Metods)
-(void) dlog;
-(double) detForMatrixFromPoint1:(Nodes*) matrixPoint1
                          point2:(Nodes*) matrixPoint2 
                       andPoint3:(Nodes*) matrixPoint3; 

-(void) addSelfToGlobal:(GlobalMatrix*)ThisMatrix 
                   andK:(double)k;
-(double) getTempAtPoint:(NSPoint)p;
-(BOOL) pointIsInPolyhon:(NSPoint)p;
-(NSPoint) getMinValueOfXY;
-(NSPoint) getMaxValueOfXY;

-(struct Si) getS:(Nodes*)n;
-(NSInteger) getLocalNumberForNode:(Nodes*)n;

@end
