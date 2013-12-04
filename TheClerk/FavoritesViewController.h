//
//  FavoritesViewController.h
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
#import "PhoneNumber.h"
#import "ConditionViewController.h"

@interface FavoritesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, SWTableViewCellDelegate>

@property (retain, nonatomic) NSArray * conditionFavs;
@property (retain, nonatomic) NSArray * numberFavs;
@property (retain, nonatomic) FavoritesManager * localDB;
@property (retain, nonatomic) Condition* selectedCondition;

- (void)problemEmail:(id)sender;

@end
