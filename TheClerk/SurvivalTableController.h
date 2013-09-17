//
//  SurvivalTableController.h
//  TheClerk
//
//  Created by Matthew Parides on 9/17/13.
//  Copyright (c) 2013 Duke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SurvivalTableController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) NSArray * conditionNames;

@end
