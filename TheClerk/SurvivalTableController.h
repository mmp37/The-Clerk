//
//  SurvivalTableController.h
//  TheClerk
//
//  Created by Matthew Parides on 9/17/13.
//  Copyright (c) 2013 Duke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavoritesManager.h"

@interface SurvivalTableController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) NSArray * conditionNames;
@property (retain, nonatomic) FavoritesManager * localDB;

@end
