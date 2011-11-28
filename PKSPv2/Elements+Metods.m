//
//  Elements+Metods.m
//  PKSPv2
//
//  Created by Maciej Krok on 2011-11-26.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Elements+Metods.h"
#import "GlobalMatrix.h"

@implementation Elements (Metods)

-(void) dlog{
    DLog(@"-----------");
    DLog(@"n1 %i", [self.n1.number intValue]);
    DLog(@"n2 %i", [self.n2.number intValue]);
    DLog(@"n3 %i", [self.n3.number intValue]);
}

- (double) detForMatrixFromPoint1:(Nodes *)matrixPoint1 
                           point2:(Nodes *)matrixPoint2 
                        andPoint3:(Nodes *)matrixPoint3{
    
    
    return  [matrixPoint1.x doubleValue]*[matrixPoint2.y doubleValue] - [matrixPoint3.y doubleValue]*[matrixPoint1.x doubleValue] +
    [matrixPoint1.y doubleValue]*[matrixPoint3.x doubleValue] - [matrixPoint2.x doubleValue]*[matrixPoint1.y doubleValue]+
    [matrixPoint2.x doubleValue]*[matrixPoint3.y doubleValue] - [matrixPoint3.x doubleValue]*[matrixPoint2.y doubleValue];
}

-(void)addSelfToGlobal:(GlobalMatrix*)ThisMatrix
                  andK:(double)k{
    double h = k/(4*0.5f*[self detForMatrixFromPoint1:self.n1 point2:self.n2 andPoint3:self.n3]);
    
//    [self dlog];
    
    NSPoint p1 = NSMakePoint([self.n1.x doubleValue], [self.n1.y doubleValue]);
    NSPoint p2 = NSMakePoint([self.n2.x doubleValue], [self.n2.y doubleValue]);
    NSPoint p3 = NSMakePoint([self.n3.x doubleValue], [self.n3.y doubleValue]);
    
    
    double h11 = h*((p2.y-p3.y)*(p2.y-p3.y)+(p3.x-p2.x)*(p3.x-p2.x));
    double h12 = h*((p2.y-p3.y)*(p3.y-p1.y)+(p3.x-p2.x)*(p1.x-p3.x));
    double h13 = h*((p2.y-p3.y)*(p1.y-p2.y)+(p3.x-p2.x)*(p2.x-p1.x));
    double h21 = h*((p3.y-p1.y)*(p2.y-p3.y)+(p1.x-p3.x)*(p3.x-p2.x));
    double h22 = h*((p3.y-p1.y)*(p3.y-p1.y)+(p1.x-p3.x)*(p1.x-p3.x));
    double h23 = h*((p3.y-p1.y)*(p1.y-p2.y)+(p1.x-p3.x)*(p2.x-p1.x));
    double h31 = h*((p1.y-p2.y)*(p2.y-p3.y)+(p2.x-p1.x)*(p3.x-p2.x));
    double h32 = h*((p1.y-p2.y)*(p3.y-p1.y)+(p2.x-p1.x)*(p1.x-p3.x));
    double h33 = h*((p1.y-p2.y)*(p1.y-p2.y)+(p2.x-p1.x)*(p2.x-p1.x));
    
//    {
//        NSString* stringTMP = [NSString stringWithFormat:@"%f %f %f %f %f %f %f %f %f\n", h11, h12, h13, h21, h22, h23, h31, h32, h33];
//        DLog(@"%@",stringTMP);
//    }

    
    [ThisMatrix dlog2];
    
    
    [ThisMatrix addByNumberOfNodeValue:h11 
                               ToNode1:[self.n1.number unsignedIntegerValue] 
                              AndNode2:[self.n1.number unsignedIntegerValue]];
    [ThisMatrix addByNumberOfNodeValue:h12 
                               ToNode1:[self.n1.number unsignedIntegerValue] 
                              AndNode2:[self.n2.number unsignedIntegerValue]];
    [ThisMatrix addByNumberOfNodeValue:h13 
                               ToNode1:[self.n1.number unsignedIntegerValue] 
                              AndNode2:[self.n3.number unsignedIntegerValue]];
    [ThisMatrix addByNumberOfNodeValue:h21 
                               ToNode1:[self.n2.number unsignedIntegerValue] 
                              AndNode2:[self.n1.number unsignedIntegerValue]];
    [ThisMatrix addByNumberOfNodeValue:h22 
                               ToNode1:[self.n2.number unsignedIntegerValue] 
                              AndNode2:[self.n2.number unsignedIntegerValue]];
    [ThisMatrix addByNumberOfNodeValue:h23 
                               ToNode1:[self.n2.number unsignedIntegerValue] 
                              AndNode2:[self.n3.number unsignedIntegerValue]];
    [ThisMatrix addByNumberOfNodeValue:h31 
                               ToNode1:[self.n3.number unsignedIntegerValue] 
                              AndNode2:[self.n1.number unsignedIntegerValue]];
    [ThisMatrix addByNumberOfNodeValue:h32 
                               ToNode1:[self.n3.number unsignedIntegerValue] 
                              AndNode2:[self.n2.number unsignedIntegerValue]];
    [ThisMatrix addByNumberOfNodeValue:h33 
                               ToNode1:[self.n3.number unsignedIntegerValue] 
                              AndNode2:[self.n3.number unsignedIntegerValue]];
    
    [ThisMatrix dlog2];
}



@end
