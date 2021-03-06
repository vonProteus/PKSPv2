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
//    Elements *e;
    
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
//    for (n in [coreData allNodes]) {
//        [n dlog];
//    }
    
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

    
//    for (e in [coreData allElements]) {
//        [e dlog];
//    }
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
    
    {
        NSString* stringTMP = [NSString stringWithFormat:@"==============\n"];
        DLog(@"%@",stringTMP);
    }

    
    [gm fillGlobalMatrix];
    
    {
        NSString* stringTMP = [NSString stringWithFormat:@"BC start\n"];
        DLog(@"%@",stringTMP);
    }

//    [gm dlog2];
    
    [gm startAddingBC];
//    [gm dlogNames];
//    [gm dlog2];
    [gm addBC1ForNodeNumber:2 andVal:100];
//    [gm dlog2];
   
    [gm gauss2];
    
    
//    [gm add:2 ToX:3 AndY:3]; 
    
    {
        NSString* stringTMP = [NSString stringWithFormat:@"==============\n"];
        DLog(@"%@",stringTMP);
    }

//    [gm dlog2];
//    [gm dlog];
    
    for (n in [coreData allNodes]) {
        [n dlog];
    }
//    NSBeep();
    
   
    DLog(@"end");
}

@end
