//
//  MenuBarController.m
//  PKSPv2
//
//  Created by Maciej Krok on 2011-12-04.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MenuBarController.h"
#include "Mesh.h"


@implementation MenuBarController
@synthesize mainView;
@synthesize bC1Window;
@synthesize bC2Window;
@synthesize progres;
@synthesize state;
@synthesize nodeItem;
@synthesize meshItem;
@synthesize bCItem;
@synthesize solverItem;
@synthesize nodeNameBC1TextField;
@synthesize temperatureValueBC1TextField;
@synthesize nodeName1BC2TextField;
@synthesize nodeName2BC2TextField;
@synthesize qValueBC2TextField;

-(id) init{
    {
        NSString* stringTMP = [NSString stringWithFormat:@"init MenuBarController\n"];
        DLog(@"%@",stringTMP);
    }
    coreData = [CDModel sharedModel];
    
    {
        
        NSString* stringTMP = [NSString stringWithFormat:@"plist: %@\n", [PlistConf valueForKey:@"test"]];
        DLog(@"%@",stringTMP);
    }
    
    
    [PlistConf setValue:@"set" forKey:@"key"];
    
    self.mainView.rOfNode = [[PlistConf valueForKey:@"rOfNode"] doubleValue];
    
    [self.bC1Window setIsVisible:NO];
    [self.bC2Window setIsVisible:NO];
    [self.progres setHidden:YES];    
    
    [self.nodeItem setEnabled:YES];
    [self.meshItem setEnabled:NO];
    [self.bCItem setEnabled:NO];
    [self.solverItem setEnabled:NO];
    return  self;
}

-(IBAction)cleanNodes:(id)sender{
    for (Nodes * n in [coreData allNodes]) {
        [coreData removeCDObiect:n];
    }
    self.mainView.lastPoint = NSMakePoint(0, 0);
    self.mainView.mode = addingNodes;
    [self.mainView display];
}

-(IBAction)addNodes:(id)sender{
    self.mainView.mode = addingNodes;
    [self.progres startAnimation:Nil];
}

-(IBAction)stopAddNodes:(id)sender{
    self.mainView.mode = nothing;
    [self.progres stopAnimation:Nil];
    [self.nodeItem setEnabled:NO];
    [self.meshItem setEnabled:YES];
    [self.bCItem setEnabled:NO];
}


-(IBAction)cleanMash:(id)sender{
    for (Elements * e in [coreData allElements]) {
        [coreData removeCDObiect:e];
    }
    [self.mainView display];
}

-(IBAction)addMash:(id)sender{
    self.mainView.mode = nothing;
    Mesh * mesh = [[Mesh alloc] init];
    mesh.bounds = mainView.bounds;
    [self.progres setHidden:NO];
    [self.progres startAnimation:Nil];
    [mesh go];
    [self.mainView display];
    [self.progres setHidden:YES];
    [self.progres stopAnimation:Nil];
    
}
-(IBAction)okMash:(id)sender{
    [self.progres setHidden:NO];
    [self.progres startAnimation:Nil];
    [self.meshItem setEnabled:NO];
    [self.bCItem setEnabled:YES];
    solver = [[Solver alloc] initWirhCDData];
    [self.progres setHidden:YES];
    [self.progres stopAnimation:Nil];
}


-(IBAction)addBC1:(id)sender{
    self.mainView.mbc = self;
    self.mainView.mode = addingBC1;
    
}
-(IBAction)addBC2:(id)sender{
    self.mainView.mbc = self;
    self.mainView.mode = addingBC2;
    self.mainView.bc2P1 = NSMakePoint(0, 0);
    self.mainView.bc2P2 = NSMakePoint(0, 0);
    
    
}

-(IBAction)okBC:(id)sender{
    [self.bCItem setEnabled:NO];
    [self.solverItem setEnabled:YES];
}

-(void) bc1:(NSPoint)pForBC1{
    Nodes* n = [coreData getNodeWithX:pForBC1.x andY:pForBC1.y inR:[[PlistConf valueForKey:@"rOfNode"] floatValue]];
    if (n == nil) {
        return;
    }
    [n dlog];
    [self.bCItem setEnabled:NO];
    self.mainView.mode = nothing;
    [self.bC1Window setIsVisible:YES];
    [self.nodeNameBC1TextField setStringValue:[n.number stringValue]];
    [self.temperatureValueBC1TextField setStringValue:@""];
}

-(IBAction)okButtonBC1:(id)sender{
    
    if ([self.temperatureValueBC1TextField stringValue] != @"") {
        [solver addBC1ForNode:[[self.nodeNameBC1TextField stringValue] longLongValue]
                        value:[[self.temperatureValueBC1TextField stringValue] doubleValue]];
    }
    [self.bCItem setEnabled:YES];
    [self.bC1Window setIsVisible:NO];
    
}
-(IBAction)cancelButtonBC1:(id)sender{
    [self.bCItem setEnabled:YES];
    [self.bC1Window setIsVisible:NO];
}



-(void) bc2P1:(NSPoint)p1
           P2:(NSPoint)p2{
    Nodes* n1 = [coreData getNodeWithX:p1.x andY:p1.y inR:[[PlistConf valueForKey:@"rOfNode"] floatValue]];
    if (n1 == nil) {
        return;
    }
    [n1 dlog];
    Nodes* n2 = [coreData getNodeWithX:p2.x andY:p2.y inR:[[PlistConf valueForKey:@"rOfNode"] floatValue]];
    if (n2 == nil) {
        return;
    }
    [n2 dlog];
    
    BOOL contains = NO;
    for (Elements* e in n1.inElements) {
        if ([e.nodes containsObject:n2]) {
            contains = YES;
        }
    }
    if (contains == NO) {
        [self cancelButtonBC2:nil];
        return;
    }

    [self.bCItem setEnabled:NO];
    self.mainView.mode = nothing;
    [self.bC2Window setIsVisible:YES];
    [self.nodeName1BC2TextField setStringValue:[n1.number stringValue]];
    [self.nodeName2BC2TextField setStringValue:[n2.number stringValue]];
    [self.qValueBC2TextField setStringValue:@""];
        
}



-(IBAction) okButtonBC2:(id)sender{
    if ([self.qValueBC2TextField stringValue] != @"") {
        [solver addBC2ForNode1:[[self.nodeName1BC2TextField stringValue] longLongValue]
                      andNode2:[[self.nodeName2BC2TextField stringValue] longLongValue]
                          qVal:[[self.qValueBC2TextField stringValue] doubleValue]];
    }
    [self.bCItem setEnabled:YES];
    [self.bC2Window setIsVisible:NO];
    
}

-(IBAction) cancelButtonBC2:(id)sender{
    [self.bCItem setEnabled:YES];
    [self.bC2Window setIsVisible:NO];
}

@end
