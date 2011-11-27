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
    
    {
        NSString* stringTMP = [NSString stringWithFormat:@"%f %f %f %f %f %f %f %f %f\n", h11, h12, h13, h21, h22, h23, h31, h32, h33];
        DLog(@"%@",stringTMP);
    }

    
    [ThisMatrix add:h11 
                ToX:[self.n1.number unsignedIntegerValue] 
               AndY:[self.n1.number unsignedIntegerValue]];
    [ThisMatrix add:h12 
                ToX:[self.n1.number unsignedIntegerValue] 
               AndY:[self.n2.number unsignedIntegerValue]];
    [ThisMatrix add:h13 
                ToX:[self.n1.number unsignedIntegerValue] 
               AndY:[self.n3.number unsignedIntegerValue]];
    [ThisMatrix add:h21 
                ToX:[self.n2.number unsignedIntegerValue] 
               AndY:[self.n1.number unsignedIntegerValue]];
    [ThisMatrix add:h22 
                ToX:[self.n2.number unsignedIntegerValue] 
               AndY:[self.n2.number unsignedIntegerValue]];
    [ThisMatrix add:h23 
                ToX:[self.n2.number unsignedIntegerValue] 
               AndY:[self.n3.number unsignedIntegerValue]];
    [ThisMatrix add:h31 
                ToX:[self.n3.number unsignedIntegerValue] 
               AndY:[self.n1.number unsignedIntegerValue]];
    [ThisMatrix add:h32 
                ToX:[self.n3.number unsignedIntegerValue] 
               AndY:[self.n2.number unsignedIntegerValue]];
    [ThisMatrix add:h33 
                ToX:[self.n3.number unsignedIntegerValue] 
               AndY:[self.n3.number unsignedIntegerValue]];
}



@end
