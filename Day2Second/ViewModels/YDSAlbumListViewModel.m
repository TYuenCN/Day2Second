//
//  YDSAlbumListViewModel.m
//  Day2Second
//
//  Created by 袁峥 on 17/2/25.
//  Copyright © 2017年 袁峥. All rights reserved.
//

#import "YDSAlbumListViewModel.h"
#import "YDSDAO.h"

@implementation YDSAlbumListViewModel

- (BOOL)prepare
{
    //
    //
    // 查询所有 Group
    YDSImageGroupModel *__queryGroupModel = [YDSImageGroupModel new];
    NSArray *__queryResult = [__queryGroupModel queryWithConditionKeys:nil
                                                       conditionValues:nil
                                                                 other:nil];
    if (__queryResult && __queryResult.count > 0) {
        self.groups = [NSMutableArray array];
        for (NSDictionary *__tmpDic in __queryResult) {
            YDSImageGroupModel *__tmpGroupModel = [YDSImageGroupModel new];
            [__tmpGroupModel setValuesForKeysWithDictionary:__tmpDic];
            [self.groups addObject:__tmpGroupModel];
        }
        return true;
    }
    return false;
}

/**
 获取数据源 groups 内某 group 的 ID
 
 @param index groups 内某 gourp 的索引
 @return  group id
 */
- (NSNumber *_Nonnull)groupIdAtIndex:(NSInteger)index
{
    YDSImageGroupModel *__model = [self.groups objectAtIndex:index];
    return [NSNumber numberWithInteger:__model.db_id];
}


/**
 获取数据源 groups 内某 group 的 Cover
 
 @param index groups 内某 gourp 的索引
 @return  group cover path
 */
- (NSString *_Nullable)groupCoverAtIndex:(NSInteger)index
{
    YDSImageGroupModel *__model = [self.groups objectAtIndex:index];
    return __model.db_group_cover;
}

/**
 创建一个新组
 
 @return 新创建组的 id
 */
- (NSNumber *_Nonnull)createNewGroup
{
    //
    //
    // 创建组，保存到数据库，并得到新建的 ID
    YDSImageGroupModel *__newGroupModel = [YDSImageGroupModel new];
    __newGroupModel.db_group_name = [NSUUID UUID].UUIDString;
    NSNumber *__lastInsertRowID = [__newGroupModel insert];
    
    //
    //
    // 创建 Goup 的目录
    NSString *__path4Doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject];
    __path4Doc = [__path4Doc stringByAppendingPathComponent:__newGroupModel.db_group_name];
    NSError *__err4CreateDir;
    [[NSFileManager defaultManager] createDirectoryAtPath:__path4Doc withIntermediateDirectories:true attributes:nil error:&__err4CreateDir];
    if (__err4CreateDir) {
        NSLog(@"创建新 Group，连带创建 Group 目录时错误 : %@", __err4CreateDir);
        return @0;
    }
    
    //
    //
    // 修改属性，使之能被观察到
    self.isCreatedNewGroupID = __lastInsertRowID;
    
    return __lastInsertRowID;
}
@end
