//
//  PhoneNumber.m
//  TheClerk
//
//  Created by Matthew Parides on 9/28/13.
//  Copyright (c) 2013 Duke. All rights reserved.
//

#import "PhoneNumber.h"

@implementation PhoneNumber

-(id) initWithName:(NSString*) name andNumber:(NSString*)number{
    self.name = name;
    self.number = number;
    return self;
}


@end
