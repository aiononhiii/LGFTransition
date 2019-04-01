//
//  LGFMethod.h
//  LGFPageTitleView
//
//  Created by apple on 2018/3/24.
//  Copyright © 2018年 来国锋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LGFMethod : NSObject

/**
 获取文字size

 @param str 传入文字
 @param font 传入文字字体
 @param maxSize 最大size
 @return 获取文字size
 */
+ (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize;


/**
 UIColorRGB 转颜色数组

 @param color UIColorRGB
 @return 颜色数组
 */
+ (NSArray *)getColorRGBA:(UIColor *)color;


/**
 UIColor 转 RGBUIColor

 @param color UIColor
 @return RGBUIColor
 */
+ (UIColor *)changeUIColorToRGB:(UIColor *)color;
@end
