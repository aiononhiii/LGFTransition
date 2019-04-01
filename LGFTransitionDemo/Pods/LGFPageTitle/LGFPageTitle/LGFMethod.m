//
//  LGFMethod.m
//  LGFPageTitleView
//
//  Created by apple on 2018/3/24.
//  Copyright © 2018年 来国锋. All rights reserved.
//

#import "LGFMethod.h"

@implementation LGFMethod

+ (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize {
    NSDictionary *dict = @{NSFontAttributeName: font};
    CGSize size = [str boundingRectWithSize:maxSize
                                    options:NSStringDrawingTruncatesLastVisibleLine |
                   NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading
                                 attributes:dict
                                    context:nil].size;
    return CGSizeMake(size.width + 1, size.height);
}

+ (NSArray *)getColorRGBA:(UIColor *)color {
    CGFloat numOfcomponents = CGColorGetNumberOfComponents(color.CGColor);
    NSArray *rgbaComponents;
    if (numOfcomponents == 4) {
        const CGFloat *components = CGColorGetComponents(color.CGColor);
        rgbaComponents = [NSArray arrayWithObjects:@(components[0]), @(components[1]), @(components[2]), @(components[3]), nil];
    }
    return rgbaComponents;
}

+ (UIColor *)changeUIColorToRGB:(UIColor *)color {
    //获得RGB值描述
    NSString *RGBValue = [NSString stringWithFormat:@"%@",color];
    //将RGB值描述分隔成字符串
    NSArray *RGBArr = [RGBValue componentsSeparatedByString:@" "];
    int r = [[RGBArr objectAtIndex:1] intValue];
    int g = [[RGBArr objectAtIndex:2] intValue];
    int b = [[RGBArr objectAtIndex:3] intValue];
    //返回保存RGB值的数组
    return [UIColor colorWithRed:r green:g blue:b alpha:1.0];
}

@end
