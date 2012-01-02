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
    if (self.mode == showResults) {
        tempMax = DBL_MIN;
        tempMin = DBL_MAX;
        
        for (Nodes* n in [coreData allNodes]) {
            if ([n.temp doubleValue] > tempMax) {
                tempMax = [n.temp doubleValue];
            }
            if ([n.temp doubleValue] < tempMin) {
                tempMin = [n.temp doubleValue];
            }
        }
    }
    
    [self drawNodes];
    [self drawElemenys];
}

- (void)drawNodes{
    NSColor* rgba;
    
    switch (self.mode) {
        showResults:
            rgba = [NSColor whiteColor];
            break;
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
        showResults:
            rgba = [NSColor colorWithDeviceRed:0 green:0 blue:0 alpha:1];
            for (Elements* e in [coreData allElements]) {
                [self drawElement:e WithColor:rgba];
            }
            break;
            
        default:
            rgba = [NSColor greenColor];
            for (Elements* e in [coreData allElements]) {
                [self drawElement:e WithColor:rgba];
            }
            break;
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
            [path moveToPoint:p1];  
            
            //1-2
            [path lineToPoint:p2];
            
            //2-3
            [path lineToPoint:p3];
            
            //3-1
            [path lineToPoint:p1];
            
            [rgba set];
            [path stroke];

            break;
    }
    
    
       
    NSPoint minPoint = NSMakePoint(p1.x, p1.y);
    NSPoint maxPoint = NSMakePoint(p1.x, p1.y);

    switch (self.mode) {
        case showResults:
       
            if (minPoint.x > p2.x) {
                minPoint.x = p2.x;
            }
            if (minPoint.x > p3.x) {
                minPoint.x = p3.x;
            }

            if (minPoint.y > p2.y) {
                minPoint.y = p2.y;
            }
            if (minPoint.y > p3.y) {
                minPoint.y = p3.y;
            }
            
            if (maxPoint.x < p2.x) {
                maxPoint.x = p2.x;
            }
            if (maxPoint.x < p3.x) {
                maxPoint.x = p3.x;
            }
            
            if (maxPoint.y < p2.y) {
                maxPoint.y = p2.y;
            }
            if (maxPoint.y < p3.y) {
                maxPoint.y = p3.y;
            }
            
            for (int a = (int)minPoint.x; a <= (int)maxPoint.x; ++a) {
                for (int b = (int)minPoint.y; b <= (int)maxPoint.y; ++b) {
//                    {
//                        NSString* stringTMP = [NSString stringWithFormat:@"drawTemp\n"];
//                        DLog(@"%@",stringTMP);
//                    }

                    NSPoint tmpAB = NSMakePoint(a, b);
//                    {
//                        NSString* stringTMP = [NSString stringWithFormat:@"x: %f, y: %f\n", tmpAB.x, tmpAB.y];
//                        DLog(@"%@",stringTMP);
//                    }

                    double tempAB = [elem getTempAtPoint:tmpAB];
                    if (tempAB != 0) {
                        double tempValColor = (tempAB-tempMin)/(tempMax-tempMin);
                        [self drawCirclePoint:tmpAB
                                            R:1
                                    WithColor:[NSColor colorWithDeviceHue:tempValColor
                                                               saturation:1
                                                               brightness:1 
                                                                    alpha:0.1]];
                        
                    }
                }
            }

            
            break;
            
        default:
            [[NSColor colorWithDeviceRed:(arc4random()%255)/255.0 
                                   green:(arc4random()%255)/255.0  
                                    blue:(arc4random()%255)/255.0 
                                   alpha:0.2] setFill];
            [path fill];
            break;
    }
   
    
    
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
        NSString* stringTMP = [NSString stringWithFormat:@"jest\n"];
        DLog(@"%@",stringTMP);
    }

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
        if (!(location.x == 0 && location.y == 0)) {
            Nodes *n;
            n = [coreData getOrCreateNodeWithX:location.x 
                                          andY:location.y];
            [coreData saveCD];
            lastPoint = location;
            [self display];
            self.lastPoint = NSMakePoint(0, 0);
            self.startNode = NSMakePoint(0, 0);
        }
        
        
        
    }
    
}



@end
