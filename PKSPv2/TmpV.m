//
//  TmpV.m
//  PKSPv2
//
//  Created by Maciej Krok on 2011-11-26.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TmpV.h"

@implementation TmpV

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        DLog(@"init TmpV");
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    DLog("ok");
    coreData = [CDModel sharedModel];
    
    for (Nodes* n2remove in [coreData allNodes]) {
        [coreData removeNodeByNumber:[n2remove.number integerValue]];
    }
    
    
    Nodes *n;
    Elements *e;
    
    n = [coreData addNewNode];
    n.x = [NSNumber numberWithDouble:0];
    n.y = [NSNumber numberWithDouble:0];
    n.number = [NSNumber numberWithInteger:1];
    
    n = [coreData addNewNode];
    n.x = [NSNumber numberWithDouble:0];
    n.y = [NSNumber numberWithDouble:2];
    n.number = [NSNumber numberWithInteger:2];
    
    n = [coreData addNewNode];
    n.x = [NSNumber numberWithDouble:0];
    n.y = [NSNumber numberWithDouble:4];
    n.number = [NSNumber numberWithInteger:3];
    
    n = [coreData addNewNode];
    n.x = [NSNumber numberWithDouble:2];
    n.y = [NSNumber numberWithDouble:0];
    n.number = [NSNumber numberWithInteger:4];
    
    n = [coreData addNewNode];
    n.x = [NSNumber numberWithDouble:2];
    n.y = [NSNumber numberWithDouble:2];
    n.number = [NSNumber numberWithInteger:5];
    
    n = [coreData addNewNode];
    n.x = [NSNumber numberWithDouble:4];
    n.y = [NSNumber numberWithDouble:0];
    n.number = [NSNumber numberWithInteger:6];
    
    [coreData saveCD];
    
    DLog(@"number of nodes %ld \n", [[coreData allNodes] count]);
    for (n in [coreData allNodes]) {
        [n dlog];
    }
    
    [coreData makeElementFromNode1:[coreData getNodeWithNumber: 1]
                             Node2:[coreData getNodeWithNumber: 4] 
                             Node3:[coreData getNodeWithNumber: 2]];
    
    [coreData makeElementFromNode1:[coreData getNodeWithNumber: 4]
                             Node2:[coreData getNodeWithNumber: 5] 
                             Node3:[coreData getNodeWithNumber: 2]];
    
    [coreData makeElementFromNode1:[coreData getNodeWithNumber: 2]
                             Node2:[coreData getNodeWithNumber: 5] 
                             Node3:[coreData getNodeWithNumber: 3]];
    
    [coreData makeElementFromNode1:[coreData getNodeWithNumber: 4]
                             Node2:[coreData getNodeWithNumber: 6] 
                             Node3:[coreData getNodeWithNumber: 5]];
    
    {
        NSString* stringTMP = [NSString stringWithFormat:@" number of elements %i\n", [[coreData allElements] count]];
        DLog(@"%@",stringTMP);
    }

    
    for (e in [coreData allElements]) {
        [e dlog];
    }
    //    DLog(@"----------------");
//    
//    [coreData removeNodeByNumber:5];
//    
//    for (n in [coreData allNodes]) {
//        [n dlog];
//    }
//    
//    for (e in [coreData allElements]) {
//        [e dlog];
//    }
    
    GlobalMatrix* gm = [[GlobalMatrix alloc] init];
    
    [gm fillGlobalMatrix];
        
    [gm dlog2];
   
    DLog(@"end");
}

@end
