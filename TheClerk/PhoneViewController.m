//
//  PhoneViewController.m
//  TheClerk
//
//  Created by Matthew Parides on 9/16/13.
//  Copyright (c) 2013 Duke. All rights reserved.
//

#import "PhoneViewController.h"

@interface PhoneViewController ()

@end

@implementation PhoneViewController

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
    _phoneNumbersArray = [[NSArray alloc] initWithObjects:@"(123) 456-789", @"(408) 245-2414", @"(626) 678-7048",@"1111111111",@"1111111111",@"1111111111",@"1111111111",@"1111111111",@"1111111111",@"1111111111",@"1111111111", nil];
    _phoneOwnerArray = [[NSArray alloc] initWithObjects:@"Bob", @"Phil", @"Kevin",@"Bill",@"Bill",@"Bill",@"Bill",@"Bill", @"Bill", @"Bill", @"Bill", nil];
    _searchedNameArray = [[NSMutableArray alloc] initWithCapacity:[self.phoneOwnerArray count]];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Phone Book";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [self.searchedNameArray count];
        
    }
    else {
        return [self.phoneNumbersArray count];
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 100;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        NSMutableArray *leftUtilityButtons = [NSMutableArray new];
        NSMutableArray *rightUtilityButtons = [NSMutableArray new];
        
//        [leftUtilityButtons addUtilityButtonWithColor:
//         [UIColor colorWithRed:0.07 green:0.75f blue:0.16f alpha:1.0]
//                                                 icon:[UIImage imageNamed:@"check.png"]];
//        [leftUtilityButtons addUtilityButtonWithColor:
//         [UIColor colorWithRed:1.0f green:1.0f blue:0.35f alpha:1.0]
//                                                 icon:[UIImage imageNamed:@"clock.png"]];
//        [leftUtilityButtons addUtilityButtonWithColor:
//         [UIColor colorWithRed:1.0f green:0.231f blue:0.188f alpha:1.0]
//                                                 icon:[UIImage imageNamed:@"cross.png"]];
//        [leftUtilityButtons addUtilityButtonWithColor:
//         [UIColor colorWithRed:0.55f green:0.27f blue:0.07f alpha:1.0]
//                                                 icon:[UIImage imageNamed:@"list.png"]];
        
        [rightUtilityButtons addUtilityButtonWithColor:
         [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                 title:@"Problem?"];
        [rightUtilityButtons addUtilityButtonWithColor:
         [UIColor colorWithRed:0.0f green:0.231f blue:0.188 alpha:1.0f]
                                                 title:@"Favorite"];
        
        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:cellIdentifier
                                  containingTableView:_tableView // For row height and selection
                                   leftUtilityButtons:leftUtilityButtons
                                  rightUtilityButtons:rightUtilityButtons];
        cell.detailTextLabel.font = [ UIFont fontWithName: @"Arial" size: 17.0 ];
        cell.textLabel.font = [ UIFont fontWithName: @"Arial" size: 17.0 ];
        [[cell textLabel] setBackgroundColor:[UIColor clearColor]];
        [[cell detailTextLabel] setBackgroundColor:[UIColor clearColor]];
        cell.delegate = self;
    }
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        NSString *name = [self.searchedNameArray objectAtIndex:indexPath.row];
        cell.textLabel.text = name;
        int index = [self.phoneOwnerArray indexOfObjectIdenticalTo:name];
        cell.detailTextLabel.text = [self.phoneNumbersArray objectAtIndex:index];
    } else {
        cell.textLabel.text = [self.phoneOwnerArray objectAtIndex:indexPath.row];
        cell.detailTextLabel.text = [self.phoneNumbersArray objectAtIndex:indexPath.row];
    }
    
  //  cell.detailTextLabel.text = [self.phoneNumbersArray objectAtIndex:indexPath.row];
  //  cell.textLabel.text = [self.phoneOwnerArray objectAtIndex:indexPath.row];
    //ClerkCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//    SWTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
//    
//    if (cell == nil) {
//        //cell = [[ClerkCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
//        cell = [[SWTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:simpleTableIdentifier];
//    }
//    
//    
//    
//    cell.detailTextLabel.text = [self.phoneNumbersArray objectAtIndex:indexPath.row];
//    cell.textLabel.text = [self.phoneOwnerArray objectAtIndex:indexPath.row];
    
