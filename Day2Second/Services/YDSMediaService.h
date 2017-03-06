//
//  YDSMediaService.h
//  Day2Second
//
//  Created by 袁峥 on 17/2/25.
//  Copyright © 2017年 袁峥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface YDSMediaService : NSObject

/**
 配置开始拍照

 @return AVCaptureVideoPreviewLayer
 */
- (AVCaptureVideoPreviewLayer *_Nullable)prepare2GetPhoto;


/**
 拍摄照片

 @param block 照片捕获后的 JPEG 的 NSData 数据的回调
 */
- (void)takePhotoWithCompletionBlock:(void(^_Nullable)(NSData *_Nullable data))block;
@end
