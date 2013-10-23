//
//  FavoritesManager.m
//  TheClerk
//
//  Created by Matthew Parides on 9/28/13.
//  Copyright (c) 2013 Duke. All rights reserved.
//

#import "FavoritesManager.h"
static FavoritesManager *sharedInstance = nil;
static sqlite3 *database = nil;
static sqlite3_stmt *statement = nil;

@implementation FavoritesManager

+(FavoritesManager*)getSharedInstance{
    if (!sharedInstance) {
        sharedInstance = [[super allocWithZone:NULL]init];
        [sharedInstance createDB];
    }
    return sharedInstance;
}

-(BOOL)createDB{
    NSString *docsDir;
    NSArray *dirPaths;
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains
    (NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = dirPaths[0];
    // Build the path to the database file
    databasePath = [[NSString alloc] initWithString:
                    [docsDir stringByAppendingPathComponent: @"Favorites2.db"]];
    BOOL isSuccess = YES;
    NSFileManager *filemgr = [NSFileManager defaultManager];
  //  if ([filemgr fileExistsAtPath: databasePath ] == NO)
  //  {
        const char *dbpath = [databasePath UTF8String];
        if (sqlite3_open(dbpath, &database) == SQLITE_OK)
        {
            char *errMsg;
            const char *sql_stmt =
            "create table if not exists favconds (name text, data text)";
            const char *sql_stmt2 =
            "create table if not exists favphnums (name text, num text)";
            if ((sqlite3_exec(database, sql_stmt, NULL, NULL, &errMsg)
                 != SQLITE_OK) || sqlite3_exec(database, sql_stmt2, NULL, NULL, &errMsg)
                != SQLITE_OK)
            {
                isSuccess = NO;
                NSLog(@"Failed to create table");
            }
            sqlite3_close(database);
            return  isSuccess;
        }
        else {
            isSuccess = NO;
            NSLog(@"Failed to open/create database");
        }
  //  }
    return isSuccess;
}

-(BOOL) saveCondition:(NSString*)name
                 data:(NSString*)data {
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into favconds (name, data) values (\"%@\", \"%@\")",
                               name, data];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            return YES;
        }
        else
        {
            return NO;
        }
        sqlite3_reset(statement);
    }
    return NO;
}

-(BOOL) savePhNum:(NSString*)name
              num:(NSString*)num {
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *insertSQL = [NSString stringWithFormat:@"insert into favphnums (name, num) values (\"%@\", \"%@\")",
                               name, num];
        const char *insert_stmt = [insertSQL UTF8String];
        sqlite3_prepare_v2(database, insert_stmt,-1, &statement, NULL);
        if (sqlite3_step(statement) == SQLITE_DONE)
        {
            return YES;
        }
        else
        {
            return NO;
        }
        sqlite3_reset(statement);
    }
    return NO;
}

- (NSArray*) findByUserName:(NSString*)name
{
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"select name, password from userPass where name=\"%@\"", name];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if (sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *name = [[NSString alloc] initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 0)];
                [resultArray addObject:name];
                NSString *password = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 1)];
                [resultArray addObject:password];
                return resultArray;
            }
            else{
                NSLog(@"Not found");
                return nil;
            }
            sqlite3_reset(statement);
        }
    }
    return nil;
}

-(NSArray*) retrieveAll:(NSString*)tableName {
    
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &database) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat:
                              @"select * from %@",tableName];
        const char *query_stmt = [querySQL UTF8String];
        NSMutableArray *resultArray = [[NSMutableArray alloc]init];
        if (sqlite3_prepare_v2(database,
                               query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *name = [[NSString alloc] initWithUTF8String:
                                  (const char *) sqlite3_column_text(statement, 0)];
                NSString *data = [[NSString alloc] initWithUTF8String:
                                      (const char *) sqlite3_column_text(statement, 1)];
                NSLog(@"%@\n%@", name, data);
                PhoneNumber* phnum = [[PhoneNumber alloc] initWithName:name andNumber:data];
                [resultArray addObject:phnum];
            }
            sqlite3_reset(statement);
            return resultArray;
        }
    }
    return nil;
}
@end

