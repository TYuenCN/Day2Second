//
//  YDSConvertVideoViewController.m
//  Day2Second
//
//  Created by 袁峥 on 17/3/5.
//  Copyright © 2017年 袁峥. All rights reserved.
//

#import "YDSConvertVideoViewController.h"

@interface YDSConvertVideoViewController ()

@end

@implementation YDSConvertVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIActivityIndicatorView *__indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    __indicator.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:__indicator];
    [__indicator startAnimating];
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

@end
