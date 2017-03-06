//
//  YDSConvertVideoViewModel.m
//  Day2Second
//
//  Created by 袁峥 on 17/3/5.
//  Copyright © 2017年 袁峥. All rights reserved.
//

#import "YDSConvertVideoViewModel.h"

@interface YDSConvertVideoViewModel ()
@property (nonatomic, strong) NSString *storedVideoAbsolutePath;
@end

@implementation YDSConvertVideoViewModel

- (NSString *_Nonnull)genStoredVideoAbsolutePath
{
    NSString *__docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject];
    if (self.imagesRelativePath && self.imagesRelativePath.count > 0) {
        NSString *__tmpImageRelativePath = [self.imagesRelativePath firstObject];
        NSString *__groupName = [[__tmpImageRelativePath pathComponents] firstObject];
        NSString *__videoFolderPath = [__docPath stringByAppendingPathComponent:__groupName];
        NSString *__videoFileName = [NSString stringWithFormat:@"%@.mp4", [[NSUUID UUID] UUIDString]];
        self.storedVideoAbsolutePath = [__videoFolderPath stringByAppendingPathComponent:__videoFileName];
        NSLog(@"Generate Move Path: %@", self.storedVideoAbsolutePath);
        return self.storedVideoAbsolutePath;
    }
    
    self.storedVideoAbsolutePath = [__docPath stringByAppendingPathComponent:@"tmp.mp4"];
    NSLog(@"Generate Move Path: %@", self.storedVideoAbsolutePath);
    return self.storedVideoAbsolutePath;
}
@end
