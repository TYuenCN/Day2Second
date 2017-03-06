//
//  YDSBaseModel.h
//  Day2Second
//
//  Created by 袁峥 on 17/2/24.
//  Copyright © 2017年 袁峥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface YDSBaseModel : NSObject

#pragma mark _________________________ DataBase
- (NSString *_Nullable)createTableStatement;

/**
 * 将 Model 更新到数据库。使用其内的 id 字段匹配结果。
 */
- (BOOL)update;

/**
 * 插入数据
 *
 @return Last Insert RowID。插入失败为0.
 */
- (NSNumber *_Nonnull)insert;


/**
 查询数据，如果不指定查询条件，将自动使用 Model 中非 0 的 id 字段，作为 WHERE 条件。
 如果 id 为 0，则没有查询条件。

 @param conditionKeys  WHERE 子句查询条件
 @param conditionValues WHERE 子句查询条件对应的值
 @param other 其他查询符号：LIMIT ORDER BY
 @return 查询结果，内部元素为字典
 */
- (NSArray *_Nonnull)queryWithConditionKeys:(NSArray *_Nullable)conditionKeys
                            conditionValues:(NSArray *_Nullable)conditionValues
                                      other:(NSString *_Nullable)other;
@end
