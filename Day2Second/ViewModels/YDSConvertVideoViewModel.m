//
//  YDSConvertVideoViewModel.m
//  Day2Second
//
//  Created by 袁峥 on 17/3/5.
//  Copyright © 2017年 袁峥. All rights reserved.
//

#import "YDSConvertVideoViewModel.h"
#import "YDSImageModel.h"
#import "YDSImageGroupModel.h"

@interface YDSConvertVideoViewModel ()
@property (nonatomic, strong) NSString *storedVideoAbsolutePath;
@end

@implementation YDSConvertVideoViewModel

- (NSString *_Nonnull)genStoredVideoAbsolutePath
{
    NSString *__docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject];
    if (self.imageModels && self.imageModels.count > 0) {
        if ([[self.imageModels firstObject] isKindOfClass:[YDSImageModel class]]) {
            YDSImageModel *__tmpImgModel = [self.imageModels firstObject];
            NSString *__tmpImageRelativePath = __tmpImgModel.db_image_path;
            NSString *__groupName = [[__tmpImageRelativePath pathComponents] firstObject];
            NSString *__videoFolderPath = [__docPath stringByAppendingPathComponent:__groupName];
            NSString *__videoFileName = [NSString stringWithFormat:@"%@.mp4", [[NSUUID UUID] UUIDString]];
            self.storedVideoAbsolutePath = [__videoFolderPath stringByAppendingPathComponent:__videoFileName];
            NSLog(@"Generate Move Path: %@", self.storedVideoAbsolutePath);
            return self.storedVideoAbsolutePath;
        }
    }
    
    self.storedVideoAbsolutePath = [__docPath stringByAppendingPathComponent:@"tmp.mp4"];
    NSLog(@"Generate Move Path: %@", self.storedVideoAbsolutePath);
    return self.storedVideoAbsolutePath;
}


- (NSArray *_Nonnull)genImageRelativePathList
{
    NSMutableArray *__rslt = [NSMutableArray array];
    for (YDSImageModel *__curModel in self.imageModels) {
        [__rslt addObject:__curModel.db_image_path];
    }
    return __rslt;
}


- (void)save
{
    if (self.storedVideoAbsolutePath) {
        NSString *__storedVideoRelativePath = [[self.storedVideoAbsolutePath componentsSeparatedByString:@"Documents"] lastObject];
        YDSImageGroupModel *__groupModel = [YDSImageGroupModel new];
        __groupModel.db_id = [self.curSelectedGroupID integerValue];
        __groupModel.db_group_latest_video = __storedVideoRelativePath;
        if ([__groupModel update]) {
            NSLog(@"🍺保存生成的视频成功。");
        }
    }else{
        NSLog(@"🍺保存生成的视频失败（没有当前Video存储路径属性值）。");
    }
}

- (NSString *_Nullable)queryExistGroupVideoPath
{
    YDSImageGroupModel *__groupModel = [YDSImageGroupModel new];
    __groupModel.db_id = [self.curSelectedGroupID integerValue];
    NSArray *__rslt = [__groupModel queryWithConditionKeys:nil conditionValues:nil other:nil];
    id __id4GroupModel = [__rslt lastObject];
    if ([__id4GroupModel isKindOfClass:[NSDictionary class]]) {
        NSDictionary *__dic4GroupModel = (NSDictionary *)__id4GroupModel;
        [__groupModel setValuesForKeysWithDictionary:__dic4GroupModel];
    }
    
    if (__groupModel.db_group_latest_video && __groupModel.db_group_latest_video.length > 0) {
        return __groupModel.db_group_latest_video;
    }
    
    return nil;
}
@end
