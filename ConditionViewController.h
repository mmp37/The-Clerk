//
//  ConditionViewController.h
//  TheClerk
//
//  Created by Matthew Parides on 11/24/13.
//  Copyright (c) 2013 Duke. All rights reserved.
//

#import "ViewController.h"
#import "Condition.h"

@interface ConditionViewController : ViewController

@property (retain, nonatomic) Condition* condition;
@property (retain, nonatomic) IBOutlet UITextView *textView;

@end
