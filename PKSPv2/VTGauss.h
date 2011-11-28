//
//  VTGauss.h
//  DiskKalk
//
//  Created by Vid Tadel on 9/4/08.
//  Copyright 2008 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface VTGauss : NSObject {
}

@property (assign) NSArray *enacbe;
@property (assign) NSMutableDictionary *resitve;

- (VTGauss *) initWithArray: (NSArray *) array;
- (BOOL) isSolvable;
- (void) calculate;

@end
