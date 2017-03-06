//
//  YDSImageGroupModel.h
//  Day2Second
//
//  Created by 袁峥 on 17/2/24.
//  Copyright © 2017年 袁峥. All rights reserved.
//

#import "YDSBaseModel.h"

@interface YDSImageGroupModel : YDSBaseModel
@property (nonatomic, assign) NSInteger db_id;
@property (nonatomic, assign) NSInteger db_fk_image_id;
@property (nonatomic, assign) NSInteger db_group_timestamp;
@property (nonatomic, assign) NSInteger db_group_notice_interval;
@property (nullable, nonatomic, strong) NSString *db_group_name;
@property (nullable, nonatomic, strong) NSString *db_group_cover;
@end
