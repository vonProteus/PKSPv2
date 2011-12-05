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

-(id) init{
    {
        NSString* stringTMP = [NSString stringWithFormat:@"init MenuBarController\n"];
        DLog(@"%@",stringTMP);
    }
    coreData = [CDModel sharedModel];
    
    return  self;
}

-(IBAction)cleanNodes:(id)sender{
    for (Nodes * n in [coreData allNodes]) {
        [coreData removeCDObiect:n];
    }
    mainView.mode = addingNodes;
    [mainView display];
}

-(IBAction)addNodes:(id)sender{
    mainView.mode = addingNodes;
}

-(IBAction)stopAddNodes:(id)sender{
    mainView.mode = nothing;
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
    [mesh go];
    [mainView display];
}


-(IBAction)startAddingBC:(id)sender{
    bCWindow.isVisible = !bCWindow.isVisible;
}
-(IBAction)addBC1:(id)sender{
    
}
-(IBAction)addBC2:(id)sender{
    
}



@end
