//
//  Condition.h
//  TheClerk
//
//  Created by Matthew Parides on 11/24/13.
//  Copyright (c) 2013 Duke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Condition : NSObject

@property (retain, nonatomic) NSString* name;
@property (retain, nonatomic) NSString* deptName;
@property (retain, nonatomic) NSString* text;
@property (retain, nonatomic) NSArray* imgLinks;
@property (retain, nonatomic) NSString* tags;

-(id) initWithName:(NSString*) name text:(NSString*)text tags:(NSString*)tags dept:(NSString*)dept;

@end
