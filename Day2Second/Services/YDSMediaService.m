//
//  YDSMediaService.m
//  Day2Second
//
//  Created by 袁峥 on 17/2/25.
//  Copyright © 2017年 袁峥. All rights reserved.
//

#import "YDSMediaService.h"
#import <UIKit/UIKit.h>

@interface YDSMediaService ()
@property (nonnull, nonatomic, strong) AVCaptureSession *p_captureSession;
@property (nonnull, nonatomic, strong) AVCaptureDevice *p_device;
@property (nonnull, nonatomic, strong) AVCaptureStillImageOutput *p_output;
@property (nonnull, nonatomic, strong) AVCaptureVideoPreviewLayer *p_layer;
@property (nonatomic, assign) CGFloat p_beginVideoScale; // 缩放及裁剪系数，系统默认 1.0
@property (nonatomic, assign) CGFloat p_effectVideoScale; // 缩放及裁剪系数，系统默认 1.0
@end

@implementation YDSMediaService

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.p_beginVideoScale = 1.0;
        self.p_effectVideoScale = 1.0;
    }
    return self;
}

- (void)dealloc
{
    if (self.p_captureSession && [self.p_captureSession isRunning]) {
        [self.p_captureSession stopRunning];
    }
}



/**
 配置开始拍照
 
 @return AVCaptureVideoPreviewLayer
 */
- (AVCaptureVideoPreviewLayer *_Nullable)prepare2GetPhoto
{
    //
    //
    // Input
    self.p_captureSession = [AVCaptureSession new];
    self.p_device = [AVCaptureDevice defaultDeviceWithDeviceType:AVCaptureDeviceTypeBuiltInWideAngleCamera mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
    
    NSError *__err;
    AVCaptureDeviceInput *__deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.p_device error:&__err];
    if (__err) {
        NSLog(@"Create AVCaptureDeviceInput Error : %@", __err);
        return nil;
    }
    
    if ([self.p_captureSession canAddInput:__deviceInput]) {
        [self.p_captureSession addInput:__deviceInput];
    }
    
    //
    //
    // 锁定，并，默认开启“持续自动对焦”
    [self.p_device lockForConfiguration:&__err];
    if (__err) {
        NSLog(@"AVCaptureDevice lockForConfiguration Error : %@", __err);
        return nil;
    }
    if ([self.p_device isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
        [self.p_device setFocusMode:AVCaptureFocusModeContinuousAutoFocus];
    }
    [self.p_device unlockForConfiguration];
    
    
    //
    //
    // Output
    self.p_output = [AVCaptureStillImageOutput new];
    [self.p_output setOutputSettings:@{AVVideoCodecKey:AVVideoCodecJPEG}];
    if ([self.p_captureSession canAddOutput:self.p_output]) {
        [self.p_captureSession addOutput:self.p_output];
    }
    
    //
    //
    // Session Start
    [self.p_captureSession startRunning];
    
    
    //
    //
    // Preview Layer
    self.p_layer = [AVCaptureVideoPreviewLayer layerWithSession:self.p_captureSession];
    self.p_layer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    return self.p_layer;
}


- (void)takePhotoWithCompletionBlock:(void(^_Nullable)(NSData *_Nullable data))block
{
    AVCaptureConnection *__conn = [self.p_output connectionWithMediaType:AVMediaTypeVideo];
    UIDeviceOrientation __deviceOrientation = [UIDevice currentDevice].orientation;
    __conn.videoScaleAndCropFactor = self.p_effectVideoScale;
    [self.p_output captureStillImageAsynchronouslyFromConnection:__conn completionHandler:^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
        if (error) {
            NSLog(@"AVCaptureStillImageOutput captureStillImageAsynchronouslyFromConnection Error : %@", error);
            block( nil );
            return;
        }
        NSData *__jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
        block( __jpegData );
    }];
}
@end