//    UIView *buttonView = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 100.0f)];
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    button.frame = CGRectMake(0.0f, 0.0f, 150.0f, 50.0f);
//    
//    [button setTitle:@"Favorite"
//            forState:UIControlStateNormal];
//    
//    [button addTarget:self
//               action:@selector(performFavorite:)
//     forControlEvents:UIControlEventTouchUpInside];
//    [button setTag:indexPath.row];
//    UIButton *problemButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//    problemButton.frame = CGRectMake(0.0f, 50.0f, 150.0f, 50.0f);
//    
//    [problemButton setTitle:@"Problem?"
//            forState:UIControlStateNormal];
//    
//    [problemButton addTarget:self
//               action:@selector(problemEmail:)
//     forControlEvents:UIControlEventTouchUpInside];
//    [problemButton setTag:indexPath.row];
//    [buttonView addSubview:button];
//    [buttonView addSubview:problemButton];
//    cell.accessoryView = buttonView;

    
    
    return cell;
}

- (void)swippableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    if (index == 0) {
        [self problemEmail:cell];
    }
    else if(index == 1) {
        [self performFavorite:cell];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* phnum = [[NSString alloc] initWithString:[self.phoneNumbersArray objectAtIndex:indexPath.row]];
    phnum = [phnum stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phnum = [phnum stringByReplacingOccurrencesOfString:@")" withString:@""];
    phnum = [phnum stringByReplacingOccurrencesOfString:@" " withString:@""];
    phnum = [phnum stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSLog(@"%@",phnum);
    phnum = [NSString stringWithFormat:@"%@%@", @"tel://", phnum];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phnum]];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return YES if you want the specified item to be editable.
    return YES;
}

-(void) performFavorite:(id) sender {
       // NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:(SWTableViewCell*)sender];
        [self.localDB savePhNum:[self.phoneOwnerArray objectAtIndex:indexPath.row] num:[self.phoneNumbersArray objectAtIndex:indexPath.row]];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Favorited"
                                                        message:@"This item has been added to your favorites!"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
}

- (void)problemEmail:(id)sender {
    // Email Subject
    NSString *emailTitle = @"The-Clerk Phonebook Issue";
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


#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	// Update the filtered array based on the search text and scope.
	
    // Remove all objects from the filtered search array
	[self.searchedNameArray removeAllObjects];
    
	// Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF contains[c] %@",searchText];
    NSArray *tempArray = [self.phoneOwnerArray filteredArrayUsingPredicate:predicate];
    
   /* if(![scope isEqualToString:@"All"]) {
        // Further filter the array with the scope
        NSPredicate *scopePredicate = [NSPredicate predicateWithFormat:@"SELF.category contains[c] %@",scope];
        tempArray = [tempArray filteredArrayUsingPredicate:scopePredicate];
    }*/
    
    self.searchedNameArray = [NSMutableArray arrayWithArray:tempArray];
}


#pragma mark - UISearchDisplayController Delegate Methods

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    // Tells the table data source to reload when text changes
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    // Tells the table data source to reload when scope bar selection changes
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    // Return YES to cause the search result table view to be reloaded.
    return YES;
}

#pragma mark - Search Button

- (IBAction)goToSearch:(id)sender
{
    // If you're worried that your users might not catch on to the fact that a search bar is available if they scroll to reveal it, a search icon will help them
    // Note that if you didn't hide your search bar, you should probably not include this, as it would be redundant
    [self.searchBar becomeFirstResponder];
}


/*
#pragma mark - UISearchBarDelegate Methods
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    //move the search bar up to the correct location eg
    [UIView animateWithDuration:.4
                     animations:^{
                         searchBar.frame = CGRectMake(searchBar.frame.origin.x,
                                                      0,
                                                      searchBar.frame.size.width,
                                                      searchBar.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         //whatever else you may need to do
                     }];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    //move the search bar down to the correct location eg
    [UIView animateWithDuration:.4
                     animations:^{
                         searchBar.frame = CGRectMake(searchBar.frame.origin.x,
                                                      searchBar.frame.origin.y,
                                                      searchBar.frame.size.width,
                                                      searchBar.frame.size.height);
                     }
                     completion:^(BOOL finished){
                         //whatever else you may need to do
                     }];
}
*/

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    UISearchBar *searchBar = self.searchDisplayController.searchBar;
    CGRect rect = searchBar.frame;
    rect.origin.y = MIN(0, scrollView.contentOffset.y);
    searchBar.frame = rect;
}

//// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        [self.localDB savePhNum:[self.phoneOwnerArray objectAtIndex:indexPath.row] num:[self.phoneNumbersArray objectAtIndex:indexPath.row]];
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Favorited"
//                                                        message:@"This item has been added to your favorites!"
//                                                       delegate:nil
//                                              cancelButtonTitle:@"OK"
//                                              otherButtonTitles:nil];
//        [alert show];
//        [alert release];
//    }
//}
//
//-(NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath {
//    return @"Favorite";
//}

- (void)dealloc {
    [_tableView release];
    [_searchBar release];
    [super dealloc];
}
@end
