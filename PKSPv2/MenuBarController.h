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


@interface MenuBarController : NSObject {
    CDModel* coreData;
}
@property (retain) IBOutlet MainView* mainView;
@property (retain) IBOutlet NSWindow* bCWindow;

-(IBAction)cleanNodes:(id)sender;
-(IBAction)addNodes:(id)sender;
-(IBAction)stopAddNodes:(id)sender;


-(IBAction)cleanMash:(id)sender;
-(IBAction)addMash:(id)sender;

-(IBAction)startAddingBC:(id)sender;
-(IBAction)addBC1:(id)sender;
-(IBAction)addBC2:(id)sender;



@end
