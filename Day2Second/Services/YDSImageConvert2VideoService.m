//
//  YDSImageConvert2VideoService.m
//  Day2Second
//
//  Created by 袁峥 on 17/3/5.
//  Copyright © 2017年 袁峥. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <VideoToolbox/VideoToolbox.h>
#import <UIKit/UIKit.h>
#import "YDSImageConvert2VideoService.h"

@interface YDSImageConvert2VideoService ()
{
        VTCompressionSessionRef EncodingSession;
}
@property(nonatomic, assign)NSInteger curFrameIndex;
@property(nonatomic, assign)NSTimeInterval preEncodeFrameTimestamp;
@property(nonatomic, strong)NSTimer *timer4Monitored;
@property(nonatomic, strong)NSArray *imageArr;
@property(nonatomic, strong)NSString  *theVideoPath;
@property(nonatomic, strong)AVAssetWriter *videoWriter;
@property(nonatomic, strong)AVAssetWriterInput *writerInput;

@property (nonatomic, assign)YDSImageConvert2VideoProgressBlock progressBlock;
@property (nonatomic, assign)YDSImageConvert2VideoCompletionBlock completionBlock;
@end

@implementation YDSImageConvert2VideoService



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
                             progressBlock:(void(^)(NSInteger cur, NSInteger total))progressBlock
                           completionBlock:(void(^)())completionBlock
                                   onQueue:(dispatch_queue_t)onQueue
{
    self.preEncodeFrameTimestamp = 0;
    self.curFrameIndex = 0;
    self.imageArr = imagesRelativePath;
    self.theVideoPath = storedVideoAbsolutePath;
    self.progressBlock = progressBlock;
    self.completionBlock = completionBlock;
    
    //定义视频的大小
    CGSize __size = [UIScreen mainScreen].bounds.size;
    
    NSError *__error =nil;
    //—-initialize compression engine
    self.videoWriter =[[AVAssetWriter alloc]initWithURL:[NSURL fileURLWithPath:self.theVideoPath]
                                               fileType:AVFileTypeQuickTimeMovie error:&__error];
    NSParameterAssert(self.videoWriter);
    
    if(__error)
        NSLog(@"error =%@", [__error localizedDescription]);
    self.writerInput =[AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:nil];
    NSParameterAssert(self.writerInput);
    NSParameterAssert([self.videoWriter canAddInput:self.writerInput]);
    
    
    if (![self.videoWriter canAddInput:self.writerInput]){
        
    }
    
    [self.videoWriter addInput:self.writerInput];
    [self.videoWriter startWriting];
    [self.videoWriter startSessionAtSourceTime:kCMTimeZero];
    
    //合成多张图片为一个视频文件
    dispatch_queue_t __dispatchQueue =dispatch_queue_create("mediaInputQueue",NULL);
    OSStatus status = VTCompressionSessionCreate(NULL, __size.width, __size.height, kCMVideoCodecType_H264, NULL, NULL, NULL, didCompressH264,(__bridge void *)(self),  &EncodingSession);
    if (status != 0)
    {
        NSLog(@"H264: Unable to create a H264 session");
        return ;
    }
    
    VTSessionSetProperty(EncodingSession, kVTCompressionPropertyKey_RealTime, kCFBooleanTrue);
    VTSessionSetProperty(EncodingSession, kVTCompressionPropertyKey_ProfileLevel, kVTProfileLevel_H264_Baseline_4_1);
    
    SInt32 bitRate = __size.width * __size.height * 50;
    CFNumberRef ref = CFNumberCreate(kCFAllocatorDefault, kCFNumberSInt32Type, &bitRate);
    VTSessionSetProperty(EncodingSession, kVTCompressionPropertyKey_AverageBitRate, ref);
    CFRelease(ref);
    
    int frameInterval = 10; //关键帧间隔
    CFNumberRef  frameIntervalRef = CFNumberCreate(kCFAllocatorDefault, kCFNumberIntType, &frameInterval);
    VTSessionSetProperty(EncodingSession, kVTCompressionPropertyKey_MaxKeyFrameInterval,frameIntervalRef);
    CFRelease(frameIntervalRef);
    // Tell the encoder to start encoding
    VTCompressionSessionPrepareToEncodeFrames(EncodingSession);
    [self.writerInput requestMediaDataWhenReadyOnQueue:__dispatchQueue usingBlock:^{
        if ([self.writerInput isReadyForMoreMediaData]) {
            [self compressFrame];
            
            // Start Monitored
            [self startMonitoredIfConvertFinished];
        }
    }];
}



