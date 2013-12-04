//
//  ViewController.m
//  TheClerk
//
//  Created by Matthew Parides on 9/16/13.
//  Copyright (c) 2013 Duke. All rights reserved.
//
/* This class displays the main window of the app */

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    UIGraphicsBeginImageContext(self.view.frame.size);
    CGRect viewBounds = self.view.bounds;
    viewBounds.size.height = viewBounds.size.height - 50;
    [[UIImage imageNamed:@"background.jpg"] drawInRect:viewBounds];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:image];
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
        [self performSegueWithIdentifier:@"AddNumSeg" sender:self];
    }
    else if([((UIButton*)sender).titleLabel.text isEqualToString:@"News"]) {
        SVWebViewController *webViewController = [[SVWebViewController alloc] initWithAddress:@"http://news.medicine.duke.edu/category/medical-education/internal-medicine-residency/"];
        [self.navigationController pushViewController:webViewController animated:YES];
    }
    //}
}

- (void)dealloc {
    [_PhoneButton release];
    [_SurvivalButton release];
    [super dealloc];
}
@end
