//
//  LGFUploadImage.h
//  LGFOCTool
//
//  Created by apple on 2018/6/13.
//  Copyright © 2018年 来国锋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGFOCTool.h"
#import <UIKit/UIKit.h>

typedef void(^lgf_ReturnImage) (UIImage *image);

@interface LGFUploadImage : NSObject

lgf_AllocOnlyOnceForH(LGFUploadImage);

/**
 调用系统相册，拍照
 */
- (void)lgf_GetSystemPhotoWithVC:(id)SelfVC title:(NSString *)title returnImage:(lgf_ReturnImage)returnImage;

@end
