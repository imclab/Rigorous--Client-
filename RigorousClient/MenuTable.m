//
//  MenuTable.m
//  RigorousClient
//
//  Created by Phil Plückthun on 25.12.12.
//  Copyright (c) 2012 Phil Plückthun. All rights reserved.
//

#import "MenuTable.h"
#import "StartViewController.h"
#import "MenuCell.h"

@implementation MenuTable

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [cells count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MenuCell";
    MenuCell *cell = (MenuCell *)[self dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cell == nil) {
        cell = [[MenuCell alloc] init];
    }
    
    NSMutableDictionary *temp = [cells objectAtIndex:indexPath.row];
    [[cell itemDescription] setText:[temp objectForKey:@"name"]];
    [[cell itemDescription] setTextColor:UIColorFromRGB(0xFFFFFF)];
    [NUIRenderer renderTableViewCell:cell withClass:@"MenuCell"];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary *temp = [cells objectAtIndex:indexPath.row];
    [_father setContentView:[temp objectForKey:@"key"]];
}

- (void)setFather:(StartViewController*)father {
    _father = father;
}

- (void)addMenupoint:(NSString*)desc key:(NSString*)key
{
    if (cells == nil) {
        cells = [[NSMutableArray alloc] init];
        [self setDataSource:self];
        [self setDelegate:self];
    }
    NSMutableDictionary *temp = [[NSMutableDictionary alloc] init];
    [temp setObject:desc forKey:@"name"];
    [temp setObject:key forKey:@"key"];
    [cells addObject:temp];
    [self reloadData];
}

@end
