//
//  YDSConcreteMediator.m
//  Day2Second
//
//  Created by 袁峥 on 17/2/25.
//  Copyright © 2017年 袁峥. All rights reserved.
//

#import "YDSConcreteMediator.h"
#import "NSObject+Swizzle.h"
#import "AppDelegate.h"
#import "YDSAlbumListViewController.h"
#import "YDSAlbumListViewModel.h"

@interface YDSConcreteMediator ()
@property (nonnull, nonatomic, strong) NSHashTable *p_weakVCs;
@property (nonnull, nonatomic, strong) NSHashTable *p_weakControls;
@end

@implementation YDSConcreteMediator
#pragma mark -
#pragma mark __________________________ Lifecycle
+ (void)load
{
    [NSObject swizzleMethodWithOriginalClass:[AppDelegate class]
                               swizzledClass:[self class]
                                 originalSel:@selector(application:didFinishLaunchingWithOptions:)
                                 swizzledSel:@selector(s_application:didFinishLaunchingWithOptions:)
                            isInstanceMethod:false];
}
+ (instancetype _Nonnull)sharedInstance
{
    static YDSConcreteMediator *__instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        __instance = [YDSConcreteMediator new];
        __instance.p_weakVCs = [NSHashTable weakObjectsHashTable];
        __instance.p_weakControls = [NSHashTable weakObjectsHashTable];
    });
    
    return __instance;
}


#pragma mark __________________________ AOP
+ (BOOL)s_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"[YDSConcreteMediator application:didFinishLaunchingWithOptions:]");
    [[YDSConcreteMediator sharedInstance] configureStartup];
    return [YDSConcreteMediator s_application:application didFinishLaunchingWithOptions:launchOptions];
}


#pragma mark _________________________ Common

/**
 * @Description 注册 VC 到 Mediator； Mediator 保留一份弱引用；
 *
 * @param vc 需要注册到弱引用集合的 ViewController
 */
- (void)registVC:(UIViewController * _Nonnull)vc
{
    [self.p_weakVCs addObject:vc];
}
/**
 * @Description 注册 Control 到 Mediator； Mediator 保留一份弱引用；
 *
 * @param c 需要注册到弱引用集合的 UIControl
 */
- (void)registControl:(UIControl * _Nonnull)c
{
    [self.p_weakControls addObject:c];
}

/**
 * @Description 根据 Class 查询，在 Mediator 保存的 VC 弱引用集合中；
 *
 * @param c 根据某类型的 Class，在弱引用集合中查询是否有存活的指定类型的对象
 */
- (UIViewController * _Nullable)queryVCWithClass:(Class _Nonnull)c
{
    NSArray *__arr = self.p_weakVCs.allObjects;
    for (UIViewController *__vc in __arr) {
        if (__vc != nil && [__vc class] == c) {
            return __vc;
        }
    }
    
    return nil;
}

#pragma mark __________________________ UI
/**
 * @Description 配置启动时的初始视图
 */
- (void)configureStartup
{
    [self configureLandingPage];
}

/**
 * LandingPage 展现逻辑
 */
- (void)configureLandingPage
{
    //
    //
    // Configure Root View
    UITabBarController *__rootTabBarControl = [UITabBarController new];
    __rootTabBarControl.tabBar.hidden = true;
    UINavigationController *__rootNaviControl = [[UINavigationController alloc] initWithRootViewController:__rootTabBarControl];
    __rootNaviControl.navigationBar.hidden = true;
    
    // AlbumListView
    YDSAlbumListViewController *__albumListViewController = [YDSAlbumListViewController new];
    __albumListViewController.title = @"列表";
    YDSAlbumListViewModel *__albumListVM = [YDSAlbumListViewModel new];
    __albumListViewController.albumListViewModel = __albumListVM;
    
    // TabBar Item
    UINavigationController *__1stNaviControl = [[UINavigationController alloc] initWithRootViewController:__albumListViewController];
    __rootTabBarControl.viewControllers = @[__1stNaviControl];
    
    //
    //
    // Init Window
    [UIApplication sharedApplication].delegate.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [UIApplication sharedApplication].delegate.window.rootViewController = __rootNaviControl;
    [[UIApplication sharedApplication].delegate.window makeKeyAndVisible];
}
@end
