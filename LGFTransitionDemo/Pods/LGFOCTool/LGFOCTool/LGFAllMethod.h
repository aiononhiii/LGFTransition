//
//  LGFAllSpecialMethod.h
//  LGFOCTool
//
//  Created by apple on 2017/5/2.
//  Copyright © 2017年 来国锋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGFPch.h"

@interface LGFAllMethod : NSObject

#pragma mark - 根据PNG图片url获取PNG图片尺寸
+ (CGSize)lgf_GetPNGImageSizeWithUrl:(NSURL *)url;

#pragma mark - 根据GIF图片url获取GIF图片尺寸
+ (CGSize)lgf_GetGIFImageSizeWithUrl:(NSURL *)url;

#pragma mark - 根据JPG图片url获取JPG图片尺寸
+ (CGSize)lgf_GetJPGImageSizeWithUrl:(NSURL *)url;

#pragma mark - 返回可用系统内存容量
+ (CGFloat)lgf_GetDiskFreeSize;

@end
