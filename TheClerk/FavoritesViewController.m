//
//  FavoritesViewController.m
//  TheClerk
//
//  Created by Matthew Parides on 9/17/13.
//  Copyright (c) 2013 Duke. All rights reserved.
//
/* this class displays the favorites view */

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
    _conditionFavs = [self.localDB retrieveAllConds];
    _numberFavs = [self.localDB retrieveAllPhNum];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    ConditionViewController* destination = segue.destinationViewController;
    destination.condition = self.selectedCondition;
}

//start table view methods

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
    static NSString *cellIdentifier = @"SimpleTableItem";
    
    SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSMutableArray *leftUtilityButtons = [NSMutableArray new];
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        
        [rightUtilityButtons addUtilityButtonWithColor:
         [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                 title:@"Problem?"];
        
        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier
                                  containingTableView:tableView // For row height and selection
                                   leftUtilityButtons:leftUtilityButtons
                                  rightUtilityButtons:rightUtilityButtons];
        cell.detailTextLabel.font = [ UIFont fontWithName: @"Arial" size: 17.0 ];
        cell.textLabel.font = [ UIFont fontWithName: @"Arial" size: 17.0 ];
        [[cell textLabel] setBackgroundColor:[UIColor clearColor]];
        [[cell detailTextLabel] setBackgroundColor:[UIColor clearColor]];
        cell.delegate = self;
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

- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    if (index == 0) {
        [self problemEmail:cell];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        self.selectedCondition = [self.conditionFavs objectAtIndex:indexPath.row];
        [self performSegueWithIdentifier:@"FavCondSeg" sender:self];
    }
    else if(indexPath.section == 1){
        NSString* phnum = [[NSString alloc] initWithString:((PhoneNumber*)[self.numberFavs objectAtIndex:indexPath.row]).number];
        phnum = [phnum stringByReplacingOccurrencesOfString:@"(" withString:@""];
        phnum = [phnum stringByReplacingOccurrencesOfString:@")" withString:@""];
        phnum = [phnum stringByReplacingOccurrencesOfString:@" " withString:@""];
        phnum = [phnum stringByReplacingOccurrencesOfString:@"-" withString:@""];
        NSLog(@"%@",phnum);
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phnum]];
    }
}

//end table view methods

//start swipe-button methods
- (void)problemEmail:(id)sender {
    // Email Subject
    NSString *emailTitle = @"The-Clerk Survival Guide Issue";
    // Email Content
    NSString *messageBody = @"Issue:";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:@"mmparides91@gmail.com"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
    
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

//end swipe-button methods

@end
