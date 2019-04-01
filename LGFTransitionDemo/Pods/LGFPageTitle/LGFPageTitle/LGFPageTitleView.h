//
//  LGFPageTitleView.h
//  LGFPageTitleView
//
//  Created by apple on 2018/3/23.
//  Copyright © 2018年 来国锋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "LGFTitles.h"
#import "LGFPageTitleStyle.h"

@protocol LGFPageTitleViewDelegate <NSObject>
/**
 返回选中的标
 */
- (void)lgf_SelectPageTitle:(NSInteger)selectIndex;
@end

@interface LGFPageTitleView : UIScrollView


/**
 代理方法
 */
@property (weak, nonatomic) id<LGFPageTitleViewDelegate>lgf_PageTitleViewDelegate;

/**
 配置用模型
 */
@property (strong, nonatomic) LGFPageTitleStyle *style;

/**
 初始化
 
 @return LGFPageTitleView
 */
+ (instancetype)na;

/**
 刷新所有标
 @param index 选中下标位置
 */
- (void)reloadAllTitlesSelectIndex:(NSInteger)index;
- (void)reloadAllTitles;

/**
 配置
 
 @param style 配置用模型
 @param super_view 父控件 如果想自定义pagetitle的frame 请传nil
 @param page_view 外部分页控件
 @return LGFPageTitleView
 */
- (instancetype)initWithStyle:(LGFPageTitleStyle *)style super_vc:(UIViewController *)super_vc super_view:(UIView *)super_view page_view:(UIScrollView *)page_view;
@end

