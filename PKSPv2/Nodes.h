//
//  Nodes.h
//  PKSPv2
//
//  Created by Maciej Krok on 2011-11-26.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Elements;

@interface Nodes : NSManagedObject

@property (nonatomic, retain) NSNumber * number;
@property (nonatomic, retain) NSNumber * x;
@property (nonatomic, retain) NSNumber * y;
@property (nonatomic, retain) NSNumber * temp;
@property (nonatomic, retain) NSNumber * known;
@property (nonatomic, retain) NSSet *inElements;


@end

@interface Nodes (CoreDataGeneratedAccessors)

- (void)addInElementsObject:(Elements *)value;
- (void)removeInElementsObject:(Elements *)value;
- (void)addInElements:(NSSet *)values;
- (void)removeInElements:(NSSet *)values;

@end
