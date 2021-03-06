//
//  YDSConvertVideoViewModel.h
//  Day2Second
//
//  Created by 袁峥 on 17/3/5.
//  Copyright © 2017年 袁峥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDSConvertVideoViewModel : NSObject
@property (nullable, nonatomic, strong) NSNumber *curSelectedGroupID;
@property (nullable, nonatomic, strong) NSArray *imageModels;

- (NSString *_Nonnull)genStoredVideoAbsolutePath;
- (NSArray *_Nonnull)genImageRelativePathList;
- (void)save;
- (NSString *_Nullable)queryExistGroupVideoPath;
@end
