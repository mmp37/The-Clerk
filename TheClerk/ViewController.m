//
//  ViewController.m
//  TheClerk
//
//  Created by Matthew Parides on 9/16/13.
//  Copyright (c) 2013 Duke. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)selectAndMove:(id)sender
{
    if([((UIButton*)sender).titleLabel.text isEqualToString:@"Phone Book"]) {
        [self performSegueWithIdentifier:@"PhoneBookSeg" sender:self];
    }
    else if([((UIButton*)sender).titleLabel.text isEqualToString:@"Survival Guide"]) {
        [self performSegueWithIdentifier:@"SurvivalGuideSeg" sender:self];
    }
    else if([((UIButton*)sender).titleLabel.text isEqualToString:@"Favorites"]) {
        [self performSegueWithIdentifier:@"FavsSeg" sender:self];
    }
    else if([((UIButton*)sender).titleLabel.text isEqualToString:@"Settings"]) {
        [self performSegueWithIdentifier:@"SettingsSeg" sender:self];
    }
    //}
}

- (void)dealloc {
    [_PhoneButton release];
    [_SurvivalButton release];
    [super dealloc];
}
@end
