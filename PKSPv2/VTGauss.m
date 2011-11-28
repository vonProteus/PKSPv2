//
//  VTGauss.m
//  DiskKalk
//
//  Created by Vid Tadel on 9/4/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import "VTGauss.h"


@implementation VTGauss

@synthesize enacbe;
@synthesize resitve;

- (VTGauss *) initWithArray: (NSArray *) array {
	if(self = [super init]) {
		enacbe = [[NSArray alloc] initWithArray: array];
		resitve = [[NSMutableDictionary alloc] init];
	}
	
	return self;
}

- (BOOL) isSolvable {
	if([enacbe count] == [[[enacbe objectAtIndex:0] allKeys] count])
		return YES;
	else 
		return NO;
}

- (void) calculate {
	NSUInteger m = [enacbe count];
	NSUInteger n = [[[enacbe objectAtIndex:0] allKeys] count];
	
//	NSEnumerator *enumeratorNeznanke;
	NSNumber *vrednost;

	NSInteger i,j;
	//double matrix[m][n];
	double **matrix;
	matrix = (double **) calloc(m, sizeof(double *));
	for(i = 0; i < m; i++) 
		matrix[i] = (double *) calloc(n, sizeof(double));
	
	
	
	//dodajanje elementov v tabelo
	for(i = 0; i < m; i++) {
		//enumeratorNeznanke = [[enacbe objectAtIndex:i] objectEnumerator];
		/*
		while(vrednost = [enumeratorNeznanke nextObject]) {
			NSLog(@"Dodajam element %@ v %i %i", vrednost, i,j);
			matrix[i][j] = [vrednost doubleValue];
			j++;
		}
		 */
		for(j = 0; j < n; j++) {
			NSString *key = [NSString stringWithFormat:@"x%d",j];
			vrednost = [[enacbe objectAtIndex:i] objectForKey:key];
			NSLog(@"Dodajam element %@ v %ld %ld", vrednost, i,j);
			matrix[i][j] = [vrednost doubleValue];
			NSLog(@"matrix[%ld][%ld] = %f",i,j,matrix[i][j]);
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
			NSLog(@"@ swapping rows");
			//swapping rows
			temp = matrix[maxI];
			matrix[maxI] = matrix[i];
			matrix[i] = temp;
			
			pivotEl = matrix[i][j];
			for(index = j; index < n; index++) {
				matrix[i][index] = matrix[i][index] / pivotEl;
				NSLog(@"matrix[%ld][%ld] = %f",i,index,matrix[i][index]);
			}
			
			k = i+1;
			while(k < m) {
				double kvocient = matrix[k][j];
				for(index = j; index < n; index++) {
					matrix[k][index] -= matrix[i][index] * kvocient;
					NSLog(@"matrix[%ld][%ld] = %f",k,index,matrix[k][index]);
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
			NSLog(@"@ swapping rows");
			//swapping rows
			temp = matrix[maxI];
			matrix[maxI] = matrix[i];
			matrix[i] = temp;
			
			//column division
			pivotEl = matrix[i][j];
			for(index = j; index < n; index++) {
				matrix[i][index] = matrix[i][index] / pivotEl;
				NSLog(@"matrix[%ld][%ld] = %f",i,index,matrix[i][index]);
			}
			
			k = i-1;
			while(k >= 0) {
				double kvocient = matrix[k][j];
				for(index = j; index < n; index++) {
					matrix[k][index] -= matrix[i][index] * kvocient;
					NSLog(@"matrix[%ld][%ld] = %f",k,index,matrix[k][index]);
				}
				k--;
			}
			i--;
		}
		j--;
	}
	
		
	
	NSLog(@"@ packing");
	//pakiranje veselih rezulatov
	NSNumber *value;// = [[NSNumber alloc] init];
	NSString *key;// = [[NSString alloc] init];
	//NSString *niz = [[NSMutableString alloc] initWithString:@"x"];
	for(i = 0; i < m; i++) {
		value = [NSNumber numberWithDouble:matrix[i][n-1]];
		NSLog(@"Value is: %@, matrix = %f",value,matrix[i][n-1]);
		key = [NSString stringWithFormat:@"x%d",i];
		
		[resitve setObject:value forKey:key];
	}
	//[value release];
//	[key release];
	
	//sproscanje memorija za matriko
	free(matrix);
}

@end
