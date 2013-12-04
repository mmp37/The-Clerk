//
//  PhNumAddViewController.h
//  TheClerk
//
//  Created by Matthew Parides on 11/30/13.
//  Copyright (c) 2013 Duke. All rights reserved.
//

#import "ViewController.h"
#import "PhoneBookManager.h"

@interface PhNumAddViewController : ViewController


@property (retain, nonatomic) PhoneBookManager* phoneDB;
@property (retain, nonatomic) IBOutlet UITextField *nameField;
@property (retain, nonatomic) IBOutlet UITextField *numField;

-(IBAction)selectAndMove:(id)sender;

@end
