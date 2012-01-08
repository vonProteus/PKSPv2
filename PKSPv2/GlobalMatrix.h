//
//  GlobalMatrix.h
//  PKSPv2
//
//  Created by Maciej Krok on 2011-11-26.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDModel.h"


@interface GlobalMatrix : NSObject {
    NSMutableArray* H;
    NSMutableDictionary* HXNames;
    NSMutableDictionary* HXNamesRevers;
    NSMutableDictionary* HYNames;
    CDModel* coreData;
}
- (id)init;

- (void) fillGlobalMatrix;

- (void) startAddingBC;

- (void) addBC1ForNodeNumber:(NSUInteger)nodeNumber 
                      andVal:(double)val;

- (void) addBC2ForNodeNumber1:(NSUInteger)nodeNumber1 
               andNodeNumber2:(NSUInteger)nodeNumber2 
                      andVal:(double)val;

- (void) addBC2ForNodeNumber:(NSUInteger)nodeNumber 
                      andVal:(double)val;
//
//- (void) gaussTempV:(MyVector*)tempVec 
//              andPV:(MyVector*)PVec;

- (void) dlog;
- (void) dlog2;
- (void) dlogNames;  

- (void) addByNumberOfNodeValue:(double)Value 
                        ToNode1:(NSUInteger)X 
                       AndNode2:(NSUInteger)Y;

- (double) getValueFromRealX:(NSUInteger)X 
                    AndRealY:(NSUInteger)Y;

- (void) setValue:(double)Value 
          ToRealX:(NSUInteger)X 
         AndRealY:(NSUInteger)Y;

- (NSUInteger) convertNodeNumberToRealX:(NSUInteger)n;
- (NSUInteger) convertNodeNumberToRealY:(NSUInteger)n;


- (NSUInteger) realLeftSite;

- (void) swapRealLine1:(NSUInteger)lineA 
          andRealLine2:(NSUInteger)lineB;

- (void) odejmijOdRealLine1:(NSUInteger)lineA 
                  realLine2:(NSUInteger)lineB
               withKvocient:(double)kvocient;

- (void) podzielRealLine:(NSUInteger)lineNumber 
             przezDouble:(double)dziel;

- (void) gauss;
- (void) gauss2;
- (void) gauss3;

-(NSUInteger) getNodeNumberFromRealX:(NSUInteger)X;

@end
