//
//  YDSConcreteMediator+AlbumDetail.m
//  Day2Second
//
//  Created by 袁峥 on 17/3/5.
//  Copyright © 2017年 袁峥. All rights reserved.
//

#import "YDSConcreteMediator+AlbumDetail.h"
#import "YDSConvertVideoViewController.h"
#import "YDSConvertVideoViewModel.h"

@implementation YDSConcreteMediator (AlbumDetail)
- (void)presentConvertVideoViewWithGroupID:(NSNumber *_Nonnull)groupID
                        imagesRelativePath:(NSArray *_Nonnull)imagesRelativePath
{
    UITabBarController *__rootTabBarController = (UITabBarController *)[self queryVCWithClass:[UITabBarController class]];
    if (__rootTabBarController) {
        UIViewController *__tmpVC = __rootTabBarController.selectedViewController;
        if ([__tmpVC isKindOfClass:[UINavigationController class]]) {
            UINavigationController *__curNavi = (UINavigationController *)__tmpVC;
            
            //
            //
            // Present
            YDSConvertVideoViewModel *__convertVideoVM = [YDSConvertVideoViewModel new];
            __convertVideoVM.curSelectedGroupID = groupID;
            __convertVideoVM.imagesRelativePath = imagesRelativePath;
            YDSConvertVideoViewController *__convertVideoVC = [YDSConvertVideoViewController new];
            __convertVideoVC.convertVideoViewModel = __convertVideoVM;
            __convertVideoVC.title = @"生成视频";
            [__curNavi pushViewController:__convertVideoVC animated:true];
        }
    }
}
@end
