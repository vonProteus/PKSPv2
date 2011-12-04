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
    HXNamesRevers = [[NSMutableDictionary alloc] init];

    NSInteger i = 0;
    for (Nodes* n in [coreData allNodes]) {
        [HYNames setValue:[NSNumber numberWithInteger:i] forKey:[n.number stringValue]];
        [HXNames setValue:[NSNumber numberWithInteger:i] forKey:[n.number stringValue]];
        [HXNamesRevers setValue:[n.number copy] forKey:[[NSNumber numberWithInteger:i] stringValue]];
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




- (void) fillGlobalMatrix{
    for (Elements *e in [coreData allElements]) {
        [e addSelfToGlobal:self andK:8];
    }
    
}




-(void) dlog{
    for (NSNumber* numberY in HYNames) {
        for (NSNumber* numberX in HXNames) {
            NSUInteger realX = [self convertNodeNumberToRealX:[numberX integerValue]];
            NSUInteger realY = [self convertNodeNumberToRealY:[numberY integerValue]];
            
            
            {
                NSString* stringTMP = [NSString stringWithFormat:@"[%ld,%ld] %f\n", 
                                       [numberX integerValue], 
                                       [numberY integerValue], 
                                       [self getValueFromRealX:realX 
                                                      AndRealY:realY]];
                DLog(@"%@",stringTMP);
            }
        }
    }
    
}

-(void) dlog2{
    
    {
        NSString* stringTMP = [NSString stringWithFormat:@"start======================\n"];
        DLog(@"%@",stringTMP);
    }

    for (NSUInteger y = 0; y < [H count]; ++y) {
        NSMutableArray* line = [H objectAtIndex:y];
        for (NSUInteger x = 0; x < [line count]; ++x) {
            {
                double doubleTMP = [[line objectAtIndex:x] doubleValue]; 
                NSString* stringTMP = [NSString stringWithFormat:@"[%ld,%ld] %f\n",x,y, doubleTMP];
                DLog(@"%@",stringTMP);
            }
            
        }
        
        {
            NSString* stringTMP = [NSString stringWithFormat:@"-----\n"];
            DLog(@"%@",stringTMP);
        }

    }    
    
    {
        NSString* stringTMP = [NSString stringWithFormat:@"end========================\n"];
        DLog(@"%@",stringTMP);
    }

}


-(void) addByNumberOfNodeValue:(double)Value 
                       ToNode1:(NSUInteger)X 
                      AndNode2:(NSUInteger)Y{
    
    
    NSInteger lineName = [self convertNodeNumberToRealY:Y];
    NSInteger columnName = [self convertNodeNumberToRealX:X];
    
    double newValue = [self getValueFromRealX:columnName 
                                     AndRealY:lineName];
    newValue += Value;
    
    [self setValue:newValue 
           ToRealX:columnName 
          AndRealY:lineName];
    
//    {
//        NSString* stringTMP = [NSString stringWithFormat:@"add %f to (%ld,%ld) [%ld,%ld]\n",Value,X,Y,columnName,lineName];
//        DLog(@"%@",stringTMP);
//    }

    
    

    
}


- (double) getValueFromRealX:(NSUInteger)X 
                    AndRealY:(NSUInteger)Y{
    double r = 0;
       
    r = [[[H objectAtIndex:Y] objectAtIndex:X] doubleValue];
    return r;
}

- (void) setValue:(double)Value 
          ToRealX:(NSUInteger)X 
         AndRealY:(NSUInteger)Y{
    
    NSNumber *numberValue = [NSNumber numberWithDouble:Value];
    
    [[H objectAtIndex:Y] replaceObjectAtIndex:X withObject:numberValue];
}

-(NSUInteger) convertNodeNumberToRealX:(NSUInteger)n{
    NSString *stringX = [[NSNumber numberWithUnsignedInteger:n] stringValue];
    NSInteger columnName = [[HXNames objectForKey:stringX] integerValue];
    
    return columnName;    
}



-(NSUInteger) convertNodeNumberToRealY:(NSUInteger)n{
    NSString *stringY = [[NSNumber numberWithUnsignedInteger:n] stringValue];
    NSInteger lineName = [[HYNames objectForKey:stringY] integerValue];
    
    return lineName;
}



-(void) startAddingBC{
    NSInteger max = 0;
    for (NSNumber* number in HXNames) {
        if ([number integerValue] >= max) {
            max = [number integerValue];
        }
    }
    
//    {
//        NSString* stringTMP = [NSString stringWithFormat:@"%ld\n", [[H objectAtIndex:0] count]];
//        DLog(@"%@",stringTMP);
//    }

    
//    ++max;
    [HXNames setValue:[NSNumber numberWithInteger:max] 
               forKey:@"LeftSite"];
    for (NSMutableArray* line in H) {
        [line addObject:[NSNumber numberWithDouble:0.0]];
    }
//    {
//        NSString* stringTMP = [NSString stringWithFormat:@"%ld\n", [[H objectAtIndex:0] count]];
//        DLog(@"%@",stringTMP);
//    }
//    
//    {
//        NSString* stringTMP = [NSString stringWithFormat:@"HYNames = %@ \n HXNames = %@\n", HYNames, HXNames];
//        DLog(@"%@",stringTMP);
//    }
}

-(void) addBC1ForNodeNumber:(NSUInteger)nodeNumber 
                     andVal:(double)val{
    NSUInteger lineName = [self convertNodeNumberToRealY:nodeNumber];
    
    NSMutableArray* line = [H objectAtIndex:lineName];
    
    for (int a = 0; a < [line count]; ++a) {
        [line replaceObjectAtIndex:a withObject:[NSNumber numberWithDouble:0.0]];
    }
    
    NSInteger columnName = [self convertNodeNumberToRealX:nodeNumber];
    NSInteger lsName = [self realLeftSite];
    
    
    [line replaceObjectAtIndex:lsName withObject:[NSNumber numberWithDouble:val]];
//    [line insertObject:[NSNumber numberWithDouble:val] atIndex:lsName];
    [line replaceObjectAtIndex:columnName withObject:[NSNumber numberWithDouble:1.0]];
    
}

-(NSUInteger) realLeftSite{
    return [[HXNames valueForKey:@"LeftSite"] integerValue];
}

-(void) swapRealLine1:(NSUInteger)lineA 
         andRealLine2:(NSUInteger)lineB{
    
    NSMutableArray *lineLineA = [H objectAtIndex:lineA];
    NSMutableArray *lineLineB = [H objectAtIndex:lineB];
    
    [H replaceObjectAtIndex:lineA withObject:lineLineB];
    [H replaceObjectAtIndex:lineB withObject:lineLineA];
    
}

-(void) odejmijOdRealLine1:(NSUInteger)lineA 
                 realLine2:(NSUInteger)lineB 
              withKvocient:(double)kvocient{
    //lineA = lineA - lineB*kvocient;
    
    NSMutableArray *lineLineA = [H objectAtIndex:lineA];
    NSMutableArray *lineLineB = [H objectAtIndex:lineB];
    
    if ([lineLineA count] != [lineLineB count]) {
        {
            NSString* stringTMP = [NSString stringWithFormat:@"dupa line count\n"];
            DLog(@"%@",stringTMP);
        }

    }
    
    {
        NSString* stringTMP = [NSString stringWithFormat:@"%ld = %dl - %dl * %f\n", lineA, lineA,lineB,kvocient];
        DLog(@"%@",stringTMP);
    }

    

    for (NSUInteger i = 0; i < [lineLineA count]; ++i) {
        double ai = [[lineLineA objectAtIndex:i] doubleValue];
        double bi = [[lineLineB objectAtIndex:i] doubleValue];
        
        double newValueOfAi = ai - bi*kvocient;
        
        [lineLineA replaceObjectAtIndex:i withObject:[NSNumber numberWithDouble:newValueOfAi]];
        
    }
    
}

-(void) gauss{
    NSUInteger m = [H count];
    NSUInteger n = [[H objectAtIndex:0] count];
    
    NSUInteger i = 0;
    NSUInteger j = 0;
    
    while ((i < m)&&(j < n)) {
        NSUInteger maxi = i;
        for (NSUInteger k = i+1; k < m; ++k) {
            if (abs([self getValueFromRealX:k
                                   AndRealY:j]) > abs([self getValueFromRealX:maxi
                                                                     AndRealY:j])) {
                maxi = k;
            }
        }
        
        {
            NSString* stringTMP = [NSString stringWithFormat:@"%@\n",H];
            DLog(@"%@",stringTMP);
        }

        
        
        if ([self getValueFromRealX:maxi 
                           AndRealY:j] != 0) {
            [self swapRealLine1:i 
                   andRealLine2:maxi];
            [self podzielRealLine:i 
                      przezDouble:[self getValueFromRealX:i 
                                                 AndRealY:j]];
            
            
            for(NSUInteger  u = i+1; u < m; ++u){
                [self odejmijOdRealLine1:u 
                               realLine2:i 
                            withKvocient:[self getValueFromRealX:u 
                                                        AndRealY:j]];
            }
            ++i;
        }
        ++j;
    }
    
    
//    
//    for (NSInteger a = [H count]-1; a > 0; --a) {
//        [self odejmijOdRealLine1:a-1 realLine2:a withKvocient:1];
//    }
}


- (void) podzielRealLine:(NSUInteger)lineNumber 
             przezDouble:(double)dziel{
    NSMutableArray* line = [H objectAtIndex:lineNumber];
    
    for (NSUInteger i = 0; i < [line count]; ++i){
        double oldVal = [[line objectAtIndex:i] doubleValue];
        [line replaceObjectAtIndex:i withObject:[NSNumber numberWithDouble:(oldVal/dziel)]];
    }
}

-(void) dlogNames{
    {
        NSString* stringTMP = [NSString stringWithFormat:@"HYNames = %@ \n HXNames = %@\n", HYNames, HXNames];
        DLog(@"%@",stringTMP);
    }
}


-(void) addBC2ForNodeNumber1:(NSUInteger)nodeNumber1 
              andNodeNumber2:(NSUInteger)nodeNumber2 
                      andVal:(double)val{
    
}

-(void) gauss2{
    NSInteger m = [H count];
	NSInteger n = [[H objectAtIndex:0]  count];
	
    //	NSEnumerator *enumeratorNeznanke;
	NSNumber *vrednost;
    
	NSInteger i,j;
	//float matrix[m][n];
	double **matrix;
	matrix = (double **) calloc(m, sizeof(double *));
	for(i = 0; i < m; i++) 
		matrix[i] = (double *) calloc(n, sizeof(double));
	
	
	
	//dodajanje elementov v tabelo
	for(i = 0; i < m; i++) {
		//enumeratorNeznanke = [[enacbe objectAtIndex:i] objectEnumerator];
		/*
         while(vrednost = [enumeratorNeznanke nextObject]) {
         DLog(@"Dodajam element %@ v %i %i", vrednost, i,j);
         matrix[i][j] = [vrednost floatValue];
         j++;
         }
		 */


		for(j = 0; j < n; j++) {
//			NSString *key = [NSString stringWithFormat:@"x%d",j];
//			vrednost = [[enacbe objectAtIndex:i] objectForKey:key];
            vrednost = [[H objectAtIndex:i] objectAtIndex:j];
//			DLog(@"Dodajam element %@ v %ld %ld", vrednost, i,j);
			matrix[i][j] = [vrednost doubleValue];
//			DLog(@"matrix[%ld][%ld] = %f",i,j,matrix[i][j]);
		}
	}
	
	/* tukaj se pricne pravo racunanje... v osnovi je treba spraviti matriko v obliko samih enic po diagonali 
	 (reduced row echelon form)
	 */
	// nova (1/2 lastna) verzija
	//int pivot = 0;
	double pivotEl;
	double *temp;
	i = 0;
	j = 0;
	
	// dol po klancu
	while( i < m && j < n) {
		NSInteger maxI = i;
		NSInteger k, index;
		for(k = i+1; k < m; k++) {
			if(abs(matrix[k][j]) > abs(matrix[maxI][j]))
                maxI = k;
		}
		if(matrix[maxI][j] != 0) {
//			DLog(@"@ swapping rows");
			//swapping rows
			temp = matrix[maxI];
			matrix[maxI] = matrix[i];
			matrix[i] = temp;
			
			pivotEl = matrix[i][j];
			for(index = j; index < n; index++) {
				matrix[i][index] = matrix[i][index] / pivotEl;
//				DLog(@"matrix[%ld][%ld] = %f",i,index,matrix[i][index]);
			}
			
			k = i+1;
			while(k < m) {
				float kvocient = matrix[k][j];
				for(index = j; index < n; index++) {
					matrix[k][index] -= matrix[i][index] * kvocient;
//					DLog(@"matrix[%ld][%ld] = %f",k,index,matrix[k][index]);
				}
				k++;
			}
			i++;
		}
		j++;
	}
	//gor po hribu
	i = m - 1;
	j = n - 2;
	
	// dol po klancu
	while( i >= 0 && j >= 0) {
		NSInteger maxI = i;
		NSInteger k, index;
		for(k = i-1; k >= 0; k--) {
			if(abs(matrix[k][j]) > abs(matrix[maxI][j]))
				maxI = k;
		}
		if(matrix[maxI][j] != 0) {
//			DLog(@"@ swapping rows");
			//swapping rows
			temp = matrix[maxI];
			matrix[maxI] = matrix[i];
			matrix[i] = temp;
			
			//column division
			pivotEl = matrix[i][j];
			for(index = j; index < n; index++) {
				matrix[i][index] = matrix[i][index] / pivotEl;
//				DLog(@"matrix[%ld][%ld] = %f",i,index,matrix[i][index]);
			}
			
			k = i-1;
			while(k >= 0) {
				float kvocient = matrix[k][j];
				for(index = j; index < n; index++) {
					matrix[k][index] -= matrix[i][index] * kvocient;
//					DLog(@"matrix[%ld][%ld] = %f",k,index,matrix[k][index]);
				}
				k--;
			}
			i--;
		}
		j--;
	}
	
    
	
	DLog(@"@ packing");
	//pakiranje veselih rezulatov
	NSNumber *value;// = [[NSNumber alloc] init];
	NSString *key;// = [[NSString alloc] init];
    NSUInteger nodeNumber = 0;
	//NSString *niz = [[NSMutableString alloc] initWithString:@"x"];
	for(i = 0; i < m; i++) {
		value = [NSNumber numberWithFloat:matrix[i][n-1]];
        nodeNumber = [self getNodeNumberFromRealX:i];
		DLog(@"Value of node %ld is: %@, matrix = %f", nodeNumber, value, matrix[i][n-1]);
        Nodes* n = [coreData getNodeWithNumber:nodeNumber];
        n.temp = value;
		key = [NSString stringWithFormat:@"x%d",i];
		
//		[resitve setObject:value forKey:key];
	}
    [coreData saveCD];
	//[value release];
//	[key release];
	
	//sproscanje memorija za matriko
	free(matrix);

}

-(NSUInteger) getNodeNumberFromRealX:(NSUInteger)X{
    return [[HXNamesRevers objectForKey:[[NSNumber numberWithUnsignedInteger:X] stringValue]] unsignedIntegerValue];
}

@end
