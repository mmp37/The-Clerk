//
//  PhNumAddViewController.m
//  TheClerk
//
//  Created by Matthew Parides on 11/30/13.
//  Copyright (c) 2013 Duke. All rights reserved.
//
/* This class presents the view used to add user-chosen phone numbers to the phone book */

#import "PhNumAddViewController.h"

@interface PhNumAddViewController ()

@end

@implementation PhNumAddViewController

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
    _phoneDB = [PhoneBookManager getSharedInstance];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)selectAndMove:(id)sender {
    [self.phoneDB savePhNum:self.nameField.text num:self.numField.text];
    [self performSegueWithIdentifier:@"NumRetSeg" sender:self];
}

- (void)dealloc {
    [_nameField release];
    [_numField release];
    [super dealloc];
}
@end
