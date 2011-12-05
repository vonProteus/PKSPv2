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

typedef enum AppState {
    noder,
    meshh,
    bcc
}AppState;


@interface MenuBarController : NSObject {
    CDModel* coreData;
}
@property (retain) IBOutlet MainView* mainView;
@property (retain) IBOutlet NSProgressIndicator* progres;
@property (retain) IBOutlet NSWindow* bCWindow;
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

-(IBAction)startAddingBC:(id)sender;
-(IBAction)addBC1:(id)sender;
-(IBAction)addBC2:(id)sender;
-(IBAction)okBC:(id)sender;



@end
