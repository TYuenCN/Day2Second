//
//  YDSCapturerViewModel.h
//  Day2Second
//
//  Created by 袁峥 on 17/2/26.
//  Copyright © 2017年 袁峥. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YDSCapturerViewModel : NSObject
@property (nullable, nonatomic, strong) NSNumber *curSelectedGroupID;
@property (nullable, nonatomic, strong) NSString *maskImagePath;

- (BOOL)prepare;
- (BOOL)saveImage2GroupWithData:(NSData *_Nullable)imgData;
@end
