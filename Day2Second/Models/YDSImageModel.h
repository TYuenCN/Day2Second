//
//  YDSImageModel.h
//  Day2Second
//
//  Created by 袁峥 on 17/2/24.
//  Copyright © 2017年 袁峥. All rights reserved.
//

#import "YDSBaseModel.h"

@interface YDSImageModel : YDSBaseModel
@property (nonatomic, assign) NSInteger db_id;
@property (nonatomic, assign) NSInteger db_fk_group_id;
@property (nonatomic, assign) NSInteger db_image_timestamp;
@property (nullable, nonatomic, strong) NSString *db_image_name;
@property (nullable, nonatomic, strong) NSString *db_image_path;
@end
