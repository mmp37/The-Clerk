//
//  Condition.m
//  TheClerk
//
//  Created by Matthew Parides on 11/24/13.
//  Copyright (c) 2013 Duke. All rights reserved.
//

#import "Condition.h"

@implementation Condition

-(id) initWithName:(NSString*) name text:(NSString*)text tags:(NSString*)tags dept:(NSString*)dept{
    self.name = name;
    self.text = text;
    self.tags = tags;
    self.deptName = dept;
    return self;
}

@end
