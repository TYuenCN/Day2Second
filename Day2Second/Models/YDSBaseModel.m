//
//  YDSBaseModel.m
//  Day2Second
//
//  Created by 袁峥 on 17/2/24.
//  Copyright © 2017年 袁峥. All rights reserved.
//

#import "YDSBaseModel.h"
#import "YDSDAO.h"
#import "YDSImageGroupModel.h"

@implementation YDSBaseModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        //
        //
        // Try to Create Table
        NSString *__createTableStatement = [self createTableStatement];
        if (__createTableStatement) {
            [[YDSDAO sharedInstance] updateWithStatement:__createTableStatement];
            NSLog(@"Create Table: %@", __createTableStatement);
        }
    }
    return self;
}

#pragma mark _________________________ DataBase
- (NSString *_Nullable)createTableStatement
{
    NSMutableString *__statement;
    unsigned int __propertyCount;
    objc_property_t *__propertyList = class_copyPropertyList([self class], &__propertyCount);
    for (int i = 0; i <__propertyCount; i++) {
        NSString *__proName = [NSString stringWithUTF8String:property_getName(__propertyList[i])];
        //
        //
        // 非数据库字段，跳过
        if (![__proName hasPrefix:@"db_"]) {
            continue;
        }
        
        //
        //
        // 数据库字段
        if (!__statement) {
            __statement = [NSMutableString stringWithFormat:@"CREATE TABLE IF NOT EXISTS %@ ( ", NSStringFromClass([self class])];
        }
        NSString *__proTypeString = [NSString stringWithUTF8String:property_getAttributes(__propertyList[i])];
        if ([__proName isEqualToString:@"db_id"]) {
            [__statement appendFormat:@"db_id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,"];
        }
        else if ([__proTypeString hasPrefix:@"T@\"NSString\""]) {
            [__statement appendFormat:@"%@ VCHAR(1024)  DEFAULT '',", __proName];
        }
        else if ([__proTypeString hasPrefix:@"TB,"]) {  // bool
            [__statement appendFormat:@"%@ TINYINT  DEFAULT '0',", __proName];
        }
        else if ([__proTypeString hasPrefix:@"Tq,"]) {  // integer
            [__statement appendFormat:@"%@ INTEGER  DEFAULT '0',", __proName];
        }
        else if ([__proTypeString hasPrefix:@"Tf,"]) {  // float
            [__statement appendFormat:@"%@ REAL  DEFAULT '0',", __proName];
        }
        else if ([__proTypeString hasPrefix:@"Td,"]) {  // double
            [__statement appendFormat:@"%@ REAL  DEFAULT '0',", __proName];
        }
        /*id tmpValue = [self valueForKey:[NSString stringWithUTF8String:property_getName(__propertyList[i])]];
         if (!tmpValue) {
         tmpValue = [NSNull null];
         }*/
    }
    free(__propertyList);
    
    if (__statement && __statement.length > 0) {
        [__statement replaceCharactersInRange:NSMakeRange(__statement.length - 1, 1) withString:@" )"];
    }
    return __statement;
}


- (BOOL)update
{
    NSMutableString *__updateSQL;
    NSMutableArray *__insertValues;
    unsigned int __propertyCount;
    objc_property_t * __propertyList = class_copyPropertyList([self class], &__propertyCount);
    for (int i = 0; i <__propertyCount; i++) {
        NSString *__proName = [NSString stringWithUTF8String:property_getName(__propertyList[i])];
        //
        //
        // 非数据库字段，跳过
        if (![__proName hasPrefix:@"db_"]) {
            continue;
        }
        //
        //
        // id字段，跳过
        if ([__proName hasPrefix:@"db_id"]) {
            continue;
        }
        
        //
        //
        // 数据库字段
        if (!__updateSQL) {
            __updateSQL = [NSMutableString stringWithFormat:@"UPDATE %@ SET ", [self class]];
        }
        if (!__insertValues) {
            __insertValues = [NSMutableArray array];
        }
        id __tmpValue = [self valueForKey:[NSString stringWithUTF8String:property_getName(__propertyList[i])]];
        if (__tmpValue) {
            NSString *__tmpPropertyName = [NSString stringWithUTF8String:property_getName(__propertyList[i])];
            [__updateSQL appendString:[NSString stringWithFormat:@"%@=?, ", __tmpPropertyName]];
            [__insertValues addObject:__tmpValue];
        }
    }
    free(__propertyList);
    
    if (__updateSQL && __updateSQL.length > 0) {
        [__updateSQL deleteCharactersInRange:NSMakeRange([__updateSQL length]-2, 2)];
        [__updateSQL appendFormat:@"WHERE db_id=?"];
        id __tmpID = [self valueForKey:@"db_id"];
        if (__tmpID) {
            [__insertValues addObject:__tmpID];
            return [[YDSDAO sharedInstance] updateWithStatement:__updateSQL argumentsInArray:__insertValues];
        }
        else{
            return false;
        }
    }
    return false;
}



