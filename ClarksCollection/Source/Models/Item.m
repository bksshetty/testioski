//
//  Item.m
//  Clarks Collection
//
//  Created by Openly on 04/09/2014.
//  Copyright (c) 2014 Openly. All rights reserved.
//

#import "ItemColor.h"
#import "Item.h"
#import "ClarksUI.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation Item

-(NSString *)giveMeValidString:(NSString *) strTest {
    if([strTest isKindOfClass:[NSString class]]) {
        if(strTest != nil)
            return strTest;
    }
    return @"";
}

- (NSMutableArray *) convertArrayElementsToLowCase: (NSMutableArray *) arr {
    NSMutableArray *tmpArray = [[NSMutableArray alloc]initWithCapacity:[arr count]];
    for(NSString *ele in arr) {
        [tmpArray addObject:[ele lowercaseString]];
    }
    return tmpArray;
}

- (BOOL) checkIfArray: (NSDictionary *)dict{
    if([[dict valueForKey:@"must_haves"] isKindOfClass:[NSMutableArray class]]||
       [[dict valueForKey:@"technologies"] isKindOfClass:[NSMutableArray class]]||
       [[dict valueForKey:@"style_profile"] isKindOfClass:[NSMutableArray class]]||
       [[dict valueForKey:@"gender"] isKindOfClass:[NSMutableArray class]]||
       [[dict valueForKey:@"trading_event"] isKindOfClass:[NSMutableArray class]]||
       [[dict valueForKey:@"collaborations"] isKindOfClass:[NSMutableArray class]]||
       [[dict valueForKey:@"additional_feature"] isKindOfClass:[NSMutableArray class]]||
       [[dict valueForKey:@"fit_options"] isKindOfClass:[NSMutableArray class]]
       ){
        return true ;
    }
    else{
        return false ;
    }
}

