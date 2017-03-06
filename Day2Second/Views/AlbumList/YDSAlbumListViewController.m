//
//  YDSAlbumListViewController.m
//  Day2Second
//
//  Created by 袁峥 on 17/2/25.
//  Copyright © 2017年 袁峥. All rights reserved.
//

#import "YDSAlbumListViewController.h"
#import "YDSImageGroupModel.h"
#import "YDSMediator.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIImageView+WebCache.h"

@interface YDSAlbumListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>
@property (nonnull, nonatomic, strong) UICollectionView *p_cv;
@property (nonnull, nonatomic, strong) UICollectionViewFlowLayout *p_cvFlowLayout;
@end

@implementation YDSAlbumListViewController

#pragma mark _________________________ Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [self.albumListViewModel prepare];
}


#pragma mark _________________________ Configure
- (void)configureData
{
    //
    //
    // 注册属性观察
    [RACObserve(self.albumListViewModel, curSelectedGroupID) subscribeNext:^(NSNumber *curSelectedGroupID) {
        if (curSelectedGroupID && ![curSelectedGroupID isEqualToNumber:@0]) {
            [[YDSConcreteMediator sharedInstance] presentAlbumDetailViewWithGroupID:curSelectedGroupID];
        }
    }];
    [RACObserve(self.albumListViewModel, isCreatedNewGroupID) subscribeNext:^(NSNumber *isCreatedNewGroupID) {
        if (isCreatedNewGroupID && ![isCreatedNewGroupID isEqualToNumber:@0]) {
            [[YDSConcreteMediator sharedInstance] presentCaptureViewWithGroupID:isCreatedNewGroupID];
        }
    }];
    [RACObserve(self.albumListViewModel, groups) subscribeNext:^(NSMutableArray *groups) {
        if (groups) {
            [self.p_cv reloadData];
        }
    }];
}

- (void)configureSubviews
{
    //
    //
    // CollectionView
    // Layout
    self.p_cvFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    self.p_cvFlowLayout.itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 180);
    self.p_cvFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    // Collection
    self.p_cv = [[UICollectionView alloc] initWithFrame:[UIScreen mainScreen].bounds
                                   collectionViewLayout:self.p_cvFlowLayout];
    self.p_cv.backgroundColor = [UIColor whiteColor];
    self.p_cv.delegate = self;
    self.p_cv.dataSource = self;
    [self.p_cv registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"YDSAlbumListGroupCellIdentifier"];
    [self.view addSubview:self.p_cv];
    
    //
    //
    // Add Group Button
    UIButton *__btn4Add = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [__btn4Add setTitle:@"+" forState:UIControlStateNormal];
    [__btn4Add setBackgroundColor:[UIColor grayColor]];
    [__btn4Add addTarget:self action:@selector(btn4AddGroupClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:__btn4Add];
    __btn4Add.translatesAutoresizingMaskIntoConstraints = false;
    [__btn4Add addConstraint:[NSLayoutConstraint constraintWithItem:__btn4Add attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:100]];
    [__btn4Add addConstraint:[NSLayoutConstraint constraintWithItem:__btn4Add attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.0 constant:30]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:__btn4Add attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:__btn4Add attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeBottom multiplier:1.0 constant:0]];
    
}

#pragma mark _________________________ Action
- (void)btn4AddGroupClicked:(UIButton *)btn
{
    [self.albumListViewModel createNewGroup];
}

#pragma mark _________________________ <<UICollectionViewDataSource>>
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.albumListViewModel.groups.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *__cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"YDSAlbumListGroupCellIdentifier" forIndexPath:indexPath];
    
    //
    //
    // Cover
    NSString *__path4Cover = [self.albumListViewModel groupCoverAtIndex:indexPath.row];
    NSString *__path4Dic = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true) lastObject];
    __path4Cover = [__path4Dic stringByAppendingPathComponent:__path4Cover];
    UIImageView *__imgView = [[UIImageView alloc] initWithFrame:__cell.contentView.bounds];
    __imgView.clipsToBounds = true;
    __imgView.contentMode = UIViewContentModeScaleAspectFill;
    UIImage *__img = [UIImage imageWithContentsOfFile:__path4Cover];
    __imgView.image = __img;
    [__cell.contentView addSubview:__imgView];
    
    
    return __cell;
}

#pragma mark _________________________ <<UICollectionViewDelegate>>
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
{
    NSNumber *__curSelectedGroupID = [self.albumListViewModel groupIdAtIndex:indexPath.row];
    self.albumListViewModel.curSelectedGroupID = __curSelectedGroupID;
}
@end
