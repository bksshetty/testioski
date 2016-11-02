//
//  FSHelper.m
//  Clarks Collection
//
//  Created by Openly on 08/09/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import "FSHelper.h"

@implementation FSHelper

+ (NSString *) fullPathFor :(NSString *)path{
    NSArray *paths = NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory ;
    NSString *fileName ;
    if ((paths != nil) && ([paths count]!= 0) ) {
        documentsDirectory  = [paths objectAtIndex:0];
        fileName = [NSString stringWithFormat:@"%@/%@",
                    documentsDirectory, path];
    }
    return fileName;
}

+ (NSData *) dataFromFile: (NSString *)file{
    return [NSData dataWithContentsOfFile:file];
}

+ (void) data: (NSData *) data toFile:(NSString *) file{
    [data writeToFile:file atomically:YES];
}

+ (BOOL) fileExists: (NSString *) path{
    return [[NSFileManager defaultManager]fileExistsAtPath:path];
}

+ (NSString *) localPath: (NSString *) location{
    if(location == nil){
        return nil;
    }
    @autoreleasepool {
        NSError *error ;
        NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"_(\\w\\w\\w\\w?)$" options:0 error:&error];
        NSRegularExpression *regex1 = [NSRegularExpression regularExpressionWithPattern:@"\\W+" options:0 error:&error];
        NSString *filePath = [regex1 stringByReplacingMatchesInString:location options:0 range:NSMakeRange(0, [location length]) withTemplate:@"_"];
        filePath = [regex stringByReplacingMatchesInString:filePath options:0 range:NSMakeRange(0, [filePath length]) withTemplate:@".$1"];
        filePath = [FSHelper fullPathFor:filePath];
        return filePath;
    }
}
@end
