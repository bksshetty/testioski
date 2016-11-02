//
//  Techlogos.m
//  ClarksCollection
//
//  Created by Openly on 06/07/2015.
//  Copyright (c) 2015 Clarks. All rights reserved.
//
// Class to render all the images and technology names in a static method.

#import "Techlogos.h"
#import "DataReader.h"

@implementation Techlogos

// A static variable that holds all the information regarding the tech logos.
static NSDictionary *techLogos ;
static NSDictionary *assortImages ;

// Method to retrive all tech logos.
+ (NSDictionary *) getAllTechURLS{
    if (techLogos != nil) {
        return techLogos ;
    }
    NSDictionary *data = [DataReader read];
    if ([data valueForKey:@"technologies"] != nil) {
        techLogos = [data valueForKey:@"technologies"];
    }
    return techLogos ;
}

+ (NSDictionary *) getAllAsortImages{
    if (assortImages != nil) {
        return assortImages ;
    }
    NSDictionary *data = [DataReader read];
    if ([data valueForKey:@"collection_logos"]!= nil) {
        assortImages = [data valueForKey:@"collection_logos"] ;
    }
    return assortImages ;
}
@end
