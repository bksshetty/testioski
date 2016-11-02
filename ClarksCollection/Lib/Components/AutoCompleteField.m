//
//  AutoCompleteField.m
//  ClarksCollection
//
//  Created by Adarsh on 21/07/2016.
//  Copyright © 2016 Clarks. All rights reserved.
//

#import "AutoCompleteField.h"
#import "ClarksColors.h"
#import "ClarksFonts.h"

@implementation AutoCompleteField

@synthesize autocompleteTableView;
@synthesize autocompleteUrls;

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.delegate = self;
        
        autocompleteTableView = [[UITableView alloc] initWithFrame:
                                 CGRectMake(0, 0, 533, 130) style:UITableViewStylePlain];
        autocompleteTableView.delegate =  self;
        autocompleteTableView.dataSource = self;
        autocompleteTableView.scrollEnabled = YES;
        autocompleteTableView.backgroundColor = [UIColor whiteColor];
        [autocompleteTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        autocompleteTableView.hidden = YES;
        autocompleteTableView.layer.borderColor = [ClarksColors clarksGreen].CGColor;
        autocompleteTableView.layer.borderWidth = 1 ;
        [autocompleteTableView setAllowsSelection:YES];
        if ([autocompleteTableView respondsToSelector:@selector(setSeparatorInset:)]) {
            [autocompleteTableView setSeparatorInset:UIEdgeInsetsZero];
        }
        [self addSubview:autocompleteTableView];
    }
    return self;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    autocompleteTableView.hidden = YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    return autocompleteUrls.count;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = nil;
    static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
    }
    cell.backgroundColor = [UIColor whiteColor];
    cell.textLabel.textColor = [UIColor blackColor];
    cell.textLabel.font = [ClarksFonts clarksSansProThin:16.0f];
    cell.textLabel.text = [autocompleteUrls objectAtIndex:indexPath.row];
    cell.separatorInset = UIEdgeInsetsZero;
    return cell;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSString *substring = [textField.text lowercaseString];
    substring = [substring stringByReplacingCharactersInRange:range withString:string];
    [self searchAutocompleteEntriesWithSubstring:[substring lowercaseString]];
    return YES;
}

- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    [autocompleteUrls removeAllObjects];
    for(NSString *curString in self.userList) {
        NSRange substringRange = [curString  rangeOfString:substring];
        if (substringRange.location == 0) {
            [autocompleteUrls addObject:curString];
        }
    }
    [autocompleteTableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"Index Path row: %ld and User Name is: %@", (long)indexPath.row, selectedCell.textLabel.text);
    self.text = selectedCell.textLabel.text;
    [self resignFirstResponder];
    autocompleteTableView.hidden = YES;
}


- (BOOL)textFieldShouldClear:(UITextField *)textField{
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

@end
