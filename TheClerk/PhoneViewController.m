//
//  PhoneViewController.m
//  TheClerk
//
//  Created by Matthew Parides on 9/16/13.
//  Copyright (c) 2013 Duke. All rights reserved.
//
/* This class displays the phone book view */

#import "PhoneViewController.h"
#import "PhNumAddViewController.h"

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
    _phoneDB = [PhoneBookManager getSharedInstance];
    _phoneNumbersArray = [[NSMutableArray alloc] init];
    //_phoneNumbersArray = (NSMutableArray*)[self.phoneDB retrieveAllPhNum];
    [self loadPhoneNumbers];
                          
                          //@"(123) 456-789", @"(408) 245-2414", @"(626) 678-7048",@"5827492107",@"5209831792",@"10982378496",@"4982619386",@"2397496826",@"2001794827",@"1092748291",@"4928617384", nil];
    //_phoneOwnerArray = [[NSArray alloc] initWithObjects:@"Bob", @"Phil", @"Kevin",@"Bill",@"Matt",@"Jon",@"Zack",@"Tom", @"Chris", @"Steven", @"Bill", nil];
    _searchedNameArray = [[NSMutableArray alloc] initWithCapacity:[self.phoneNumbersArray count]];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//start Table View methods

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
        NSString *name = ((PhoneNumber*)[self.searchedNameArray objectAtIndex:indexPath.row]).name;
        cell.textLabel.text = name;
    } else {
        cell.textLabel.text = ((PhoneNumber*)[self.phoneNumbersArray objectAtIndex:indexPath.row]).name;
//cell.detailTextLabel.text = [self.phoneNumbersArray objectAtIndex:indexPath.row];
    }
    
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
    NSString* phnum = [NSString alloc];
    NSLog(@"begin");
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        phnum = ((PhoneNumber*)[[NSString alloc] initWithString:[self.searchedNameArray objectAtIndex:indexPath.row]]).number;
    }
    else {
        phnum = ((PhoneNumber*)[self.phoneNumbersArray objectAtIndex:indexPath.row]).number;
    }
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
//end table view methods

//start swipe-button methods

