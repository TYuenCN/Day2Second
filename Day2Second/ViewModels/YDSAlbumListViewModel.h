//
//  YDSAlbumListViewModel.h
//  Day2Second
//
//  Created by 袁峥 on 17/2/25.
//  Copyright © 2017年 袁峥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YDSImageGroupModel.h"

@interface YDSAlbumListViewModel : NSObject
@property (nullable, nonatomic, strong) NSMutableArray<YDSImageGroupModel *> *groups;
@property (nullable, nonatomic, strong) NSNumber *curSelectedGroupID;
@property (nullable, nonatomic, strong) NSNumber *isCreatedNewGroupID;


- (BOOL)prepare;

/**
  获取数据源 groups 内某 group 的 ID

 @param index groups 内某 gourp 的索引
 @return  group id
 */
- (NSNumber *_Nonnull)groupIdAtIndex:(NSInteger)index;
/**
 获取数据源 groups 内某 group 的 Cover
 
 @param index groups 内某 gourp 的索引
 @return  group cover path
 */
- (NSString *_Nullable)groupCoverAtIndex:(NSInteger)index;

/**
 创建一个新组

 @return 新创建组的 id
 */
- (NSNumber *_Nonnull)createNewGroup;
@end
