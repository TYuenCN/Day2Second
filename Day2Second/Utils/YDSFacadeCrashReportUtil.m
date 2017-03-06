//
//  YDSFacadeCrashReportUtil.m
//  Day2Second
//
//  Created by 袁峥 on 17/2/24.
//  Copyright © 2017年 袁峥. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "NSObject+Swizzle.h"
#import "YDSFacadeCrashReportUtil.h"
#import <Bugly/Bugly.h>

#define BUGLY_APP_ID @"9c9a3df0fe"

@implementation YDSFacadeCrashReportUtil
+ (void)load
{
    [NSObject swizzleMethodWithOriginalClass:[AppDelegate class]
                               swizzledClass:[self class]
                                 originalSel:@selector(application:didFinishLaunchingWithOptions:)
                                 swizzledSel:@selector(s_application:didFinishLaunchingWithOptions:)
                            isInstanceMethod:false];
}

+ (BOOL)s_application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSLog(@"[YDSFacadeCrashReportUtil application:didFinishLaunchingWithOptions:]");
    [Bugly startWithAppId:BUGLY_APP_ID];
    return [YDSFacadeCrashReportUtil s_application:application didFinishLaunchingWithOptions:launchOptions];
}
@end
