//
//  MainView.h
//  PKSPv2
//
//  Created by Maciej Krok on 2011-12-04.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#include "CDModel.h"
@class MenuBarController;

typedef enum MainViewMode {
    nothing,
    addingNodes,
    addingBC1,
    addingBC2,
    showResults
}MainViewMode;

@interface MainView : NSView{
    CDModel* coreData;
    double tempMax;
    double tempMin;
    CFMutableDataRef bitmapData;
}
@property (nonatomic, retain) IBOutlet MenuBarController* mbc;
@property (assign) NSPoint lastPoint, bc2P1, bc2P2, startNode;
@property (nonatomic, readwrite) MainViewMode mode;
@property (assign) double rOfNode;
@property (nonatomic, strong) NSImage* imageSolv;

- (void)drawNodes;
- (void)drawElemenys;

- (void)drawCircleX: (double)x
                  Y: (double)y 
                  R: (double)r
          WithColor:(NSColor*)rgba;

- (void)drawCirclePoint: (NSPoint)center
                      R: (double)r
              WithColor:(NSColor *)rgba;

- (void)drawElement:(Elements*)elem 
          WithColor:(NSColor*) rgba;

- (void) stopaAddingNodes; 

-(void) drawElementWithTemp:(Elements *)elem;
-(NSImage*) createNSImageWithMesh;
@property (nonatomic,retain) IBOutlet NSImageView *ViewImage; 
-(void) drawElemenysNOW;
-(void) clean;

@end
