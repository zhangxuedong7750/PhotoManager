//
//  AlbumMenuView.m
//  PhotoManager
//
//  Created by 张雪东 on 15/12/5.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import "AlbumMenuView.h"
#import "PhotoManagerUtil.h"

static NSString * const cellIdentifer = @"AlbumCell";

@interface AlbumMenuView()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation AlbumMenuView

-(instancetype)initWithFrame:(CGRect)frame{

    if (self = [super initWithFrame:frame]) {

        self.backgroundColor = [UIColor clearColor];
        [self addMaskView];
        [self initTableView];
    }
    return self;
}

-(void)addMaskView{

    UIView *maskView = [[UIView alloc] initWithFrame:CGRectMake(0, 150, self.bounds.size.width, self.bounds.size.height - 150)];
    maskView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [self addSubview:maskView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    [maskView addGestureRecognizer:tapGesture];
}

-(void)initTableView{

    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 150)];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.tableFooterView = [[UIView alloc] init];
    [self addSubview:tableView];
}

-(void)showOnSuperView:(UIView *)superView{

    [superView addSubview:self];
    self.transform = CGAffineTransformMakeTranslation(0, -self.bounds.size.height);
    [UIView animateWithDuration:0.5f animations:^{
        self.transform = CGAffineTransformIdentity;
    }];
    self.selected = YES;
}

-(void)dismiss{

    [self removeFromSuperview];
    self.selected = NO;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return self.albumNameArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifer];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifer];
    }
    NSString *albumName = self.albumNameArr[indexPath.row];
    if ([albumName isEqualToString:@"Camera Roll"]) {
        albumName = @"相机胶卷";
    }
    cell.textLabel.text = albumName;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if ([self.delegate respondsToSelector:@selector(albumeMenuViewDidSelectAlbumName:)]) {
        [self dismiss];
        [self.delegate albumeMenuViewDidSelectAlbumName:self.albumNameArr[indexPath.row]];
    }
}

@end
