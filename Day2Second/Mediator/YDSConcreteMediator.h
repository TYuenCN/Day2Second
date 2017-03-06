//
//  YDSConcreteMediator.h
//  Day2Second
//
//  Created by 袁峥 on 17/2/25.
//  Copyright © 2017年 袁峥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface YDSConcreteMediator : NSObject
#pragma mark -
#pragma mark __________________________ Lifecycle
+ (void)load;
+ (instancetype _Nonnull)sharedInstance;

#pragma mark __________________________ Common

/**
 * @Description 注册 VC 到 Mediator； Mediator 保留一份弱引用；
 *
 * @param vc 需要注册到弱引用集合的 ViewController
 */
- (void)registVC:(UIViewController * _Nonnull)vc;

/**
 * @Description 注册 Control 到 Mediator； Mediator 保留一份弱引用；
 *
 * @param c 需要注册到弱引用集合的 UIControl
 */
- (void)registControl:(UIControl * _Nonnull)c;

/**
 * @Description 根据 Class 查询，在 Mediator 保存的 VC 弱引用集合中；
 *
 * @param c 根据某类型的 Class，在弱引用集合中查询是否有存活的指定类型的对象
 */
- (UIViewController * _Nullable)queryVCWithClass:(Class _Nonnull)c;

#pragma mark __________________________ UI
@end
