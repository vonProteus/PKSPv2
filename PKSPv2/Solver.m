//
//  Solver.m
//  PKSPv2
//
//  Created by Maciej Krok on 2011-11-26.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Solver.h"

@implementation Solver

-(id) initWirhCDData{
    matrix = [[GlobalMatrix alloc] init];
    [matrix fillGlobalMatrix];
    [matrix startAddingBC];
    
    return self;
}

-(void) addBC1ForNode:(NSUInteger)node 
                value:(double)temp{
    [matrix addBC1ForNodeNumber:node
                         andVal:temp];
}

-(void) solve{
    [matrix gauss2];
}

-(void) dlogMatrix{
    [matrix dlog];
}

-(void) addBC2ForNode1:(NSUInteger)node1 
              andNode2:(NSUInteger)node2 
                  qVal:(double)q{
    
}

@end
