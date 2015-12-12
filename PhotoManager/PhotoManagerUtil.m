//
//  PhotoManagerUtil.m
//  PhotoManager
//
//  Created by 张雪东 on 15/12/5.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import "PhotoManagerUtil.h"
#import <Photos/Photos.h>

@interface PhotoManagerUtil()

@property (nonatomic,strong) PHFetchResult *smartAlbums;            //系统相册
@property (nonatomic,strong) PHFetchResult *userCollectionResult;   //用户相册
@property (nonatomic,strong) NSMutableArray *albumNameArr;          //所有相册名字
@end

@implementation PhotoManagerUtil

-(instancetype)init{

    if (self = [super init]) {
        
        [self initAlbum];
    }
    return self;
}

-(void)initAlbum{

    self.smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    self.userCollectionResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
}

-(NSMutableArray *)albumNameArr{

    if (_albumNameArr == nil) {
        _albumNameArr = [NSMutableArray array];
    }
    return _albumNameArr;
}

-(NSArray *)getAllAlbumName{

    NSMutableArray *albumNameArr = [NSMutableArray array];
    for (PHAssetCollection *collection in self.smartAlbums) {
        if ([collection.localizedTitle isEqualToString:@"Camera Roll"]) {
            [albumNameArr addObject:collection.localizedTitle];
        }
        
    }
    
    for (PHAssetCollection *collection in self.userCollectionResult) {
        [albumNameArr addObject:collection.localizedTitle];
    }
    
    return [albumNameArr copy];
}

-(NSDictionary *)getAllImageInAlbum:(NSString *)albumName{

    if ([albumName isEqualToString:@"Camera Roll"]) {
        return [self selectSmartImage];
    }else{
        return [self selectUserCollectionImageWithAlbumName:albumName];
    }
}

-(NSDictionary *)selectUserCollectionImageWithAlbumName:(NSString *)name{

    for (PHAssetCollection *collection in self.userCollectionResult) {
        if([collection.localizedTitle isEqualToString:name]){
        
            return [self searchAllImageInCollection:collection];
        }
    }
    return nil;
}

-(NSDictionary *)selectSmartImage{

    for (PHAssetCollection *collection in self.smartAlbums) {
        if ([collection.localizedTitle isEqualToString:@"Camera Roll"]) {
            return [self searchAllImageInCollection:collection];
        }
    }
    return nil;
}

-(NSDictionary *)searchAllImageInCollection:(PHAssetCollection *)collection{
    
    PHImageRequestOptions *imageOptions = [[PHImageRequestOptions alloc] init];
    imageOptions.synchronous = YES;
    PHFetchResult *assetResult = [PHAsset fetchAssetsInAssetCollection:collection options:nil];
    NSMutableArray *thumbImgArr = [NSMutableArray array];
    NSMutableArray *originImgArr = [NSMutableArray array];
    for (PHAsset *asset in assetResult) {
        
        if (asset.mediaType == PHAssetMediaTypeImage) {
            
            CGSize thumbImageSize = CGSizeMake(100, 100);
            CGSize originSize = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
            
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:thumbImageSize contentMode:PHImageContentModeAspectFill options:imageOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                
                [thumbImgArr addObject:result];
            }];
            [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:originSize contentMode:PHImageContentModeAspectFill options:imageOptions resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                
                [originImgArr addObject:result];
            }];
        }
    }
    NSMutableDictionary *imageDic = [NSMutableDictionary dictionary];
    [imageDic setObject:[thumbImgArr copy] forKey:@"thumbImageCollection"];
    [imageDic setObject:[originImgArr copy] forKey:@"originImageCollection"];

    return [imageDic copy];
}

@end
