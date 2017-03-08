//
//  YDSConvertVideoViewController.m
//  Day2Second
//
//  Created by 袁峥 on 17/3/5.
//  Copyright © 2017年 袁峥. All rights reserved.
//

#import "YDSConvertVideoViewController.h"
#import <JGProgressHUD/JGProgressHUD.h>
#import "YDSImageConvert2VideoService.h"
#import <MediaPlayer/MediaPlayer.h>

@interface YDSConvertVideoViewController ()
@property (nonnull, nonatomic, strong) JGProgressHUD *HUD;
@property (nonnull, nonatomic, strong) YDSImageConvert2VideoService *convertor;
@property (nonnull, nonatomic, strong) MPMoviePlayerController *playerController;
@end

@implementation YDSConvertVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *__existVideoPath = [self.convertVideoViewModel queryExistGroupVideoPath];
    if (__existVideoPath) {
        NSString *__docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject];
        [self configurePlayerWithVideoPath:[__docPath stringByAppendingPathComponent:__existVideoPath]];
    }
    else{
        [self startConvert];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark ___________________________ Player
- (MPMoviePlayerController *)configurePlayerWithVideoPath:(NSString *)videoPath
{
    if (self.playerController == nil) {
        // 1.获取视频的URL
        NSURL *url = [NSURL fileURLWithPath:videoPath];
        
        // 2.创建控制器
        self.playerController = [[MPMoviePlayerController alloc] initWithContentURL:url];
        
        // 3.设置控制器的View的位置
        self.playerController.view.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        self.playerController.repeatMode = MPRepeatTypeOne;
        self.playerController.shouldAutoplay = true;
        
        // 4.将View添加到控制器上
        [self.view addSubview:self.playerController.view];
        
        // 5.设置属性
        self.playerController.controlStyle = MPMovieControlStyleNone;
        [self.playerController play];
    }
    return self.playerController;
}

#pragma mark ___________________________ Convert
- (void)startConvert
{
    self.HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    self.HUD.textLabel.text = @"转换中";
    [self.HUD showInView:self.view];
    
    if (!self.convertor) {
        self.convertor = [YDSImageConvert2VideoService new];
    }
    [self.convertor startConvertWithImagesRelativePath:[self.convertVideoViewModel genImageRelativePathList] storedVideoAbsolutePath:[self.convertVideoViewModel genStoredVideoAbsolutePath] progressBlock:^(NSInteger cur, NSInteger total) {
        
    } completionBlock:^{
        self.HUD.indicatorView = [[JGProgressHUDSuccessIndicatorView alloc] init];
        [self.HUD showInView:self.view];
        [self.HUD dismissAfterDelay:2.0];
        
        //
        //
        // Store DB
        [self.convertVideoViewModel save];
    } onQueue:dispatch_get_main_queue()];
}
@end
