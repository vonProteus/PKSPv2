//
//  Nodes+Metods.m
//  PKSPv2
//
//  Created by Maciej Krok on 2011-11-26.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Nodes+Metods.h"

@implementation Nodes (Metods)

-(void) dlog{
    DLog(@"%i (%f,%f) T:%f", [self.number intValue], [self.x floatValue], [self.y floatValue], [self.temp floatValue]);
}

-(NSPoint) pointValue{
    return NSMakePoint([self.x floatValue], [self.y floatValue]);
}

@end
