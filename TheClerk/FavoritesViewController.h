//
//  FavoritesViewController.h
//  TheClerk
//
//  Created by Matthew Parides on 9/17/13.
//  Copyright (c) 2013 Duke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FavoritesManager.h"

@interface FavoritesViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) NSArray * conditionFavs;
@property (retain, nonatomic) NSArray * numberFavs;
@property (retain, nonatomic) FavoritesManager * localDB;

@end
