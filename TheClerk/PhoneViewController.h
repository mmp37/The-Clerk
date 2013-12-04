//
//  PhoneViewController.h
//  TheClerk
//
//  Created by Matthew Parides on 9/16/13.
//  Copyright (c) 2013 Duke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavoritesManager.h"
#import <MessageUI/MessageUI.h> 
#import "SWTableViewCell.h"
#import "PhoneNumber.h"
#import "PhoneBookManager.h"

@interface PhoneViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, SWTableViewCellDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (retain, nonatomic) NSMutableArray* phoneNumbersArray;
//@property (retain, nonatomic) NSArray* phoneOwnerArray;
@property (retain, nonatomic) FavoritesManager* localDB;
@property (retain, nonatomic) PhoneBookManager* phoneDB;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) NSMutableArray* searchedNameArray;

- (void) performFavorite:(id)sender;
- (void)problemEmail:(id)sender;
- (void)loadPhoneNumbers;
@end
