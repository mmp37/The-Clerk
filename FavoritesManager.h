//
//  FavoritesManager.h
//  TheClerk
//
//  Created by Matthew Parides on 9/28/13.
//  Copyright (c) 2013 Duke. All rights reserved.
//

#import <sqlite3.h>
#import "PhoneNumber.h"
#import "Condition.h"

@interface FavoritesManager : NSObject
{
    NSString *databasePath;
}

+(FavoritesManager*)getSharedInstance;
-(BOOL)createDB;
-(BOOL) saveCondition:(NSString*)name
        data:(NSString*)data
        tags:(NSString*)tags
        dept:(NSString*)dept;
-(BOOL) savePhNum:(NSString*)name
                 num:(NSString*)num;
-(NSArray*) findByUserName:(NSString*)name;
-(NSArray*) retrieveAllPhNum;
-(NSArray*) retrieveAllConds;

@end