//
//  Elements.h
//  PKSPv2
//
//  Created by Maciej Krok on 2011-11-26.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Nodes.h"



@interface Elements : NSManagedObject

@property (nonatomic, retain) NSSet *nodes;
@property (nonatomic, retain) Nodes *n1;
@property (nonatomic, retain) Nodes *n2;
@property (nonatomic, retain) Nodes *n3;


@end

@interface Elements (CoreDataGeneratedAccessors)

- (void)addNodesObject:(NSManagedObject *)value;
- (void)removeNodesObject:(NSManagedObject *)value;
- (void)addNodes:(NSSet *)values;
- (void)removeNodes:(NSSet *)values;

@end
