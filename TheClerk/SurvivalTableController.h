//
//  SurvivalTableController.h
//  TheClerk
//
//  Created by Matthew Parides on 9/17/13.
//  Copyright (c) 2013 Duke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavoritesManager.h"
#import "SWTableViewCell.h"
#import <MessageUI/MessageUI.h>
#import "Condition.h"
#import "ConditionViewController.h"

@interface SurvivalTableController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, SWTableViewCellDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

@property (retain, nonatomic) NSMutableArray * conditions;
@property (retain, nonatomic) IBOutlet UITableView *tableView;
@property (retain, nonatomic) FavoritesManager * localDB;
@property (retain, nonatomic) NSMutableArray* searchedConditionsArray;
@property (retain, nonatomic) IBOutlet UISearchBar *searchBar;
@property (retain, nonatomic) Condition* selectedCondition;

-(void) loadConditions;

@end
