//
//  YDSCapturerViewModel.m
//  Day2Second
//
//  Created by 袁峥 on 17/2/26.
//  Copyright © 2017年 袁峥. All rights reserved.
//

#import "YDSCapturerViewModel.h"
#import "YDSImageGroupModel.h"
#import "YDSImageModel.h"

@interface YDSCapturerViewModel ()
@property (nullable, nonatomic, strong) YDSImageGroupModel *curGroupModel;
@end

@implementation YDSCapturerViewModel

- (BOOL)prepare
{
    self.curGroupModel = [YDSImageGroupModel new];
    self.curGroupModel.db_id = [self.curSelectedGroupID integerValue];
    NSArray *__queryResult = [self.curGroupModel queryWithConditionKeys:nil
                                                        conditionValues:nil
                                                                  other:nil];
    if (__queryResult && __queryResult.count > 0) {
        [self.curGroupModel setValuesForKeysWithDictionary:[__queryResult objectAtIndex:0]];
        if (self.curGroupModel) {
            self.maskImagePath = self.curGroupModel.db_group_cover;
        }
        return true;
    }
    else{
        return false;
    }
}


- (BOOL)saveImage2GroupWithData:(NSData *_Nullable)imgData
{
    if (!imgData ||
        !self.curGroupModel ||
        !self.curGroupModel.db_group_name ||
        self.curGroupModel.db_group_name.length <= 0) {
        return false;
    }
    
    //
    //
    // Save Image
    NSString *__imgName = [NSUUID UUID].UUIDString;
    NSString *__path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject];
    __path = [__path stringByAppendingPathComponent:self.curGroupModel.db_group_name];
    __path = [__path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg", __imgName]];
    if([imgData writeToFile:__path atomically:true]){
        YDSImageModel *__imgModel = [YDSImageModel new];
        __imgModel.db_fk_group_id = [self.curSelectedGroupID integerValue];
        __imgModel.db_image_name = __imgName;
        __imgModel.db_image_path = [NSString stringWithFormat:@"/%@/%@.jpg", self.curGroupModel.db_group_name, __imgName];
        NSNumber *__insertStatus = [__imgModel insert];
        if ([__insertStatus integerValue] == 0) {
            return false;
        }else{
            //
            //
            // Update Group
            self.curGroupModel.db_group_cover = __imgModel.db_image_path;
            
            //
            //
            // Change Mask
            self.maskImagePath = self.curGroupModel.db_group_cover;
            return [self.curGroupModel update];
        }
    }
    
    return false;
}
@end
