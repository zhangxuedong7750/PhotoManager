//
//  AlbumMenuView.h
//  PhotoManager
//
//  Created by 张雪东 on 15/12/5.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AlbumMenuViewDelegate<NSObject>

-(void)albumeMenuViewDidSelectAlbumName:(NSString *)name;

@end

@interface AlbumMenuView : UIView

@property (nonatomic,assign) BOOL selected;

@property (nonatomic,assign) id<AlbumMenuViewDelegate> delegate;

@property (nonatomic,strong) NSArray *albumNameArr;

-(void)showOnSuperView:(UIView *)superView;
-(void)dismiss;
@end
