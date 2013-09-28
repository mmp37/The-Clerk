//
//  PhoneNumber.h
//  TheClerk
//
//  Created by Matthew Parides on 9/28/13.
//  Copyright (c) 2013 Duke. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhoneNumber : NSObject

@property (retain, nonatomic) NSString* name;
@property (retain, nonatomic) NSString* number;

-(id) initWithName:(NSString*) name andNumber:(NSString*)number;

@end
