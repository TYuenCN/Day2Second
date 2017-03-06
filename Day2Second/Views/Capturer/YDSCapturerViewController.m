//
//  YDSCapturerViewController.m
//  Day2Second
//
//  Created by 袁峥 on 17/2/25.
//  Copyright © 2017年 袁峥. All rights reserved.
//

#import "YDSCapturerViewController.h"
#import "YDSMediaService.h"
#import <AVFoundation/AVFoundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface YDSCapturerViewController ()
@property (nullable, nonatomic, strong) YDSMediaService *p_mediaService;
@property (nullable, nonatomic, strong) UIImageView *p_maskView;
@end

@implementation YDSCapturerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    //
    // 注册属性观察
    [RACObserve(self.capturerViewModel, maskImagePath) subscribeNext:^(NSString *maskImagePath) {
        if (maskImagePath && maskImagePath.length > 0) {
            [self configureMaskViewWithImagePath:maskImagePath];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark _________________________ Configure
- (void)configureData
{
    
    [self.capturerViewModel prepare];
}

- (void)configureSubviews
{
    //
    //
    // Camera Preview Layer
    self.p_mediaService = [YDSMediaService new];
    AVCaptureVideoPreviewLayer *__previewLayer = [self.p_mediaService prepare2GetPhoto];
    __previewLayer.frame = self.view.bounds;
    [self.view.layer addSublayer:__previewLayer];
    
    //
    //
    // MaskView
    self.p_maskView = [[UIImageView alloc] initWithFrame:self.view.bounds];
    self.p_maskView.alpha = 0.5;
    [self.view addSubview:self.p_maskView];
    
    //
    //
    // Btn Capture
    UIButton *__btn4Capture = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [__btn4Capture setTitle:@"拍" forState:UIControlStateNormal];
    [__btn4Capture setBackgroundColor:[UIColor grayColor]];
    [__btn4Capture addTarget:self action:@selector(btn4CaptureClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:__btn4Capture];
    __btn4Capture.translatesAutoresizingMaskIntoConstraints = false;
    [__btn4Capture addConstraint:[NSLayoutConstraint constraintWithItem:__btn4Capture attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:100]];
    [__btn4Capture addConstraint:[NSLayoutConstraint constraintWithItem:__btn4Capture attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:__btn4Capture attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:__btn4Capture attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
}

- (void)configureMaskViewWithImagePath:(NSString *)imagePath
{
    NSString *__path4Doc = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject];
    NSString *__path4Image = [__path4Doc stringByAppendingPathComponent:imagePath];
    self.p_maskView.image = [UIImage imageWithContentsOfFile:__path4Image];
}

#pragma mark _________________________ Action
- (void)btn4CaptureClicked:(UIButton *)btn
{
    [self.p_mediaService takePhotoWithCompletionBlock:^(NSData * _Nullable data) {
        [self.capturerViewModel saveImage2GroupWithData:data];
    }];
}
@end
