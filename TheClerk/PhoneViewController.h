//
//  PhoneViewController.h
//  TheClerk
//
//  Created by Matthew Parides on 9/16/13.
//  Copyright (c) 2013 Duke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhoneViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (retain, nonatomic) NSArray* phoneNumbersArray;
@property (retain, nonatomic) NSArray* phoneOwnerArray;

@end
