//
//  YDSImageConvert2VideoService.h
//  Day2Second
//
//  Created by 袁峥 on 17/3/5.
//  Copyright © 2017年 袁峥. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 回调函数声明
 */
typedef void(^YDSImageConvert2VideoProgressBlock)(NSInteger cur, NSInteger total);
typedef void(^YDSImageConvert2VideoCompletionBlock)();


@interface YDSImageConvert2VideoService : NSObject


/**
 开始转换视频

 @param imagesRelativePath 待转换的图片的数组。（相对地址）
 @param storedVideoAbsolutePath 转换完成后视频的绝对地址
 @param progressBlock 进度回调函数
 @param completionBlock 完成回调函数
 @param onQueue 回调执行时的DispatchQueue
 */
- (void)startConvertWithImagesRelativePath:(NSArray *)imagesRelativePath
                   storedVideoAbsolutePath:(NSString *)storedVideoAbsolutePath
                             progressBlock:(YDSImageConvert2VideoProgressBlock)progressBlock
                           completionBlock:(YDSImageConvert2VideoCompletionBlock)completionBlock
                                   onQueue:(dispatch_queue_t)onQueue;
@end
