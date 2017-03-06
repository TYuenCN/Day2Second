//
//  UIViewController+MediatorWeakRefRegister.m
//  Day2Second
//
//  Created by 袁峥 on 17/2/25.
//  Copyright © 2017年 袁峥. All rights reserved.
//

#import "UIViewController+MediatorWeakRefRegister.h"
#import "NSObject+Swizzle.h"
#import "YDSMediator.h"

@implementation UIViewController (MediatorWeakRefRegister)
#pragma mark _________________________ AOP
+ (void)load
{
    [NSObject swizzleMethodWithOriginalClass:[UIViewController class]
                               swizzledClass:[UIViewController class]
                                 originalSel:@selector(init)
                                 swizzledSel:@selector(s_init)
                            isInstanceMethod:true];
}

- (void)s_init
{
    
    //
    //
    // Register Weak Ref
    [[YDSConcreteMediator sharedInstance] registVC:[super init]];
    
    
    //
    //
    // Call Original
    [self s_init];
}
@end
