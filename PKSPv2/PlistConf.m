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
    NSMutableArray *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) mutableCopy];
    [paths insertObject:[fileManager applicationSupportDirectory] atIndex:0];
    NSString *plistPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:plistName];
    
    BOOL success = [fileManager fileExistsAtPath:plistPath];
    if(!success){
        //file does not exist. So look into mainBundle
        NSString *defaultPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:plistName];
        success = [fileManager copyItemAtPath:defaultPath toPath:plistPath error:&error];
    }
    if (success) {
        paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) mutableCopy];
        [paths insertObject:[fileManager applicationSupportDirectory] atIndex:0];
        plistPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:plistName];
        NSDictionary *confDict=[NSDictionary dictionaryWithContentsOfFile:plistPath];
        return confDict;
    }
    return nil;
}

+(NSString*) path{
    NSString* plistName = @"PKSPv2 Settings.plist";
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    NSMutableArray *paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) mutableCopy];
    [paths insertObject:[fileManager applicationSupportDirectory] atIndex:0];
    NSString *plistPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:plistName];
    
    BOOL success = [fileManager fileExistsAtPath:plistPath];
    if(!success){
        //file does not exist. So look into mainBundle
        NSString *defaultPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:plistName];
        success = [fileManager copyItemAtPath:defaultPath toPath:plistPath error:&error];
    }
    if (success) {
        paths = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) mutableCopy];
        [paths insertObject:[fileManager applicationSupportDirectory] atIndex:0];
        plistPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:plistName];
        return plistPath;
    }
    return nil;
}

+(id) valueForKey:(NSString *)Key{
    return [[PlistConf plistConf] valueForKey:Key];
}

+(void) setValue:(id)Value forKey:(NSString *)Key{
    NSMutableDictionary* confDict = [[PlistConf plistConf] mutableCopy];
    
    [confDict setValue:Value forKey:Key];
    
    [confDict writeToFile:[PlistConf path] atomically:YES];

}

@end
