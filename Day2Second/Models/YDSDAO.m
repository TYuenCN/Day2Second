//
//  YDSDAO.m
//  Day2Second
//
//  Created by 袁峥 on 17/2/24.
//  Copyright © 2017年 袁峥. All rights reserved.
//

#import "YDSDAO.h"
#import "FMDatabase.h"
#import "FMResultSet.h"

@interface YDSDAO ()
@property (nonatomic, strong) FMDatabase *db;
@end

@implementation YDSDAO
#pragma mark -
#pragma mark __________________________ Lifecycle
+ (instancetype _Nonnull)sharedInstance
{
    static YDSDAO *__instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [YDSDAO new];
        
        // 创建数据库文件
        NSString *__path4DocDir = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        NSString *__path4DBFile = [__path4DocDir stringByAppendingPathComponent:@"Day2Second.sqlite"];
        NSLog(@"DB File Path: %@", __path4DBFile);
        [__instance setDb:[FMDatabase databaseWithPath:__path4DBFile]];
    });
    
    return __instance;
}



- (NSNumber *_Nonnull)insertWithStatement:(NSString *_Nonnull)statement argumentsInArray:(NSArray *_Nullable)arguments
{
    BOOL __result = false;
    NSNumber *__lastInsertRowID = @0;
    if ([self.db open]) {
        //  Update
        __result = [self.db executeUpdate:statement withArgumentsInArray:arguments];
        __lastInsertRowID = [NSNumber numberWithInteger:self.db.lastInsertRowId];
        [self.db close];
        return __lastInsertRowID;
    }
    else{
        NSLog(@"%@",@"Open SQLite Error.");
        return @0;
    }
}


- (NSArray *_Nonnull)queryWithStatement:(NSString *_Nonnull)statement
{
    NSMutableArray *__result = [NSMutableArray array];
    if ([self.db open]) {
        FMResultSet *resultSet = [self.db executeQuery:statement];
        while ([resultSet next]) {
            [__result addObject:[resultSet resultDictionary]];
        }
        [self.db close];
    }
    else{
        NSLog(@"%@",@"Open SQLite Error.");
    }
    return __result;
}

- (BOOL)updateWithStatement:(NSString *_Nonnull)statement
{
    return [self updateWithStatement:statement argumentsInArray:nil];
}

- (BOOL)updateWithStatement:(NSString *_Nonnull)statement argumentsInArray:(NSArray *_Nullable)arguments
{
    BOOL __result = false;
    if ([self.db open]) {
        //  Update
        __result = [self.db executeUpdate:statement withArgumentsInArray:arguments];
        [self.db close];
    }
    else{
        NSLog(@"%@",@"Open SQLite Error.");
    }
    
    return __result;
}
@end
