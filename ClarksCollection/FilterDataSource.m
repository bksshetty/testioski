//
//  FilterDataSource.m
//  ClarksCollection
//
//  Created by Openly on 10/10/2014.
//  Copyright (c) 2014 Clarks. All rights reserved.
//

#import "FilterDataSource.h"
#import "ClarksColors.h"
#import "MSCellAccessory.h"
#import "DataReader.h"
#import "ClarksFonts.h"

@implementation FilterDataSource

- (instancetype)init{
    if(self){
       // self.filters ;
    }
    return self;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    int count = (int)self.filters.count;
    return count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [[[self.filters objectAtIndex:section] valueForKey:@"options"] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"filter_cell";
    int section = (int)indexPath.section;
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.attributedText = [ClarksFonts addSpaceBwLetters:[[[[[self.filters objectAtIndex:section] valueForKey:@"options"] objectAtIndex: indexPath.row] valueForKey:@"name"] uppercaseString] alpha:2.0];
    cell.textLabel.font = [UIFont fontWithName:@"GillSans-Light" size:15];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = [ClarksColors gillsansDarkGray];
    cell.textLabel.frame = CGRectMake(0, 0, 200, 15);
    cell.textLabel.highlightedTextColor = [ClarksColors gillsansBlue];
    cell.accessoryView = [MSCellAccessory accessoryWithType:FLAT_CHECKMARK color:[ClarksColors clarksWhite] highlightedColor:[ClarksColors gillsansBlue]];
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [ClarksColors clarksWhite];
    [cell setSelectedBackgroundView:bgColorView];
    return cell;
}

- (void)setCellColor:(UIColor *)color ForCell:(UITableViewCell *)cell {
    cell.contentView.backgroundColor = color;
    cell.backgroundColor = color;
}

- (void)tableView: (UITableView*)tableView willDisplayCell: (UITableViewCell*)cell
forRowAtIndexPath: (NSIndexPath*)indexPath{
    cell.backgroundColor = [ClarksColors clarksWhite];
}

-(NSAttributedString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return [ClarksFonts addSpaceBwLetters:[self.filters[section] valueForKey:@"name"] alpha:2.0];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 25.0f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 20.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300, 10)];
    footerView.backgroundColor = [UIColor whiteColor];
    return footerView;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, 679, 25)];
    headerView.backgroundColor = [UIColor whiteColor];
    UITextField *lbl = [[UITextField alloc] init];
    lbl.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    lbl.attributedText = [ClarksFonts addSpaceBwLetters:[[self.filters[section] valueForKey:@"name"] uppercaseString] alpha:2.0];
    [lbl setTextColor:[ClarksColors gillsansMediumGray]];
    lbl.font = [UIFont fontWithName:@"GillSans-Light" size:11];
    lbl.frame = CGRectMake(0, 20, 679, 25);
    lbl.userInteractionEnabled =NO;
    lbl.backgroundColor = [ClarksColors gillsansBorderGray];
    lbl.alpha = 1.0;
    UIView *spacerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 12)];
    [lbl setLeftViewMode:UITextFieldViewModeAlways];
    [lbl setLeftView:spacerView];
    [headerView addSubview:lbl];
    return lbl;
}
@end