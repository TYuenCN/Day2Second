//
//  YDSAlbumDetailViewModel.m
//  Day2Second
//
//  Created by 袁峥 on 17/2/26.
//  Copyright © 2017年 袁峥. All rights reserved.
//

#import "YDSAlbumDetailViewModel.h"
#import "YDSImageModel.h"

@interface YDSAlbumDetailViewModel()
@end

@implementation YDSAlbumDetailViewModel
- (BOOL)prepare
{
    self.groupImages = [NSMutableArray array];
    YDSImageModel *__queryModel = [YDSImageModel new];
    NSArray *__queryResult = [__queryModel queryWithConditionKeys:@[@"db_fk_group_id"] conditionValues:@[self.curSelectedGroupID] other:nil];
    for (NSDictionary *__tmpDic in __queryResult) {
        YDSImageModel *__tmpModel = [YDSImageModel new];
        [__tmpModel setValuesForKeysWithDictionary:__tmpDic];
        [self.groupImages addObject:__tmpModel];
    }
    
    return true;
}



- (NSString *_Nullable)imageAtIndex:(NSInteger)index
{
    if (self.groupImages && index < self.groupImages.count) {
        YDSImageModel *__tmpModel = [self.groupImages objectAtIndex:index];
        return __tmpModel.db_image_path;
    }
    
    return nil;
}
@end
