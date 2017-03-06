//
//  NSObject+Swizzle.h
//  Day2Second
//
//  Created by 袁峥 on 17/2/24.
//  Copyright © 2017年 袁峥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Swizzle)
+ (void)swizzleMethodWithOriginalClass:(Class)originalClass
                         swizzledClass:(Class)swizzledClass
                           originalSel:(SEL)originalSel
                           swizzledSel:(SEL)swizzledSel
                      isInstanceMethod:(BOOL)isInstanceMethod;
@end
