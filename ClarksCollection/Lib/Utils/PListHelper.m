//
//  PListHelper.m
//  NS 360
//
//  Created by Openly on 27/08/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import "PListHelper.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation PListHelper
+(NSString *)getDocsDirectory{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}

+(BOOL)setPlist:(NSString *)strPlistName{
    NSError *error ;
    NSString *path = [[self getDocsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", strPlistName]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:path]) {
        NSString *bundle = [[NSBundle mainBundle] pathForResource:strPlistName ofType:@"plist"];
        [fileManager copyItemAtPath:bundle toPath:path error:&error];
        return YES;
    }
    else {
        return NO;
    }
}

+(void)setPlistData:(NSString *)strPlistName key:(NSString *)key strValue:(NSString *)strValue{
    [self setPlist:strPlistName];
    
    NSString *path = [[self getDocsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", strPlistName]];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile:path];
    
    [data setObject:strValue forKey:key];
    //[data setObject:[NSNumber numberWithInt:strValue] forKey:key];
    
    [data writeToFile:path atomically:YES];
}

+(id)getPlistData:(NSString *)strPlistName key:(NSString *)key{
    [self setPlist:strPlistName];
    
    NSString *path = [[self getDocsDirectory] stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.plist", strPlistName]];
    NSMutableDictionary *data = [[NSMutableDictionary alloc] initWithContentsOfFile: path];
    return [data objectForKey:key];
}
@end
