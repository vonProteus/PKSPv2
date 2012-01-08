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
@synthesize ViewImage;

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
            if ([n.temp doubleValue] == 0) {
                continue;
            }
            if ([n.temp doubleValue] > tempMax) {
                tempMax = [n.temp doubleValue];
            }
            if ([n.temp doubleValue] < tempMin) {
                tempMin = [n.temp doubleValue];
            }
        }
        {
            NSString* stringTMP = [NSString stringWithFormat:@"max %f min %f\n", tempMax, tempMin];
            DLog(@"%@",stringTMP);
        }
        
    }
    
    [self drawElemenys];
    [self drawNodes];
    
    {
        NSString* stringTMP = [NSString stringWithFormat:@"end\n"];
        DLog(@"%@",stringTMP);
    }

}

- (void)drawNodes{
    NSColor* rgba;
    
    switch (self.mode) {
        case showResults:
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
       case showResults:
        {
            NSString* stringTMP = [NSString stringWithFormat:@"showResults\n"];
            DLog(@"%@",stringTMP);
        }
            break;
            
        default:
        {
            NSString* stringTMP = [NSString stringWithFormat:@"default\n"];
            DLog(@"%@",stringTMP);
        }
            rgba = [NSColor greenColor];
            for (Elements* e in [coreData allElements]) {
                [self drawElement:e WithColor:rgba];
            }
            break;
    }
    
    
     
}

-(void) drawElemenysNOW{
    DLog(@"start\n");
    
    if (self.mode == showResults) {
        tempMax = DBL_MIN;
        tempMin = DBL_MAX;
        
        for (Nodes* n in [coreData allNodes]) {
            if ([n.temp doubleValue] == 0) {
                continue;
            }
            if ([n.temp doubleValue] > tempMax) {
                tempMax = [n.temp doubleValue];
            }
            if ([n.temp doubleValue] < tempMin) {
                tempMin = [n.temp doubleValue];
            }
        }
        {
            NSString* stringTMP = [NSString stringWithFormat:@"max %f min %f\n", tempMax, tempMin];
            DLog(@"%@",stringTMP);
        }
        
    }

    NSImage *newImage;
    bitmapData = CFDataCreateMutable(NULL, 0);
    CFDataSetLength(bitmapData, self.bounds.size.width * self.bounds.size.height * 4);
    for (Elements* e in [coreData allElements]) {
        [self drawElementWithTemp:e];
    }
    newImage = [self createNSImageWithMesh];//(bitmapData, self.bounds.size.width, self.bounds.size.height);
    CFRelease(bitmapData);
    if (newImage !=nil){
        [ViewImage setImage: newImage];
    }
    DLog(@"end\n");

    
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
    
    
    
    
    [[NSColor colorWithDeviceRed:(arc4random()%255)/255.0 
                           green:(arc4random()%255)/255.0  
                            blue:(arc4random()%255)/255.0 
                           alpha:0.2] setFill];
    [path fill];
    
   
    
    
}

-(void) drawElementWithTemp:(Elements *)elem{
    UInt8* bitmap = CFDataGetMutableBytePtr(bitmapData);
    NSPoint minInElem = [elem getMinValueOfXY];
    NSPoint maxInElem = [elem getMaxValueOfXY];
    
    for (NSInteger x = minInElem.x-1; x <= maxInElem.x; ++x) {
        for (NSInteger y = minInElem.y-1; y <= maxInElem.y; ++y) {
            double tempXY = [elem getTempAtPoint:NSMakePoint(x, y)];
            if (tempXY != 0) {
                double tempValColor = 240.0/360.0+((tempXY-tempMin)/(tempMax-tempMin))*((360.0-240.0)/360.0);
//                {
//                    NSString* stringTMP = [NSString stringWithFormat:@"tempValColor: %f tempXY: %f\n", tempValColor, tempXY];
//                    DLog(@"%@",stringTMP);
//                }

                NSColor* aColor = [NSColor colorWithDeviceHue:tempValColor
                                                   saturation:1
                                                   brightness:1 
                                                        alpha:1];
                int i = 4 * (x +15 + (self.bounds.size.height - y -20) * self.bounds.size.width);
                bitmap[i] = [aColor redComponent] * 0xff;
                bitmap[i+1] = [aColor greenComponent] * 0xff;
                bitmap[i+2] = [aColor blueComponent] * 0xff;
                bitmap[i+3] = [aColor alphaComponent] * 0xff;
                
            }
        }
    }
}
-(NSImage*) createNSImageWithMesh{
    CGDataProviderRef dataProvider = CGDataProviderCreateWithCFData(bitmapData);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGImageRef imageRef = CGImageCreate(self.bounds.size.width, self.bounds.size.height, 8, 32, self.bounds.size.width * 4, colorSpace, kCGImageAlphaLast, dataProvider, NULL, 0, kCGRenderingIntentDefault);
    NSImage *image = [[NSImage alloc] initWithCGImage:imageRef size:self.bounds.size];
    CGDataProviderRelease(dataProvider);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageRef);
    return image;
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
        case showResults:
            [mbc showTemperatureAtPoint:location];
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

-(void) clean{
    [ViewImage setImage: nil];
}

@end
