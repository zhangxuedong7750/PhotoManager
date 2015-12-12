//
//  PhotoBrowserViewController.m
//  PhotoManager
//
//  Created by 张雪东 on 15/12/5.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import "PhotoBrowserViewController.h"

static NSString *const cellIdentifier = @"photoCell";

@interface PhotoBrowserViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>{

    CGSize itemSize;
}

@property (nonatomic,strong) UICollectionView *photoCollectionView;

@end

@implementation PhotoBrowserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor blackColor];
    itemSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64);
    
    self.title = [NSString stringWithFormat:@"%ld/%ld",self.index + 1,self.photoArr.count];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    [self initCollectionView];
}

-(void)back{

    [self.navigationController popViewControllerAnimated:NO];
}

-(void)initCollectionView{
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = itemSize;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, itemSize.width, itemSize.height) collectionViewLayout:flowLayout];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    collectionView.pagingEnabled = YES;
    collectionView.backgroundColor = [UIColor clearColor];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellIdentifier];
    [collectionView setContentOffset:CGPointMake(self.index * itemSize.width, 0)];
    self.photoCollectionView = collectionView;
    [self.view addSubview:collectionView];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.photoArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{

    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    [cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, itemSize.width, itemSize.height)];
    imageView.backgroundColor = [UIColor blackColor];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    imageView.image = self.photoArr[indexPath.row];
    [cell addSubview:imageView];
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{

    NSInteger num = scrollView.contentOffset.x / itemSize.width;
    self.title = [NSString stringWithFormat:@"%ld/%ld",num + 1,self.photoArr.count];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
