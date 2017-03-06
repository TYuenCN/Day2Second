//
//  YDSBaseViewController.m
//  Day2Second
//
//  Created by 袁峥 on 17/2/25.
//  Copyright © 2017年 袁峥. All rights reserved.
//

#import "YDSBaseViewController.h"

@interface YDSBaseViewController ()

@end

@implementation YDSBaseViewController

#pragma mark _________________________ Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self configure];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma mark _________________________ Configure
- (void)configure
{
    [self configureData];
    [self configureSubviews];
}

- (void)configureData
{
    
}

- (void)configureSubviews
{
    
}
@end
