//
//  ClerkCell.m
//  TheClerk
//
//  Created by Matthew Parides on 10/17/13.
//  Copyright (c) 2013 Duke. All rights reserved.
//

#import "ClerkCell.h"

@implementation ClerkCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.imageView.frame = CGRectMake(0, 0, 50, 50);
    self.detailTextLabel.frame = CGRectMake(0, 50, 130, 50);
    self.textLabel.frame = CGRectMake(0, 0, 150, 50);
    UIFont *myFont = [ UIFont fontWithName: @"Arial" size: 30.0 ];
    self.textLabel.font = myFont;
    self.accessoryView.frame = CGRectMake(150, 0, 150, 100);
}

@end
