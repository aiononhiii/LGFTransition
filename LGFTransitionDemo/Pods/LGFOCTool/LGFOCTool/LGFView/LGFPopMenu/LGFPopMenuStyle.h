//
//  LGFPopMenuStyle.h
//  LGFOCTool
//
//  Created by apple on 2017/5/9.
//  Copyright © 2017年 来国锋. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, lgf_PopMenuDirection) {
    lgf_Left,// 左边
    lgf_Right,// 右边
    lgf_Top,// 顶部
    lgf_Bottom,// 底部
};

typedef NS_ENUM(NSUInteger, lgf_PopMenuImageDirection) {
    lgf_ImageLeft,// 左边
    lgf_ImageRight,// 右边
};

@interface LGFPopMenuStyle : NSObject

+ (instancetype)na;

//-------------------- 菜单 -------------------
// 弹出菜单添加的方向（上下左右）
@property (assign, nonatomic) lgf_PopMenuDirection lgf_Direction;
// 弹出菜单最大显示数据行数，数据超出则可以滚动且小于数据源count数 默认 0 (无限, 永远不可滚动)
@property (assign, nonatomic) NSInteger lgf_MenuMaxLine;
// 菜单和呼出菜单按钮的距离 默认 10.0
@property (assign, nonatomic) CGFloat lgf_MenuAndButtonBetweenDistance;
// 弹出菜单宽度 默认 0.0 (等于 文字宽度+图片宽度+lgf_ImageTextSpace * 3)
@property (assign, nonatomic) CGFloat lgf_MenuWidth;
// 弹出菜单边框宽度 默认 0.0
@property (assign, nonatomic) CGFloat lgf_MenuBorderWidth;
// 弹出菜单相对于菜单箭头的偏移量 范围 0.0 ～ 2.0 默认 1.0 (菜单与菜单箭头居中)
@property (assign, nonatomic) CGFloat lgf_MenuRelativeArrowOffset;
// 弹出菜单边框颜色 默认 nil
@property (strong, nonatomic) UIColor *lgf_MenuBorderColor;
// 弹出菜单背景颜色 默认 [UIColor whiteColor]
@property (strong, nonatomic) UIColor *lgf_MenuBackColor;
// 弹出菜单点击空白处是否隐藏 默认 YES
@property (assign, nonatomic) BOOL lgf_IsClickMaskHidden;
//-------------------- 菜单Row ----------------
// 弹出菜单Row高度 默认 30
@property (assign, nonatomic) CGFloat lgf_MenuRowHeight;
// 弹出菜单Row图文间距
@property (assign, nonatomic) CGFloat lgf_ImageTextSpace;
//-------------------- 箭头 -------------------
// 菜单箭头 Size 默认 (5, 5)
@property (assign, nonatomic) CGSize lgf_MenuArrowSize;
//-------------------- 图片 -------------------
// 弹出菜单Row图片Size 默认 (20, 20)
@property (assign, nonatomic) CGSize lgf_MenuRowImageWidth;
// 弹出菜单Row图片方向 默认 左边
@property (assign, nonatomic) lgf_PopMenuImageDirection lgf_ImageDirection;
//-------------------- 文字 -------------------
// 弹出菜单文字颜色 默认 [UIColor darkGrayColor]
@property (strong, nonatomic) UIColor *lgf_MenuTextColor;
// 弹出菜单文字字体 默认 [UIFont systemFontOfSize:15]
@property (strong, nonatomic) UIFont *lgf_MenuTextFont;
//-------------------- 分割线 -----------------
// 弹出菜单分割线空余 默认 5.0
@property (assign, nonatomic) CGFloat lgf_PlitLineSpace;
// 弹出菜单分割线颜色 默认 [UIColor lightGrayColor]
@property (strong, nonatomic) UIColor *lgf_MenuPlitLineColor;
// 弹出菜单是否带有分割线 默认 YES
@property (assign, nonatomic) BOOL lgf_IsHavePlitLine;
// 弹出菜单分割线是否有空余 默认 YES
@property (assign, nonatomic) BOOL lgf_IsHavePlitLineSpace;
//-------------------- 遮罩 -------------------
// 空白处阴影透明度 范围 0.0 ～ 1.0 默认 0.3
@property (assign, nonatomic) float lgf_MenuMaskAlpha;
// 弹出菜单遮罩颜色 默认 [UIColor blackColor]
@property (strong, nonatomic) UIColor *lgf_MenuMaskColor;


@end
