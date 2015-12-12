//
//  MainViewController.m
//  PhotoManager
//
//  Created by 张雪东 on 15/12/5.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import "MainViewController.h"
#import "AlbumMenuView.h"
#import "PhotoManagerUtil.h"
#import "PhotoBrowserViewController.h"

#define KSCREENSIZE [UIScreen mainScreen].bounds.size

static NSString * const cellIdentifier = @"imageCell";

@interface MainViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,AlbumMenuViewDelegate>{

    CGSize thumbImageSize;
}

@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UICollectionView *imagecollectionView;

@property (nonatomic,strong) PhotoManagerUtil *photoManger;
@property (nonatomic,strong) AlbumMenuView *menuView;

@property (nonatomic,strong) NSArray *thumbimageCollection;
@property (nonatomic,strong) NSArray *originimageCollection;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    CGFloat width = (KSCREENSIZE.width - 40)/3;
    thumbImageSize = CGSizeMake(width , width);
    
    PhotoManagerUtil *manager = [[PhotoManagerUtil alloc] init];
    self.photoManger = manager;
    
    [self initTitleView];
    [self initCollectionView];
    
}

-(void)initTitleView{

    self.navigationController.navigationBar.translucent = NO;
    
    UIControl *tileView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    tileView.backgroundColor = [UIColor redColor];
    [tileView addTarget:self action:@selector(selectAlbum) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView = tileView;
    
    UILabel *label = [[UILabel alloc] initWithFrame:tileView.bounds];
    label.textAlignment = NSTextAlignmentCenter;
    self.titleLabel = label;
    label.text = @"我的相册";
    [tileView addSubview:label];
}

-(void)initCollectionView{

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = thumbImageSize;
    flowLayout.minimumLineSpacing = 10;
    flowLayout.minimumInteritemSpacing = 10;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KSCREENSIZE.width, KSCREENSIZE.height - 64) collectionViewLayout:flowLayout];
    collectionView.contentInset = UIEdgeInsetsMake(0, 10, 0, 10);
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.backgroundColor = [UIColor clearColor];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    self.imagecollectionView = collectionView;
    [self.view addSubview:collectionView];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.thumbimageCollection.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    [cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, thumbImageSize.width, thumbImageSize.height)];
    imageView.contentMode = UIViewContentModeScaleToFill;
    imageView.image = self.thumbimageCollection[indexPath.item];
    [cell addSubview:imageView];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    PhotoBrowserViewController *photoBrowserVC = [[PhotoBrowserViewController alloc] init];
    photoBrowserVC.photoArr = self.originimageCollection;
    photoBrowserVC.index = indexPath.item;
    [self.navigationController pushViewController:photoBrowserVC animated:NO];
}

//选择相册
-(void)selectAlbum{
    
    if (self.menuView == nil) {
        AlbumMenuView *menuView = [[AlbumMenuView alloc] initWithFrame:self.view.bounds];
        menuView.albumNameArr = [self.photoManger getAllAlbumName];
        menuView.delegate = self;
        self.menuView = menuView;
    }
    if (_menuView.selected) {
        [_menuView dismiss];
    }else{
        [_menuView showOnSuperView:self.view];
    }
}

//AlbumMenuView的delegate
-(void)albumeMenuViewDidSelectAlbumName:(NSString *)name{
    
    NSDictionary *imageDic = [self.photoManger getAllImageInAlbum:name];

    self.thumbimageCollection = imageDic[@"thumbImageCollection"];
    self.originimageCollection = imageDic[@"originImageCollection"];
    if ([name isEqualToString:@"Camera Roll"]) {
        name = @"相机胶卷";
    }
    self.titleLabel.text = name;
    [self.imagecollectionView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
