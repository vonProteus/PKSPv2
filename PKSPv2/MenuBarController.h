//
//  MenuBarController.h
//  PKSPv2
//
//  Created by Maciej Krok on 2011-12-04.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainView.h"
#import "CDModel.h"
#import "PlistConf.h"
#import "Solver.h"

typedef enum AppState {
    noder,
    meshh,
    bcc
}AppState;


@interface MenuBarController : NSObject {
    CDModel* coreData;
    Solver* solver;
}
@property (retain) IBOutlet MainView* mainView;
@property (retain) IBOutlet NSProgressIndicator* progres;



@property (retain) IBOutlet NSMenuItem* nodeItem;
@property (retain) IBOutlet NSMenuItem* meshItem;
@property (retain) IBOutlet NSMenuItem* bCItem;
@property (retain) IBOutlet NSMenuItem* solverItem;

@property (assign) AppState state;

-(IBAction)cleanNodes:(id)sender;
-(IBAction)addNodes:(id)sender;
-(IBAction)stopAddNodes:(id)sender;


-(IBAction)cleanMash:(id)sender;
-(IBAction)addMash:(id)sender;
-(IBAction)okMash:(id)sender;

-(IBAction)addBC1:(id)sender;
-(IBAction)addBC2:(id)sender;
-(IBAction)okBC:(id)sender;

-(IBAction)goSolver:(id)sender;



@property (retain) IBOutlet NSWindow* prefWindow;
@property (retain) IBOutlet NSTextField* numberOfPointsToAddTextField;
@property (retain) IBOutlet NSTextField* nodeSizeXTextField;
@property (retain) IBOutlet NSTextField* nodeSizeYTextField;
@property (retain) IBOutlet NSTextField* spaceBetwenNodesOnEadgeTextField;
@property (retain) IBOutlet NSTextField* rOfNodeTextField;
@property (retain) IBOutlet NSTextField* maxLenghtOfEadgeTextField;
@property (retain) IBOutlet NSTextField* kValueTextField;
-(IBAction)showPrefWindow:(id)sender;
-(IBAction)savePref:(id)sender;
-(IBAction)closePref:(id)sender;






@property (retain) IBOutlet NSWindow* bC1Window;
@property (retain) IBOutlet NSTextField* nodeNameBC1TextField;
@property (retain) IBOutlet NSTextField* temperatureValueBC1TextField;
-(IBAction) okButtonBC1:(id)sender;
-(IBAction) cancelButtonBC1:(id)sender;
-(void) bc1:(NSPoint)pForBC1;



@property (retain) IBOutlet NSWindow* bC2Window;
@property (retain) IBOutlet NSTextField* nodeName1BC2TextField;
@property (retain) IBOutlet NSTextField* nodeName2BC2TextField;
@property (retain) IBOutlet NSTextField* qValueBC2TextField;
-(IBAction) okButtonBC2:(id)sender;
-(IBAction) cancelButtonBC2:(id)sender;
-(void) bc2P1:(NSPoint)p1 
           P2:(NSPoint)p2;


@property (retain) IBOutlet NSWindow* showResultsWindow;
@property (retain) IBOutlet NSTextField* tempShowResultsTextField;
-(void) showTemperatureAtPoint:(NSPoint)p;



-(IBAction)savePNG:(id)sender;
@end
