//
//  YDSConcreteMediator+AlbumList.m
//  Day2Second
//
//  Created by 袁峥 on 17/2/25.
//  Copyright © 2017年 袁峥. All rights reserved.
//

#import "YDSConcreteMediator+AlbumList.h"
#import "YDSCapturerViewController.h"
#import "YDSCapturerViewModel.h"
#import "YDSAlbumDetailViewController.h"
#import "YDSAlbumDetailViewModel.h"

@implementation YDSConcreteMediator (AlbumList)

- (void)presentAlbumDetailViewWithGroupID:(NSNumber *_Nonnull)groupID
{
    UITabBarController *__rootTabBarController = (UITabBarController *)[self queryVCWithClass:[UITabBarController class]];
    if (__rootTabBarController) {
        UIViewController *__tmpVC = __rootTabBarController.selectedViewController;
        if ([__tmpVC isKindOfClass:[UINavigationController class]]) {
            UINavigationController *__curNavi = (UINavigationController *)__tmpVC;
            
            //
            //
            // Present
            YDSAlbumDetailViewModel *__albumDetailVM = [YDSAlbumDetailViewModel new];
            __albumDetailVM.curSelectedGroupID = groupID;
            YDSAlbumDetailViewController *__albumDetailVC = [YDSAlbumDetailViewController new];
            __albumDetailVC.albumDetailViewModel = __albumDetailVM;
            __albumDetailVC.title = @"";
            [__curNavi pushViewController:__albumDetailVC animated:true];
        }
    }
}


- (void)presentCaptureViewWithGroupID:(NSNumber *_Nonnull)groupID
{
    UITabBarController *__rootTabBarController = (UITabBarController *)[self queryVCWithClass:[UITabBarController class]];
    if (__rootTabBarController) {
        UIViewController *__tmpVC = __rootTabBarController.selectedViewController;
        if ([__tmpVC isKindOfClass:[UINavigationController class]]) {
            UINavigationController *__curNavi = (UINavigationController *)__tmpVC;
            
            //
            //
            // Present
            YDSCapturerViewModel *__captureVM = [YDSCapturerViewModel new];
            __captureVM.curSelectedGroupID = groupID;
            YDSCapturerViewController *__captureVC = [YDSCapturerViewController new];
            __captureVC.capturerViewModel = __captureVM;
            [__curNavi pushViewController:__captureVC animated:true];
        }
    }
}
@end