- (Item *) initWithDict: (NSDictionary *) dict{
    if ([self init]) {
        
        self.name = [self giveMeValidString:[dict valueForKey:@"name"]];
        self.image= [self giveMeValidString:[dict valueForKey:@"thumb"]];
        self.sole = [self giveMeValidString:[dict valueForKey:@"sole"]];
        self.construction= [self giveMeValidString:[dict valueForKey:@"construction"]];
        self.lining = [self giveMeValidString:[dict valueForKey:@"lining"]];
        self.sock = [self giveMeValidString:[dict valueForKey:@"sock"]];
        self.upperMaterial= [self  giveMeValidString:[dict valueForKey:@"upper_material"]];
        self.fit = [self  giveMeValidString:[dict valueForKey:@"fit"]];
        self.size = [self  giveMeValidString:[dict valueForKey:@"size"]];
        self.regionName = [self giveMeValidString:[dict valueForKey:@"regionName"]];
        self.upper = [self giveMeValidString:[dict valueForKey:@"upper"]];
        self.length = [self giveMeValidString:[dict valueForKey:@"length"]];
        self.width = [self giveMeValidString:[dict valueForKey:@"width"]];
        self.height = [self giveMeValidString:[dict valueForKey:@"height"]];
        
        // Map array values
        
        if([dict valueForKey:@"tier"] != nil &&
           [[dict valueForKey:@"tier"] isKindOfClass:[NSArray class]]){
            self.tier = [[dict valueForKey:@"tier"] mutableCopy];
        }
        else if ([dict valueForKey:@"tier"] != nil){
            [self.tier  addObject:[dict valueForKey:@"tier"]] ;
        }
        
        if([dict valueForKey:@"must_haves"] != nil &&
           [[dict valueForKey:@"must_haves"] isKindOfClass:[NSArray class]]){
            self.mustHaves = [[dict valueForKey:@"must_haves"] mutableCopy];
        }
        else if ([dict valueForKey:@"must_haves"] != nil){
            [self.mustHaves  addObject:[dict valueForKey:@"must_haves"]] ;
        }
        
        if([dict valueForKey:@"technologies"] != nil &&
           [[dict valueForKey:@"technologies"] isKindOfClass:[NSArray class]]){
            self.technologies = [[dict valueForKey:@"technologies"] mutableCopy];
        }
        else if ([dict valueForKey:@"technologies"] != nil){
            [self.technologies  addObject:[dict valueForKey:@"technologies"]] ;
        }
        
        if([dict valueForKey:@"style_profile"] != nil &&
           [[dict valueForKey:@"style_profile"] isKindOfClass:[NSArray class]]){
            self.profile = [[dict valueForKey:@"style_profile"] mutableCopy];
        }
        else if ([dict valueForKey:@"style_profile"] != nil){
            [self.profile  addObject:[dict valueForKey:@"style_profile"]] ;
        }
        
        if([dict valueForKey:@"gender"] != nil &&
           [[dict valueForKey:@"gender"] isKindOfClass:[NSArray class]]){
            self.gender = [[dict valueForKey:@"gender"] mutableCopy];
        }
        else if ([dict valueForKey:@"gender"] != nil){
            [self.gender  addObject:[dict valueForKey:@"gender"]] ;
        }
        
        if([dict valueForKey:@"trading_event"] != nil &&
           [[dict valueForKey:@"trading_event"] isKindOfClass:[NSArray class]]){
            self.tradingEvent = [[dict valueForKey:@"trading_event"] mutableCopy];
        }
        else if ([dict valueForKey:@"trading_event"] != nil){
            [self.tradingEvent  addObject:[dict valueForKey:@"trading_event"]] ;
        }
        
        if([dict valueForKey:@"collaborations"] != nil &&
           [[dict valueForKey:@"collaborations"] isKindOfClass:[NSArray class]]){
            self.collaborations = [[dict valueForKey:@"collaborations"] mutableCopy];
        }
        else if ([dict valueForKey:@"collaborations"] != nil){
            [self.collaborations  addObject:[dict valueForKey:@"collaborations"]] ;
        }
        
        if([dict valueForKey:@"additional_feature"] != nil &&
           [[dict valueForKey:@"additional_feature"] isKindOfClass:[NSArray class]]){
            self.additionalFeature = [[dict valueForKey:@"additional_feature"] mutableCopy];
        }
        else if ([dict valueForKey:@"additional_feature"] != nil){
            [self.additionalFeature  addObject:[dict valueForKey:@"additional_feature"]] ;
        }
        
        if([dict valueForKey:@"fit_options"] != nil &&
           [[dict valueForKey:@"fit_options"] isKindOfClass:[NSArray class]]){
            self.fitOptions = [[dict valueForKey:@"fit_options"] mutableCopy];
        }
        else if ([dict valueForKey:@"fit_options"] != nil){
            [self.fitOptions  addObject:[dict valueForKey:@"fit_options"]] ;
        }
        
        if([dict valueForKey:@"trend"] != nil &&
           [[dict valueForKey:@"trend"] isKindOfClass:[NSArray class]]){
            self.trend = [[dict valueForKey:@"trend"] mutableCopy];
        }
        else if ([dict valueForKey:@"trend"] != nil){
            [self.trend  addObject:[dict valueForKey:@"trend"]] ;
        }
        
        if([dict valueForKey:@"signature_detail"] != nil &&
           [[dict valueForKey:@"signature_detail"] isKindOfClass:[NSArray class]]){
            self.signatureDetail = [[dict valueForKey:@"signature_detail"] mutableCopy];
        }
        else if ([dict valueForKey:@"signature_detail"] != nil){
            [self.signatureDetail  addObject:[dict valueForKey:@"signature_detail"]] ;
        }
        
        if([dict valueForKey:@"new_cont"] != nil &&
           [[dict valueForKey:@"new_cont"] isKindOfClass:[NSArray class]]){
            self.newcont= [[dict valueForKey:@"new_cont"] mutableCopy];
        }
        else if ([dict valueForKey:@"new_cont"] != nil){
            [self.newcont  addObject:[dict valueForKey:@"new_cont"]] ;
        }
        
        if([dict valueForKey:@"as_advertised"] != nil &&
           [[dict valueForKey:@"as_advertised"] isKindOfClass:[NSArray class]]){
            self.asAdvertised = [[dict valueForKey:@"as_advertised"] mutableCopy];
        }
        else if ([dict valueForKey:@"as_advertised"] != nil){
            [self.asAdvertised  addObject:[dict valueForKey:@"as_advertised"]] ;
        }
        
        if([dict valueForKey:@"construction_technique"] != nil &&
           [[dict valueForKey:@"construction_technique"] isKindOfClass:[NSArray class]]){
            self.constructionTechnique = [[dict valueForKey:@"construction_technique"] mutableCopy];
        }
        else if ([dict valueForKey:@"construction_technique"] != nil){
            [self.constructionTechnique  addObject:[dict valueForKey:@"construction_technique"]] ;
        }
        
        if([dict valueForKey:@"story"] != nil &&
           [[dict valueForKey:@"story"] isKindOfClass:[NSArray class]]){
            self.story = [[dict valueForKey:@"story"] mutableCopy];
        }
        else if ([dict valueForKey:@"story"] != nil){
            [self.story  addObject:[dict valueForKey:@"story"]] ;
        }
        
        if([dict valueForKey:@"guided_assortment_arr"] != nil &&
           [[dict valueForKey:@"guided_assortment_arr"] isKindOfClass:[NSArray class]]){
            self.guidedAssortmentArr = [[dict valueForKey:@"guided_assortment_arr"] mutableCopy];
            self.isGA = YES;
        }
        else if ([dict valueForKey:@"guided_assortment_arr"] != nil){
            [self.guidedAssortmentArr  addObject:[dict valueForKey:@"guided_assortment_arr"]] ;
            self.isGA = YES;
        }
        
        if (self.tier != nil) {
            self.tier = [self convertArrayElementsToLowCase:self.tier] ;
        }
        if(self.mustHaves != nil) {
            self.mustHaves = [self convertArrayElementsToLowCase: self.mustHaves];
        }
        if(self.technologies != nil) {
            self.technologies = [self convertArrayElementsToLowCase: self.technologies];
        }
        if (self.guidedAssortmentArr != nil) {
            self.guidedAssortmentArr = [self convertArrayElementsToLowCase: self.guidedAssortmentArr];
        }
        if(self.profile != nil) {
            self.profile = [self convertArrayElementsToLowCase: self.profile];
        }
        if(self.gender != nil) {
            self.gender = [self convertArrayElementsToLowCase: self.gender];
        }
        if(self.tradingEvent != nil) {
            self.tradingEvent = [self convertArrayElementsToLowCase: self.tradingEvent];
        }
        if(self.collaborations != nil) {
            self.collaborations = [self convertArrayElementsToLowCase: self.collaborations];
        }
        if(self.additionalFeature != nil) {
            self.additionalFeature = [self convertArrayElementsToLowCase: self.additionalFeature];
        }
        if(self.fitOptions != nil) {
            self.fitOptions = [self convertArrayElementsToLowCase: self.fitOptions];
        }
        if(self.trend != nil) {
            self.trend = [self convertArrayElementsToLowCase: self.trend];
        }
        if(self.signatureDetail != nil) {
            self.signatureDetail = [self convertArrayElementsToLowCase: self.signatureDetail];
        }
        if(self.newcont != nil) {
            self.newcont = [self convertArrayElementsToLowCase: self.newcont];
        }
        if(self.asAdvertised != nil) {
            self.asAdvertised = [self convertArrayElementsToLowCase: self.asAdvertised];
        }
        if(self.story != nil) {
            self.story = [self convertArrayElementsToLowCase: self.story];
        }
        if(self.constructionTechnique != nil) {
            self.constructionTechnique = [self convertArrayElementsToLowCase: self.constructionTechnique];
        }
        if ([[dict valueForKey:@"featured"] boolValue] == 1) {
            self.isFeatured = YES;
        }else{
            self.isFeatured = NO;
        }
        self.heelHeight = [self giveMeValidString:[dict valueForKey:@"heel_height"]];
        NSArray *curColors = [dict valueForKey:@"colors"];
        NSMutableArray *colors = [[NSMutableArray alloc] init];
        for (int i =0; i<[curColors count]; i++) {
            [colors addObject:[[ItemColor alloc] initWithDict: curColors[i]]];
        }
        self.colors = colors;
        ItemColor *theColors;
        self.has360 = NO;
        for(theColors in colors){
            if([theColors.images360 count] > 0){
                self.has360 = YES;
                break;
            }
        }
        //Some garbage code find if the image is A
        if ([self.image rangeOfString:@"_A.jpg"].location != NSNotFound) {
            for(theColors in colors){
                for(NSString *thumbImage in theColors.thumbs){
                    if ([self.image rangeOfString:@"_T.jpg"].location != NSNotFound) {
                        self.image = thumbImage;
                        CLSNSLog(@"Item: initWithDict: Exit");
                        return self;
                    }
                }
            }
        }
    }
    return self;
}

-(void) markItemAsSelected;{
    [self setItemSelectionState:YES];
    return;
}

-(void) markItemAsDeselected {
    [self setItemSelectionState:NO];
    return;
}

-(void) setItemSelectionState:(BOOL) withState {
    self.isSelected = withState;
    for(ItemColor *theColor in self.colors) {
        theColor.isSelected = withState;
     }
}
@end

