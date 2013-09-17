//
//  ViewController.h
//  TheClerk
//
//  Created by Matthew Parides on 9/16/13.
//  Copyright (c) 2013 Duke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (retain, nonatomic) IBOutlet UIButton *PhoneButton;
@property (retain, nonatomic) IBOutlet UIButton *SurvivalButton;

-(IBAction)selectAndMove:(id)sender;

@end
