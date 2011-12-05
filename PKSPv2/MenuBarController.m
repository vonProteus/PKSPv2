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
@synthesize bCWindow;
@synthesize progres;
@synthesize state;
@synthesize nodeItem;
@synthesize meshItem;
@synthesize bCItem;
@synthesize solverItem;

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
    
    [bCWindow setIsVisible:NO];
    [progres setHidden:YES];    
    
    [nodeItem setEnabled:YES];
    [meshItem setEnabled:NO];
    [bCItem setEnabled:NO];
    [solverItem setEnabled:NO];
    return  self;
}

-(IBAction)cleanNodes:(id)sender{
    for (Nodes * n in [coreData allNodes]) {
        [coreData removeCDObiect:n];
    }
    mainView.lastPoint = NSMakePoint(0, 0);
    mainView.mode = addingNodes;
    [mainView display];
}

-(IBAction)addNodes:(id)sender{
    mainView.mode = addingNodes;
    [progres startAnimation:Nil];
}

-(IBAction)stopAddNodes:(id)sender{
    mainView.mode = nothing;
    [progres stopAnimation:Nil];
    [nodeItem setEnabled:NO];
    [meshItem setEnabled:YES];
    [bCItem setEnabled:NO];
}


-(IBAction)cleanMash:(id)sender{
    for (Elements * e in [coreData allElements]) {
        [coreData removeCDObiect:e];
    }
    [mainView display];
}

-(IBAction)addMash:(id)sender{
    mainView.mode = nothing;
    Mesh * mesh = [[Mesh alloc] init];
    mesh.bounds = mainView.bounds;
    [progres setHidden:NO];
    [progres startAnimation:Nil];
    [mesh go];
    [mainView display];
    [progres setHidden:YES];
    [progres stopAnimation:Nil];
    
}
-(IBAction)okMash:(id)sender{
    [meshItem setEnabled:NO];
    [bCItem setEnabled:YES];
}


-(IBAction)startAddingBC:(id)sender{
    
}
-(IBAction)addBC1:(id)sender{
    
}
-(IBAction)addBC2:(id)sender{
    
}

-(IBAction)okBC:(id)sender{
    [bCItem setEnabled:NO];
    [solverItem setEnabled:YES];
}


@end