-(void) performFavorite:(id) sender {
       // NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[sender tag] inSection:0];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:(SWTableViewCell*)sender];
        [self.localDB savePhNum:((PhoneNumber*)[self.phoneNumbersArray objectAtIndex:indexPath.row]).name num:((PhoneNumber*)[self.phoneNumbersArray objectAtIndex:indexPath.row]).number];
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

//end swipe-button methods

//start search methods


#pragma mark Content Filtering

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
	// Update the filtered array based on the search text and scope.
	
    // Remove all objects from the filtered search array
	[self.searchedNameArray removeAllObjects];
    
	// Filter the array using NSPredicate
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.name contains[c] %@",searchText];
    NSArray *tempArray = [self.phoneNumbersArray filteredArrayUsingPredicate:predicate];
    
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



#pragma mark - UISearchBarDelegate Methods
/*
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

//end search methods


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


- (void)loadPhoneNumbers {
    [self.phoneNumbersArray addObject:[[PhoneNumber alloc] initWithName:@"Duke Clinical Laboratories " andNumber:@"613-8400"]];
    [self.phoneNumbersArray addObject:[[PhoneNumber alloc] initWithName:@"ABG" andNumber:@"681-3223"]];
    [self.phoneNumbersArray addObject:[[PhoneNumber alloc] initWithName:@"Autopsy Reports" andNumber:@"684-2457"]];
    [self.phoneNumbersArray addObject:[[PhoneNumber alloc] initWithName:@"Blood Bank" andNumber:@"681-2644"]];
    [self.phoneNumbersArray addObject:[[PhoneNumber alloc] initWithName:@"Central Collections" andNumber:@"681-2620"]];
    [self.phoneNumbersArray addObject:[[PhoneNumber alloc] initWithName:@"Central Processing (Chemistry)" andNumber:@"681-1398"]];
    [self.phoneNumbersArray addObject:[[PhoneNumber alloc] initWithName:@"Coagulation" andNumber:@"684-6366"]];
    [self.phoneNumbersArray addObject:[[PhoneNumber alloc] initWithName:@"Cytology" andNumber:@"684-3587"]];
    [self.phoneNumbersArray addObject:[[PhoneNumber alloc] initWithName:@"Cytogenetics" andNumber:@"684-6426"]];
    [self.phoneNumbersArray addObject:[[PhoneNumber alloc] initWithName:@"Fine Needle Aspirat" andNumber:@"684-3587"]];
    [self.phoneNumbersArray addObject:[[PhoneNumber alloc] initWithName:@"Flow Cytometry (CD4)" andNumber:@"684-2725"]];
    [self.phoneNumbersArray addObject:[[PhoneNumber alloc] initWithName:@"Hematology" andNumber:@"684-6738"]];
    [self.phoneNumbersArray addObject:[[PhoneNumber alloc] initWithName:@"Immunology" andNumber:@"684-2822"]];
    [self.phoneNumbersArray addObject:[[PhoneNumber alloc] initWithName:@"Microbiology/Virology" andNumber:@"684-2089"]];
    [self.phoneNumbersArray addObject:[[PhoneNumber alloc] initWithName:@"Molecular Micro/ HIV Viral Load" andNumber:@"684-3499"]];
    [self.phoneNumbersArray addObject:[[PhoneNumber alloc] initWithName:@"Pathology Central Switchboard" andNumber:@"681-3133"]];
    [self.phoneNumbersArray addObject:[[PhoneNumber alloc] initWithName:@"Phlebotomy" andNumber:@"681-6933"]];
    [self.phoneNumbersArray addObject:[[PhoneNumber alloc] initWithName:@"Sleep Study Lab" andNumber:@"681-2803"]];
    [self.phoneNumbersArray addObject:[[PhoneNumber alloc] initWithName:@"Surgical Pathology" andNumber:@"681-3909"]];
    [self.phoneNumbersArray addObject:[[PhoneNumber alloc] initWithName:@"Bone Reading Room" andNumber:@"684-7247"]];
    [self.phoneNumbersArray addObject:[[PhoneNumber alloc] initWithName:@"Emergency Department" andNumber:@"684-4462"]];
    [self.phoneNumbersArray addObject:[[PhoneNumber alloc] initWithName:@"Cardiology" andNumber:@"681-5816"]];
    [self.phoneNumbersArray addObject:[[PhoneNumber alloc] initWithName:@"" andNumber:@""]];
    [self.phoneNumbersArray addObject:[[PhoneNumber alloc] initWithName:@"" andNumber:@""]];
    [self.phoneNumbersArray addObject:[[PhoneNumber alloc] initWithName:@"" andNumber:@""]];
    [self.phoneNumbersArray addObject:[[PhoneNumber alloc] initWithName:@"" andNumber:@""]];
    [self.phoneNumbersArray addObject:[[PhoneNumber alloc] initWithName:@"" andNumber:@""]];
    [self.phoneNumbersArray addObject:[[PhoneNumber alloc] initWithName:@"" andNumber:@""]];
    [self.phoneNumbersArray addObject:[[PhoneNumber alloc] initWithName:@"" andNumber:@""]];
    [self.phoneNumbersArray addObject:[[PhoneNumber alloc] initWithName:@"" andNumber:@""]];
    [self.phoneNumbersArray addObject:[[PhoneNumber alloc] initWithName:@"" andNumber:@""]];
    [self.phoneNumbersArray addObject:[[PhoneNumber alloc] initWithName:@"" andNumber:@""]];
    [self.phoneNumbersArray addObject:[[PhoneNumber alloc] initWithName:@"" andNumber:@""]];
    [self.phoneNumbersArray addObject:[[PhoneNumber alloc] initWithName:@"" andNumber:@""]];
    [self.phoneNumbersArray addObject:[[PhoneNumber alloc] initWithName:@"" andNumber:@""]];
    [self.phoneNumbersArray addObject:[[PhoneNumber alloc] initWithName:@"" andNumber:@""]];
    [self.phoneNumbersArray addObject:[[PhoneNumber alloc] initWithName:@"" andNumber:@""]];
    [self.phoneNumbersArray addObject:[[PhoneNumber alloc] initWithName:@"" andNumber:@""]];
    [self.phoneNumbersArray addObject:[[PhoneNumber alloc] initWithName:@"" andNumber:@""]];
    [self.phoneNumbersArray addObject:[[PhoneNumber alloc] initWithName:@"" andNumber:@""]];
    [self.phoneNumbersArray addObject:[[PhoneNumber alloc] initWithName:@"" andNumber:@""]];
    [self.phoneNumbersArray addObject:[[PhoneNumber alloc] initWithName:@"" andNumber:@""]];
    [self.phoneNumbersArray addObject:[[PhoneNumber alloc] initWithName:@"" andNumber:@""]];
    

    
    
}
@end
