//
//  ChangTerritoryDataSource.m
//  ClarksCollection
//
//  Created by Openly on 21/11/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "ChangTerritoryDataSource.h"
#import "ClarksColors.h"
#import "ClarksFonts.h"
#import "MSCellAccessory.h"
#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>

@implementation ChangTerritoryDataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"territory-cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.text = [NSString stringWithFormat:@"Territory - %d",(int)indexPath.row];
    cell.contentView.backgroundColor = [ClarksColors clarkLightGrey];
    cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_CHECKMARK color:[ClarksColors clarkLightGrey] highlightedColor:[ClarksColors clarksButtonGreen]];
    cell.textLabel.highlightedTextColor = [ClarksColors clarksButtonGreen];
    UIView *bgColorView = [[UIView alloc] init];
    cell.textLabel.font = [ClarksFonts clarksSansProLight:16.0f ];
    bgColorView.backgroundColor = [ClarksColors clarkLightGrey];
    [cell setSelectedBackgroundView:bgColorView];
    return cell;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell
forRowAtIndexPath: (NSIndexPath*)indexPath
{
    cell.backgroundColor = [ClarksColors clarkLightGrey];
    cell.contentView.backgroundColor =[ClarksColors clarkLightGrey];
}
@end
