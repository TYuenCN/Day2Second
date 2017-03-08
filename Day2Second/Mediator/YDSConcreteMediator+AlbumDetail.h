//
//  YDSConcreteMediator+AlbumDetail.h
//  Day2Second
//
//  Created by 袁峥 on 17/3/5.
//  Copyright © 2017年 袁峥. All rights reserved.
//

#import "YDSConcreteMediator.h"

@interface YDSConcreteMediator (AlbumDetail)
- (void)presentConvertVideoViewWithGroupID:(NSNumber *_Nonnull)groupID
                        imageModels:(NSArray *_Nonnull)imageModels;
@end
