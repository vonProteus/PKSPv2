//
//  Solver.h
//  PKSPv2
//
//  Created by Maciej Krok on 2011-11-26.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GlobalMatrix.h"
#import "CDModel.h"

@interface Solver : NSObject{
    GlobalMatrix* matrix;
}
-(id) initWirhCDData;
-(void) addBC1ForNode:(NSUInteger)node 
                value:(double)temp;
-(void) addBC2ForNode1:(NSUInteger)node1 
              andNode2:(NSUInteger)node2 
                  qVal:(double)q;
-(void) solve;

-(void) dlogMatrix;

@end
