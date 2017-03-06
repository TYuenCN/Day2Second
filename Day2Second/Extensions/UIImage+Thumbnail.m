//
//  UIImage+Thumbnail.m
//  87Spot
//
//  Created by Yuen on 16/6/16.
//  Copyright © 2016年 87870. All rights reserved.
//

#import "UIImage+Thumbnail.h"

@implementation UIImage(Thumbnail)

#pragma mark -
#pragma mark Thumbnail
#pragma mark -
- (void)genThumbnailWithSize:(CGSize)sz keepRatio:(Boolean)keeyRatio callBack:(GenThumbnailCallback)callback onQueue:(dispatch_queue_t)onQueue
{
    
    //
    //
    // Calc Size
    CGSize __sz4Rslt = sz;
    if(keeyRatio){
        CGFloat __ratio = sz.width / self.size.width;
        __sz4Rslt.width = sz.width;
        __sz4Rslt.height = self.size.height * __ratio;
    }
    
    //
    //
    //
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        UIGraphicsBeginImageContext(__sz4Rslt);
        [self drawInRect:CGRectMake(0, 0, __sz4Rslt.width, __sz4Rslt.height)];
        UIImage *__imgRslt = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        dispatch_queue_t __callbackQueue = onQueue;
        if (__callbackQueue == nil) {
            __callbackQueue = dispatch_get_main_queue();
        }
        dispatch_async(__callbackQueue, ^{
            callback(__imgRslt);
        });
    });
}


#pragma mark -
#pragma mark Archiver
#pragma mark -
- (void)storeImage2AbsolutePath:(NSString *)absolutePath callBack:(StoreImageCallback)callback onQueue:(dispatch_queue_t)onQueue
{
    dispatch_queue_t __callbackQueue = onQueue;
    if (__callbackQueue == nil) {
        __callbackQueue = dispatch_get_main_queue();
    }
    
    NSData *__imgData = UIImageJPEGRepresentation(self, 0.9);
    if (__imgData == nil) {
        dispatch_async(__callbackQueue, ^{
            callback( false );
        });
        return;
    }
    
    if ([__imgData writeToFile:absolutePath atomically:true]) {
        dispatch_async(__callbackQueue, ^{
            callback( true );
        });
    }else{
        dispatch_async(__callbackQueue, ^{
            callback( false );
        });
    }
}
@end