/**
 * 插入数据
 *
 * @return Last Insert RowID。插入失败为0.
 */
- (NSNumber *_Nonnull)insert
{
    NSMutableString *insertStatementPart4Var;
    NSMutableString *insertStatementpart4Value;
    NSString *insertStatement;
    NSMutableArray *insertValues = [NSMutableArray array];
    
    unsigned int propertyCount;
    objc_property_t * propertyList = class_copyPropertyList([self class], &propertyCount);
    for (int i = 0; i <propertyCount; i++) {
        NSString *__proName = [NSString stringWithUTF8String:property_getName(propertyList[i])];
        //
        //
        // 非数据库字段，跳过
        if (![__proName hasPrefix:@"db_"]) {
            continue;
        }
        //
        //
        // id字段，跳过
        if ([__proName hasPrefix:@"db_id"]) {
            continue;
        }
        
        
        //
        //
        // 数据库字段
        if (!insertStatementPart4Var) {
            insertStatementPart4Var = [NSMutableString stringWithFormat:@"INSERT INTO %@ (", [self class]];
        }
        if (!insertStatementpart4Value) {
            insertStatementpart4Value = [NSMutableString stringWithString:@"VALUES ("];
        }
        [insertStatementPart4Var appendString:[NSString stringWithUTF8String:property_getName(propertyList[i])]];
        [insertStatementPart4Var appendString:@","];
        [insertStatementpart4Value appendString:@"?,"];
        
        id tmpValue = [self valueForKey:[NSString stringWithUTF8String:property_getName(propertyList[i])]];
        if (!tmpValue) {
            tmpValue = [NSNull null];
        }
        [insertValues addObject:tmpValue];
    }
    free(propertyList);
    
    if (insertStatementPart4Var && insertStatementPart4Var.length > 0) {
        [insertStatementPart4Var deleteCharactersInRange:NSMakeRange([insertStatementPart4Var length]-1, 1)];
        [insertStatementPart4Var appendString:@")"];
        [insertStatementpart4Value deleteCharactersInRange:NSMakeRange([insertStatementpart4Value length]-1, 1)];
        [insertStatementpart4Value appendString:@")"];
        insertStatement = [NSString stringWithFormat:@"%@ %@", insertStatementPart4Var, insertStatementpart4Value];
        
        NSLog(@"Insert SQL Statement is : %@", insertStatement);
        NSLog(@"Insert SQL Statement's Values : %@", insertValues);
        
        NSNumber *__lastInsertRowID = [[YDSDAO sharedInstance] insertWithStatement:insertStatement argumentsInArray:insertValues];
        return __lastInsertRowID;
    }
    
    return @0;
}


- (NSArray *_Nonnull)queryWithConditionKeys:(NSArray *_Nullable)conditionKeys
                            conditionValues:(NSArray *_Nullable)conditionValues
                                      other:(NSString *_Nullable)other
{
    NSMutableString *queryString = [NSMutableString stringWithFormat:@"SELECT * FROM %@", [self class]];
    if (conditionKeys && conditionValues && conditionKeys.count > 0 && conditionValues.count > 0) {
        [queryString appendString:@" WHERE "];
        for (int i = 0; i < conditionKeys.count; i++) {
            [queryString appendFormat:@" %@ = %@ ", [conditionKeys objectAtIndex:i], [conditionValues objectAtIndex:i]];
            if (i != conditionKeys.count - 1) {
                [queryString appendString:@" AND "];
            }
        }
    }
    else{
        unsigned int propertyCount;
        objc_property_t * propertyList = class_copyPropertyList([self class], &propertyCount);
        for (int i = 0; i <propertyCount; i++) {
            NSString *tmpPropertyName = [NSString stringWithUTF8String:property_getName(propertyList[i])];
            if ([tmpPropertyName isEqualToString:@"db_id"]) {
                id tmpValue = [self valueForKey:[NSString stringWithUTF8String:property_getName(propertyList[i])]];
                if ([tmpValue isKindOfClass:[NSNumber class]]) {
                    NSNumber *tmpNum = (NSNumber *)tmpValue;
                    if (tmpNum && [tmpNum integerValue] != 0) {
                        [queryString appendString:@" WHERE "];
                        [queryString appendString:[NSString stringWithFormat:@"%@ = '%@'", tmpPropertyName, tmpValue]];
                        break;
                    }
                }
            }
        }
        free(propertyList);
    }
    
    if (other) {
        [queryString appendString:other];
    }
    NSLog(@"Query SQL Statement is : %@", queryString);
    NSArray *__queryResults = [[YDSDAO sharedInstance] queryWithStatement:queryString];
    return __queryResults;
}
@end
