//
//  NSObject+Swizzle.m
//  Day2Second
//
//  Created by 袁峥 on 17/2/24.
//  Copyright © 2017年 袁峥. All rights reserved.
//
#import <objc/runtime.h>
#import "NSObject+Swizzle.h"

@implementation NSObject (Swizzle)
+ (void)swizzleMethodWithOriginalClass:(Class)originalClass
                         swizzledClass:(Class)swizzledClass
                           originalSel:(SEL)originalSel
                           swizzledSel:(SEL)swizzledSel
                      isInstanceMethod:(BOOL)isInstanceMethod
{
    Method __originalMethod = class_getInstanceMethod(originalClass, originalSel);
    Method __swizzledMethod;
    if (isInstanceMethod) {
        __swizzledMethod = class_getInstanceMethod(swizzledClass, swizzledSel);
    }
    else{
        __swizzledMethod = class_getClassMethod(swizzledClass, swizzledSel);
    }
    
    BOOL __didAddMethod = class_addMethod(originalClass, originalSel, method_getImplementation(__swizzledMethod), method_getTypeEncoding(__swizzledMethod));
    if (__didAddMethod) {
        if (__originalMethod) {
            class_replaceMethod(swizzledClass, swizzledSel, method_getImplementation(__originalMethod), method_getTypeEncoding(__originalMethod));
        }
        
    }else{
        method_exchangeImplementations(__originalMethod, __swizzledMethod);
    }
}
@end
