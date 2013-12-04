//
//  NewsViewController.m
//  TheClerk
//
//  Created by Matthew Parides on 11/17/13.
//  Copyright (c) 2013 Duke. All rights reserved.
//
/* This class displays the web view of the duke internal medicine bulletin */

#import "NewsViewController.h"

@interface NewsViewController ()

@end

@implementation NewsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//this class usees the SVWebViewController to display the internal medicine bulletin
- (void)viewDidLoad
{
    NSURLRequest *request = [NSURLRequest requestWithURL:
                             [NSURL URLWithString:@"http://news.medicine.duke.edu/category/medical-education/internal-medicine-residency/"]] ;
    
    [self.webView loadRequest:request] ;
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [_webView release];
    [super dealloc];
}
@end
