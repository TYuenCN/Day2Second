//
//  UIImage+Thumbnail.h
//  87Spot
//
//  Created by Yuen on 16/6/16.
//  Copyright © 2016年 87870. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

typedef void (^GenThumbnailCallback) (UIImage *thumbnail);
typedef void (^StoreImageCallback) (BOOL complete);

@interface UIImage(Thumbnail)

#pragma mark - 
#pragma mark Thumbnail
#pragma mark -
- (void)genThumbnailWithSize:(CGSize)sz keepRatio:(Boolean)keeyRatio callBack:(GenThumbnailCallback)callback onQueue:(dispatch_queue_t)onQueue;


#pragma mark -
#pragma mark Archiver
#pragma mark -
- (void)storeImage2AbsolutePath:(NSString *)absolutePath callBack:(StoreImageCallback)callback onQueue:(dispatch_queue_t)onQueue;

@end
