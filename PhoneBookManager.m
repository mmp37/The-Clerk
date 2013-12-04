//
//  PhoneBookManager.m
//  TheClerk
//
//  Created by Matthew Parides on 11/30/13.
//  Copyright (c) 2013 Duke. All rights reserved.
//
/* This class handles interaction with the database containing phone number information */

#import "PhoneBookManager.h"

static PhoneBookManager *_database;
static sqlite3_stmt *statement = nil;

@implementation PhoneBookManager

+(PhoneBookManager*)getSharedInstance{
    if (_database == nil) {
        _database = [[PhoneBookManager alloc] init];
    }
    return _database;
}

- (id)init {
    if ((self = [super init])) {
        NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:@"phonebook"
                                                             ofType:@"sqlite3"];
        
        if (sqlite3_open([sqLiteDb UTF8String], &_database) != SQLITE_OK) {
            NSLog(@"Failed to open database!");
        }
    }
    return self;
}


-(BOOL) savePhNum:(NSString*)name
              num:(NSString*)num {
    NSString *insertSQL = [NSString stringWithFormat:@"insert into phnums (name, num) values (\"%@\", \"%@\")",
                           name, num];
    const char *insert_stmt = [insertSQL UTF8String];
    sqlite3_prepare_v2(_database, insert_stmt,-1, &statement, NULL);
    if (sqlite3_step(statement) == SQLITE_DONE)
    {
        return YES;
    }
    else
    {
        return NO;
    }
    sqlite3_reset(statement);
    return NO;
}


-(NSArray*) retrieveAllPhNum{
    
    NSString *querySQL = [NSString stringWithFormat:
                          @"select * from phnums"];
    const char *query_stmt = [querySQL UTF8String];
    NSMutableArray *resultArray = [[NSMutableArray alloc]init];
    if (sqlite3_prepare_v2(_database,
                           query_stmt, -1, &statement, NULL) == SQLITE_OK)
    {
        while(sqlite3_step(statement) == SQLITE_ROW)
        {
            NSString *name = [[NSString alloc] initWithUTF8String:
                              (const char *) sqlite3_column_text(statement, 0)];
            NSString *data = [[NSString alloc] initWithUTF8String:
                              (const char *) sqlite3_column_text(statement, 1)];
            PhoneNumber* phnum = [[PhoneNumber alloc] initWithName:name andNumber:data];
            [resultArray addObject:phnum];
        }
        sqlite3_reset(statement);
        return resultArray;
    }
    return nil;
}
@end


