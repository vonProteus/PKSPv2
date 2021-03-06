//
//  MainView.m
//  PKSPv2
//
//  Created by Maciej Krok on 2011-12-04.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "MainView.h"
#import "PlistConf.h"
#import "MenuBarController.h"

@implementation MainView
@synthesize mode;
@synthesize rOfNode;
@synthesize lastPoint, bc2P1, bc2P2, startNode;
@synthesize mbc;

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
        DLog(@"init");
        coreData = [CDModel sharedModel];   
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    // Drawing code here.
    if (coreData == Nil){
        {
            NSString* stringTMP = [NSString stringWithFormat:@"mode = blank\n"];
            DLog(@"%@",stringTMP);
        }

        coreData = [CDModel sharedModel];
        self.mode = nothing;
        self.rOfNode = [[PlistConf valueForKey:@"rOfNode"] doubleValue];
    }
//    [self makeCoordinateSistem];
    [self drawNodes];
    [self drawElemenys];
}

- (void)drawNodes{
    NSColor* rgba;
    
    switch (self.mode) {
        default:
            rgba = [NSColor blackColor];
            break;
    }


    
    //    DLog(@"start");
    for (Nodes* n in [coreData allNodes]) {
        //        [n dlog];
        [self drawCirclePoint:[n pointValue]
                            R:self.rOfNode
                    WithColor:rgba];
        
    }
    
}

- (void)drawCircleX: (double)x 
                  Y: (double)y 
                  R: (double)r
          WithColor:(NSColor *)rgba{
    //    DLog(@"ok");
    NSRect rect = NSMakeRect(x-r, y-r, 2*r, 2*r);
    NSBezierPath* path = [NSBezierPath bezierPath];
    [path appendBezierPathWithOvalInRect:rect];
    
    [rgba set];
    
    [path stroke];
    
}
- (void)drawCirclePoint: (NSPoint)center
                      R: (double)r
              WithColor:(NSColor *)rgba{
    [self drawCircleX:center.x Y:center.y R:r WithColor:rgba];
}


-(void) drawElemenys{
    NSColor* rgba;
    
    switch (self.mode) {
        default:
            rgba = [NSColor greenColor];
            break;
    }
    
    
    for (Elements* e in [coreData allElements]) {
        [self drawElement:e WithColor:rgba];
    }
    
}

-(void) drawElement:(Elements *)elem WithColor:(NSColor *)rgba{
    NSBezierPath* path = [NSBezierPath bezierPath];
    NSPoint p1,p2,p3;
    switch (self.mode) {
        default:
            p1 = [elem.n1 pointValue];
            p2 = [elem.n2 pointValue];
            p3 = [elem.n3 pointValue];
            break;
    }
    
    
    [path moveToPoint:p1];  
    
    //1-2
    [path lineToPoint:p2];
    
    //2-3
    [path lineToPoint:p3];
    
    //3-1
    [path lineToPoint:p1];
    
    [rgba set];
    [path stroke];
    [[NSColor colorWithDeviceRed:(arc4random()%255)/255.0 
                           green:(arc4random()%255)/255.0  
                            blue:(arc4random()%255)/255.0 
                           alpha:0.2] setFill];
    [path fill];

    
    
}

- (void) mouseDown:(NSEvent*)someEvent {
    //    DLog(@"It worked!");
    NSPoint location = [self.window convertScreenToBase:[NSEvent mouseLocation]];
    switch (self.mode) {
        case nothing:
            break;
            
        case addingNodes:
            {
                if ((startNode.x == 0 && startNode.y == 0)){
                    startNode = lastPoint;
                }
                if (!(lastPoint.x == 0 && lastPoint.y == 0)) {
                    NSPoint delta = NSMakePoint(lastPoint.x - location.x, lastPoint.y - location.y);
                    double d = sqrt(delta.x*delta.x+ delta.y*delta.y);
                    NSUInteger k = (NSUInteger)(d/[[PlistConf valueForKey:@"spaceBetwenNodesOnEadge"] unsignedIntegerValue]);
                    NSPoint step = delta;
                    step.x /= k;
                    step.y /= k;
                    
                    for (NSUInteger a = 1; a < k; ++a) {
                        NSPoint tmpLocation = NSMakePoint(lastPoint.x - a*step.x, lastPoint.y - a*step.y);
                        Nodes *n;
                        n = [coreData getOrCreateNodeWithX:tmpLocation.x 
                                                      andY:tmpLocation.y];
             
                    }
                }
                
                Nodes *n;
                n = [coreData getOrCreateNodeWithX:location.x 
                                              andY:location.y];
                
                [coreData saveCD];
                lastPoint = location;
                [self display];
            }
            break;
            
        case addingBC1:
        {
            [mbc bc1:location];
        }
            break;
        case addingBC2:
        {
            if (bc2P1.x != 0 && bc2P1.y != 0) {
                [mbc bc2P1:bc2P1 P2:location];
            }
            bc2P1 = location;
        }
            break;
            
        default:
            break;
    }
  
}

-(void) stopaAddingNodes{
    NSPoint location = self.startNode;
    {
        if (!(lastPoint.x == 0 && lastPoint.y == 0)) {
            NSPoint delta = NSMakePoint(lastPoint.x - location.x, lastPoint.y - location.y);
            double d = sqrt(delta.x*delta.x+ delta.y*delta.y);
            NSUInteger k = (NSUInteger)(d/[[PlistConf valueForKey:@"spaceBetwenNodesOnEadge"] unsignedIntegerValue]);
            NSPoint step = delta;
            step.x /= k;
            step.y /= k;
            
            for (NSUInteger a = 1; a < k; ++a) {
                NSPoint tmpLocation = NSMakePoint(lastPoint.x - a*step.x, lastPoint.y - a*step.y);
                Nodes *n;
                n = [coreData getOrCreateNodeWithX:tmpLocation.x 
                                              andY:tmpLocation.y];
                
            }
        }
        
        Nodes *n;
        n = [coreData getOrCreateNodeWithX:location.x 
                                      andY:location.y];
        
        [coreData saveCD];
        lastPoint = location;
        [self display];
    }
    
}



@end
