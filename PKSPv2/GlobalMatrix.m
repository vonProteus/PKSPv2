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
    NSMutableArray *HTmp = [[NSMutableArray alloc] init];
    HYNames = [[NSMutableDictionary alloc] init];
    HXNames = [[NSMutableDictionary alloc] init];

    NSInteger i = 0;
    for (Nodes* n in [coreData allNodes]) {
        [HYNames setValue:[NSNumber numberWithInteger:i] forKey:[n.number stringValue]];
        [HXNames setValue:[NSNumber numberWithInteger:i] forKey:[n.number stringValue]];
        ++i;
    }
    
//    H2 = (double **) NewPtr(i*sizeof(double*));

    
    
    for (int a = 0; a < [HYNames count]; ++a) {
        [HTmp addObject:[[NSMutableArray alloc] init]];
//        H2[a] = (double *) NewPtr(i*sizeof(double));
        for (int b = 0; b < [HXNames count]; ++b) {
//            H2[a][b] = 0;
            [[HTmp objectAtIndex:a] addObject:[[NSNumber alloc] initWithDouble:0.0]];
        }
    }
    {
        NSString* stringTMP = [NSString stringWithFormat:@"HYNames = %@ \n HXNames = %@\n", HYNames, HXNames];
        DLog(@"%@",stringTMP);
    }

    H = [[NSArray alloc] initWithArray:HTmp copyItems:YES];
    return self;
}


- (void) add:(double)Value 
         ToX:(NSUInteger)X 
        AndY:(NSUInteger)Y{
    
    double prevValue = [self getValueFromX:X 
                                      AndY:Y];
    double setThisValue = Value + prevValue;
    [self set:setThisValue
          ToX:X 
         AndY:Y];
    double nowIsValue = [self getValueFromX:X 
                                       AndY:Y];
    if (nowIsValue != setThisValue) {
        {
            NSString* stringTMP = [NSString stringWithFormat:@"dupa\n"];
            DLog(@"%@",stringTMP);
        }

    }

}

- (double) getValueFromX:(NSUInteger)X 
                    AndY:(NSUInteger)Y{
    double r = 0;
    NSString *stringY = [[NSNumber numberWithUnsignedInteger:Y] stringValue];
    NSInteger lineName = [[HYNames objectForKey:stringY] integerValue];
    
    NSString *stringX = [[NSNumber numberWithUnsignedInteger:Y] stringValue];
    NSInteger columnName = [[HXNames objectForKey:stringX] integerValue];
    
    r = [[[H objectAtIndex:lineName] objectAtIndex:columnName] doubleValue];
//    {
//        NSString* stringTMP = [NSString stringWithFormat:@"[%i,%i] r = %f\n",X,Y,r];
//        DLog(@"%@",stringTMP);
//    }

//    r = H2[Y][X];
        
    return r;
}

- (void) set:(double)Value 
         ToX:(NSUInteger)X 
        AndY:(NSUInteger)Y{
    NSString *stringY = [[NSNumber numberWithUnsignedInteger:Y] stringValue];
    NSInteger lineName = [[HYNames objectForKey:stringY] integerValue];
    
    NSString *stringX = [[NSNumber numberWithUnsignedInteger:Y] stringValue];
    NSInteger columnName = [[HXNames objectForKey:stringX] integerValue];
    
    {
        NSString* stringTMP = [NSString stringWithFormat:@"%f\n",Value];
        DLog(@"%@",stringTMP);
    }

    
    NSNumber* numberValue = [[NSNumber alloc ] initWithDouble:Value];
    
    NSMutableArray *line = [H objectAtIndex:lineName];
    
    
    {
        NSString* stringTMP = [NSString stringWithFormat:@"%@\n", line];
        DLog(@"%@",stringTMP);
    }

    [line removeObjectAtIndex:columnName];
    
    [line insertObject:numberValue 
               atIndex:columnName];
    
    {
        NSString* stringTMP = [NSString stringWithFormat:@"%@\n", line];
        DLog(@"%@",stringTMP);
    }
//    [[H objectAtIndex:lineName] replaceObjectAtIndex:columnName 
//                                          withObject:numberValue];
    if (Value != [self getValueFromX:X AndY:Y]) {
        {
            NSString* stringTMP = [NSString stringWithFormat:@"dupa1\n"];
            DLog(@"%@",stringTMP);
        }

    }

//    H2[Y][X] = Value;
    
    
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
            {
                double doubleTMP = [[line objectAtIndex:x] doubleValue]; 
                NSString* stringTMP = [NSString stringWithFormat:@"[%i,%i] %f\n",x,y, doubleTMP];
                DLog(@"%@",stringTMP);
            }
            
//            {
//                NSString* stringTMP = [NSString stringWithFormat:@"%f\n", [[line objectAtIndex:x] doubleValue]];
//                DLog(@"%@",stringTMP);
//            }


        }
    }    
}


-(void) addByNumberOfNodeValue:(double)Value 
                       ToNode1:(NSUInteger)X 
                      AndNode2:(NSUInteger)Y{
    
    NSString *stringY = [[NSNumber numberWithUnsignedInteger:Y] stringValue];
    NSInteger lineName = [[HYNames objectForKey:stringY] integerValue];
    
    NSString *stringX = [[NSNumber numberWithUnsignedInteger:Y] stringValue];
    NSInteger columnName = [[HXNames objectForKey:stringX] integerValue];
    
    double newValue = [self getValueFromRealX:columnName 
                                     AndRealY:lineName];
    newValue += Value;
    
    [self setValue:newValue 
           ToRealX:columnName 
          AndRealY:lineName];
    
    

    
}


- (double) getValueFromRealX:(NSUInteger)X 
                    AndRealY:(NSUInteger)Y{
    double r = 0;
       
    r = [[[H objectAtIndex:Y] objectAtIndex:X] doubleValue];
    //    {
    //        NSString* stringTMP = [NSString stringWithFormat:@"[%i,%i] r = %f\n",X,Y,r];
    //        DLog(@"%@",stringTMP);
    //    }
    
    //    r = H2[Y][X];
    
    return r;
}

- (void) setValue:(double)Value 
          ToRealX:(NSUInteger)X 
         AndRealY:(NSUInteger)Y{
    
    NSNumber *numberValue = [NSNumber numberWithDouble:Value];
    
    NSMutableArray *HMutable = [H mutableCopy];
    NSMutableArray *lineMutable = [[H objectAtIndex:Y] mutableCopy];
    
    [lineMutable replaceObjectAtIndex:X withObject:numberValue];
    
    [HMutable replaceObjectAtIndex:Y withObject:lineMutable];
    
    H;
    
    H = [[NSArray alloc] initWithArray:HMutable];
    
//    [(NSMutableArray*)[H objectAtIndex:Y] replaceObjectAtIndex:X withObject:numberValue];
    
//    {
//        NSString* stringTMP = [NSString stringWithFormat:@"X = %ld Y = %ld Value = %f %f\n", X, Y, Value, [self getValueFromRealX:X AndRealY:Y]];
//        DLog(@"%@",stringTMP);
//    }

    
    
}



@end
