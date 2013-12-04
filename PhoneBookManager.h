//
//  PhoneBookManager.h
//  TheClerk
//
//  Created by Matthew Parides on 11/30/13.
//  Copyright (c) 2013 Duke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import "PhoneNumber.h"

@interface PhoneBookManager : NSObject
{
    sqlite3 *_database;
}

+(PhoneBookManager*)getSharedInstance;
-(BOOL) savePhNum:(NSString*)name
              num:(NSString*)num;
-(NSArray*) retrieveAllPhNum;

@end