/**
 处理当前视频帧
 */
- (void)compressFrame
{
    if (++self.curFrameIndex < [self.imageArr count]*2) {
        NSLog(@"Convert Frame:%ld", (long)self.curFrameIndex);
        long __imageIndex = self.curFrameIndex / 2;
        UIImage *img = [self.imageArr objectAtIndex:__imageIndex];
        CVImageBufferRef imageBuffer = (CVImageBufferRef)[self pixelBufferFromCGImage:img.CGImage size:CGSizeMake(320,400)];
        // CMTimeMake() 当前第几帧，每秒多少帧
        CMTime presentationTimeStamp = CMTimeMake(self.curFrameIndex, 25);
        VTEncodeInfoFlags flags;
        OSStatus statusCode = VTCompressionSessionEncodeFrame(EncodingSession, imageBuffer, presentationTimeStamp, kCMTimeInvalid, NULL, NULL, &flags);
        if (statusCode != noErr)
        {
            if (EncodingSession!=nil||EncodingSession!=NULL)
            {
                VTCompressionSessionInvalidate(EncodingSession);
                CFRelease(EncodingSession);
                return;
            }
        }
        
    }
}


void didCompressH264(void *outputCallbackRefCon, void *sourceFrameRefCon, OSStatus status, VTEncodeInfoFlags infoFlags,
                     CMSampleBufferRef sampleBuffer )
{
    YDSImageConvert2VideoService* encoder = (__bridge YDSImageConvert2VideoService*)outputCallbackRefCon;
    [encoder.writerInput appendSampleBuffer:sampleBuffer];
    
    // Update Tiemstamp
    encoder.preEncodeFrameTimestamp = [[NSDate new] timeIntervalSince1970];
}


- (CVPixelBufferRef)pixelBufferFromCGImage:(CGImageRef)image size:(CGSize)size
{
    NSDictionary *options =[NSDictionary dictionaryWithObjectsAndKeys:
                            [NSNumber numberWithBool:YES],kCVPixelBufferCGImageCompatibilityKey,
                            [NSNumber numberWithBool:YES],kCVPixelBufferCGBitmapContextCompatibilityKey,nil];
    
    CVPixelBufferRef pxbuffer =NULL;
    
    CVReturn status2 =CVPixelBufferCreate(kCFAllocatorDefault,size.width,size.height,kCVPixelFormatType_32ARGB,(__bridge CFDictionaryRef) options,&pxbuffer);
    
    NSParameterAssert(status2 ==kCVReturnSuccess && pxbuffer !=NULL);
    
    CVPixelBufferLockBaseAddress(pxbuffer,0);
    
    void *pxdata =CVPixelBufferGetBaseAddress(pxbuffer);
    
    NSParameterAssert(pxdata !=NULL);
    
    CGColorSpaceRef rgbColorSpace=CGColorSpaceCreateDeviceRGB();
    
    CGContextRef context =CGBitmapContextCreate(pxdata,size.width,size.height,8,4*size.width,rgbColorSpace,kCGImageAlphaPremultipliedFirst);
    
    NSParameterAssert(context);
    CGContextDrawImage(context,CGRectMake(0,0,320,400), image);
    
    CGColorSpaceRelease(rgbColorSpace);
    
    CGContextRelease(context);
    
    CVPixelBufferUnlockBaseAddress(pxbuffer,0);
    
    return pxbuffer;
}


- (void)startMonitoredIfConvertFinished
{
    self.timer4Monitored = [NSTimer scheduledTimerWithTimeInterval:3 repeats:true block:^(NSTimer * _Nonnull timer) {
        NSTimeInterval __timestamp = [[NSDate new] timeIntervalSince1970];
        if (__timestamp - self.preEncodeFrameTimestamp > 1000 * 6) {
            
            // Finish Convert
            [self.writerInput markAsFinished];
            [self.videoWriter finishWriting];
            
            // Callback Invoker
            if (self.completionBlock) {
                self.completionBlock();
            }
            
            // Invalid Timer
            if (self.timer4Monitored) {
                [self.timer4Monitored invalidate];
                self.timer4Monitored = nil;
            }
        }
    }];
}

@end
