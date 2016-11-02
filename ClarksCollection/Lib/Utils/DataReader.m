//
//  DataReader.m
//  ClarksCollection
//
//  Created by Abhilash Hebbar on 27/05/15.
//  Copyright (c) 2015 Clarks. All rights reserved.
//

#import "DataReader.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation DataReader
+ (NSDictionary *) read{
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/data.json",
                          documentsDirectory];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fileName];
    if (!fileExists) {
        return @{@"version": @0};
    }
    NSString *dataFile = fileName;
    NSError *e = nil;
    NSData *jsonData = [NSData dataWithContentsOfFile:dataFile ];
    NSDictionary *data ;
    if(jsonData != NULL){
        data = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&e];
    }
    return data;
}

+ (NSDictionary *) read1{
    NSArray *paths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *fileName = [NSString stringWithFormat:@"%@/data1.json",
                          documentsDirectory];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fileName];
    if (!fileExists) {
        return @{@"version": @0};
    }
    NSString *dataFile = fileName;
    NSError *e = nil;
    NSData *jsonData = [NSData dataWithContentsOfFile:dataFile ];
    NSDictionary *data ;
    if(jsonData != NULL){
        data = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&e];
    }
    return data;
}

+ (BOOL) hasData{
    NSArray *paths = NSSearchPathForDirectoriesInDomains
                        (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    //make a file name to write the data to using the documents directory:
    NSString *fileName = [NSString stringWithFormat:@"%@/data.json",
                          documentsDirectory];
    return [[NSFileManager defaultManager] fileExistsAtPath:fileName];
}
@end

