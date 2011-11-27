//
//  GlobalMatrix.m
//  PKSPv2
//
//  Created by Maciej Krok on 2011-11-26.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "GlobalMatrix.h"

@implementation GlobalMatrix

-(id) init{
    coreData = [CDModel sharedModel];
    H = [[NSMutableArray alloc] init];
    HYNames = [[NSMutableDictionary alloc] init];
    HXNames = [[NSMutableDictionary alloc] init];

    NSInteger i = 0;
    for (Nodes* n in [coreData allNodes]) {
        [HYNames setValue:[NSNumber numberWithInteger:i] forKey:[n.number stringValue]];
        [HXNames setValue:[NSNumber numberWithInteger:i] forKey:[n.number stringValue]];
        ++i;
    }
    
    
    
    
    for (int a = 0; a < [HYNames count]; ++a) {
        [H addObject:[[NSMutableArray alloc] init]];
        for (int b = 0; b < [HXNames count]; ++b) {
            [[H objectAtIndex:a] addObject:[[NSNumber alloc] initWithDouble:0.0]];
        }
    }
    return self;
}


- (void) add:(double)Value 
         ToX:(NSUInteger)X 
        AndY:(NSUInteger)Y{
   [self set:Value + [self getValueFromX:X 
                                    AndY:Y] 
          ToX:X 
         AndY:Y];
}

- (double) getValueFromX:(NSUInteger)X 
                    AndY:(NSUInteger)Y{
    double r = 0;
    NSString *stringY = [[NSNumber numberWithUnsignedInteger:Y] stringValue];
    NSInteger lineName = [[HYNames objectForKey:stringY] integerValue];
    
    NSString *stringX = [[NSNumber numberWithUnsignedInteger:Y] stringValue];
    NSInteger columnName = [[HXNames objectForKey:stringX] integerValue];
    
    
    r = [[[H objectAtIndex:lineName] objectAtIndex:columnName] doubleValue];
        
    return r;
}

- (void) set:(double)Value 
         ToX:(NSUInteger)X 
        AndY:(NSUInteger)Y{
    NSString *stringY = [[NSNumber numberWithUnsignedInteger:Y] stringValue];
    NSInteger lineName = [[HYNames objectForKey:stringY] integerValue];
    
    NSString *stringX = [[NSNumber numberWithUnsignedInteger:Y] stringValue];
    NSInteger columnName = [[HXNames objectForKey:stringX] integerValue];
    
       
    [[H objectAtIndex:lineName] replaceObjectAtIndex:columnName 
                                          withObject:[NSNumber numberWithDouble:Value]];
 
}


- (void) fillGlobalMatrix{
    for (Elements *e in [coreData allElements]) {
        [e addSelfToGlobal:self andK:8];
    }
}




-(void) dlog{
    for (NSNumber* numberY in HYNames) {
        for (NSNumber* numberX in HXNames) {
            {
                NSString* stringTMP = [NSString stringWithFormat:@"[%i,%i] %f\n", 
                                       [numberX intValue], 
                                       [numberY intValue], 
                                       [self getValueFromX:[numberX integerValue] 
                                                      AndY:[numberY integerValue]]];
                DLog(@"%@",stringTMP);
            }
        }
    }
    
}

-(void) dlog2{
    for (int y = 0; y < [H count]; ++y) {
        NSMutableArray* line = [H objectAtIndex:y];
        for (int x = 0; x < [line count]; ++x) {
//            {
//                NSString* stringTMP = [NSString stringWithFormat:@"[%i,%i] %f\n",x,y,[[line objectAtIndex:x] doubleValue]];
//                DLog(@"%@",stringTMP);
//            }
            
            {
                NSString* stringTMP = [NSString stringWithFormat:@"%f\n", [[line objectAtIndex:x] doubleValue]];
                DLog(@"%@",stringTMP);
            }


        }
    }    
}



@end
