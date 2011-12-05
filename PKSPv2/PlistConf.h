//
//  PlistConf.h
//  Fiszki
//
//  Created by Maciej Krok on 11-07-13.
//  Copyright 2011 Freelance. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface PlistConf : NSObject {
    
}


+(NSDictionary*) plistConf;
+(NSString*) path;
+(id) valueForKey:(NSString*)Key;
+(void) setValue:(id)Value forKey:(NSString*)Key;

@end
