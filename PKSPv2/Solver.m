//
//  Solver.m
//  PKSPv2
//
//  Created by Maciej Krok on 2011-11-26.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Solver.h"

@implementation Solver

-(id) init{
    self = [super init];
    coreDara = [CDModel sharedModel];
    return self;
}

-(id) initWirhCDData{
    self = [self init];
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
    {
        NSString* stringTMP = [NSString stringWithFormat:@"real lefr site :%ld\n", [matrix realLeftSite]];
        DLog(@"%@",stringTMP);
    }

    DLog(@"test: start gaus\n");
    [matrix gauss3];
    DLog(@"test: stop gaus\n");
}

-(void) dlogMatrix{
    [matrix dlog];
}

-(void) addBC2ForNode1:(NSUInteger)node1 
              andNode2:(NSUInteger)node2 
                  qVal:(double)q{
    Nodes* n1 = [coreDara getNodeWithNumber:node1];
    Nodes* n2 = [coreDara getNodeWithNumber:node2];
    NSPoint p1 = [n1 pointValue];
    NSPoint p2 = [n2 pointValue];
    Elements* e1 = nil;
    Elements* e2 = nil;
    
    NSPoint d = NSMakePoint(p2.x -p1.x, p2.y-p1.y);
    NSPoint s = NSMakePoint((p2.x+p1.x)/2, (p2.y+p1.y)/2);
    
    for (Elements* elem in n1.inElements) {
        if (elem.n1.number == n2.number) {
            if (e1 == nil) {
                e1 = elem;
            } else {
                e2 = elem;
            }
        }
        if (elem.n2.number == n2.number) {
            if (e1 == nil) {
                e1 = elem;
            } else {
                e2 = elem;
            }
        }
        if (elem.n3.number == n2.number) {
            if (e1 == nil) {
                e1 = elem;
            } else {
                e2 = elem;
            }
        }
    }
    
    
    if (p1.y == p2.y) {
        struct Si s1e1 = [e1 getS:n1];
        double sde1 = [e1 detForMatrixFromPoint1:e1.n1 point2:e1.n2 andPoint3:e1.n3];
        
        double val1 = (sqrt(1+(d.y/d.x)*(d.y/d.x))/sde1)*(d.x*(s1e1.B*s.x + s1e1.C + s1e1.A*p1.y)+ s1e1.A*d.y*(s.x-p1.x));
        
        struct Si s2e1 = [e1 getS:n2];
        //    double sde1 = [e1 detForMatrixFromPoint1:e1.n1 point2:e1.n2 andPoint3:e1.n3];
        
        double val2 = (sqrt(1+(d.y/d.x)*(d.y/d.x))/sde1)*(d.x*(s2e1.B*s.x + s2e1.C + s2e1.A*p1.y)+ s2e1.A*d.y*(s.x-p1.x));
        
        [matrix addBC2ForNodeNumber:(NSInteger)n1.number 
                             andVal:val1];
        [matrix addBC2ForNodeNumber:(NSInteger)n2.number 
                             andVal:val2];

    
        return;
    }
    
    if (p1.x == p2.x) {
        
        
        return;
    }
    
    struct Si s1e1 = [e1 getS:n1];
    double sde1 = [e1 detForMatrixFromPoint1:e1.n1 point2:e1.n2 andPoint3:e1.n3];
  
    double val1 = (sqrt(1+(d.y/d.x)*(d.y/d.x))/sde1)*(d.x*(s1e1.B*s.x + s1e1.C + s1e1.A*p1.y)+ s1e1.A*d.y*(s.x-p1.x));
    
    struct Si s2e1 = [e1 getS:n2];
//    double sde1 = [e1 detForMatrixFromPoint1:e1.n1 point2:e1.n2 andPoint3:e1.n3];
    
    double val2 = (sqrt(1+(d.y/d.x)*(d.y/d.x))/sde1)*(d.x*(s2e1.B*s.x + s2e1.C + s2e1.A*p1.y)+ s2e1.A*d.y*(s.x-p1.x));
    
    [matrix addBC2ForNodeNumber:(NSInteger)n1.number 
                         andVal:val1];
    [matrix addBC2ForNodeNumber:(NSInteger)n2.number 
                         andVal:val2];
    
}

@end
