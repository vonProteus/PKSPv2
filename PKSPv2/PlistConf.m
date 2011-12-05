//
//  PlistConf.m
//  Fiszki
//
//  Created by Maciej Krok on 11-07-13.
//  Copyright 2011 Freelance. All rights reserved.
//

#import "PlistConf.h"
#import "NSFileManager+DirectoryLocations.h"




@implementation PlistConf



+(NSDictionary*) plistConf{
     NSString* plistName = @"PKSPv2 Settings.plist";
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSURL* plistPath = [PlistConf path];
       
    BOOL success = [fileManager fileExistsAtPath:[NSString stringWithContentsOfURL:plistPath]];
    if(!success){
        //file does not exist. So look into mainBundle
        NSString *defaultPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:plistName];
        success = [fileManager copyItemAtPath:defaultPath toPath:[[fileManager applicationSupportDirectory] stringByAppendingPathComponent:plistName] error:&error];
        
        {
            NSString* stringTMP = [NSString stringWithFormat:@"resourcePath %@ applicationSupportDirectory %@\n", defaultPath, [fileManager applicationSupportDirectory]];
            DLog(@"%@",stringTMP);
        }

    }
    if (success) {
        NSDictionary *confDict = [NSDictionary dictionaryWithContentsOfURL:plistPath];
        return confDict;
    }
    return nil;
}

+(NSURL*) path{
    
     NSString* plistName = @"PKSPv2 Settings.plist";
    
    NSURL *libraryPath = [NSURL fileURLWithPath:[[NSFileManager defaultManager] applicationSupportDirectory]];
    
    return [libraryPath URLByAppendingPathComponent:plistName];
}

+(id) valueForKey:(NSString *)Key{
    return [[PlistConf plistConf] valueForKey:Key];
}

+(void) setValue:(id)Value forKey:(NSString *)Key{
    NSMutableDictionary* confDict = [[PlistConf plistConf] mutableCopy];
    
    [confDict setValue:Value forKey:Key];
    
    [confDict writeToURL:[PlistConf path] atomically:YES];
}

@end
