//
//  YDSDAO.h
//  Day2Second
//
//  Created by 袁峥 on 17/2/24.
//  Copyright © 2017年 袁峥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDSDAO : NSObject
#pragma mark -
#pragma mark __________________________ Lifecycle
+ (instancetype _Nonnull)sharedInstance;

- (NSNumber *_Nonnull)insertWithStatement:(NSString *_Nonnull)statement argumentsInArray:(NSArray *_Nullable)arguments;
- (NSArray *_Nonnull)queryWithStatement:(NSString *_Nonnull)statement;
- (BOOL)updateWithStatement:(NSString *_Nonnull)statement;
- (BOOL)updateWithStatement:(NSString *_Nonnull)statement argumentsInArray:(NSArray *_Nullable)arguments;
@end
