//
//  YDSConcreteMediator+AlbumList.h
//  Day2Second
//
//  Created by 袁峥 on 17/2/25.
//  Copyright © 2017年 袁峥. All rights reserved.
//

#import "YDSConcreteMediator.h"
#import "YDSAlbumListViewController.h"
@interface YDSConcreteMediator (AlbumList)
- (void)presentAlbumDetailViewWithGroupID:(NSNumber *_Nonnull)groupID;
- (void)presentCaptureViewWithGroupID:(NSNumber *_Nonnull)groupID;
@end
