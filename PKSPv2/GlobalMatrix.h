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
//    double** H2;
    NSMutableDictionary* HXNames;
    NSMutableDictionary* HYNames;
    CDModel* coreData;
}
- (id)init;

- (void) add:(double)Value 
         ToX:(NSUInteger)X 
        AndY:(NSUInteger)Y;

- (double) getValueFromX:(NSUInteger)X 
                    AndY:(NSUInteger)Y;

- (void) set:(double)Value 
         ToX:(NSUInteger)X 
        AndY:(NSUInteger)Y;

- (void) fillGlobalMatrix;

//- (void) addBC1For:(NSUInteger)X 
//            andVal:(double)val 
//          andTempV:(MyVector*)tempVec 
//             andPV:(MyVector*)PVec;
//
//- (void) gaussTempV:(MyVector*)tempVec 
//              andPV:(MyVector*)PVec;
//
//- (void) swapX:(NSUInteger)a 
//         andX1:(NSUInteger)b;
//
- (void) dlog;
- (void) dlog2;

- (void) addByNumberOfNodeValue:(double)Value 
                        ToNode1:(NSUInteger)X 
                       AndNode2:(NSUInteger)Y;




@end
