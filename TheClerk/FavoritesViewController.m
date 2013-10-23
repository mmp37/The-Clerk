//
//  FavoritesViewController.m
//  TheClerk
//
//  Created by Matthew Parides on 9/17/13.
//  Copyright (c) 2013 Duke. All rights reserved.
//

#import "FavoritesViewController.h"

@interface FavoritesViewController ()

@end

@implementation FavoritesViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _localDB = [FavoritesManager getSharedInstance];
    _conditionFavs = [self.localDB retrieveAll:@"favconds"];
    _numberFavs = [self.localDB retrieveAll:@"favphnums"];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Conditions";
    }
    else if (section == 1) {
        return @"Phone Numbers";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {
        return [self.conditionFavs count];
    }
    else if(section == 1) {
        return [self.numberFavs count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
    }
    
    if(indexPath.section == 0) {
        cell.textLabel.text = ((PhoneNumber*)[self.conditionFavs objectAtIndex:indexPath.row]).name;
    }
    else if(indexPath.section == 1) {
        cell.textLabel.text = ((PhoneNumber*)[self.numberFavs objectAtIndex:indexPath.row]).name;
        cell.detailTextLabel.text = ((PhoneNumber*)[self.numberFavs objectAtIndex:indexPath.row]).number;
        NSLog(@"%@",((PhoneNumber*)[self.numberFavs objectAtIndex:indexPath.row]).number);
    }
    //cell.detailTextLabel.text = [self.phoneOwnerArray objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 1){
        NSString* phnum = [[NSString alloc] initWithString:((PhoneNumber*)[self.numberFavs objectAtIndex:indexPath.row]).number];
        phnum = [phnum stringByReplacingOccurrencesOfString:@"(" withString:@""];
        phnum = [phnum stringByReplacingOccurrencesOfString:@")" withString:@""];
        phnum = [phnum stringByReplacingOccurrencesOfString:@" " withString:@""];
        phnum = [phnum stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSLog(@"%@",phnum);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phnum]];
    }
}

@end
