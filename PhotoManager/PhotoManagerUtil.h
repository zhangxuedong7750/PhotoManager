//
//  PhotoManagerUtil.h
//  PhotoManager
//
//  Created by 张雪东 on 15/12/5.
//  Copyright © 2015年 ZXD. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoManagerUtil : NSObject

-(NSArray *)getAllAlbumName;

-(NSDictionary *)getAllImageInAlbum:(NSString *)albumName;

@end
