//
//  LGFPageTitleStyle.h
//  LGFPageTitleView
//
//  Created by apple on 2018/3/23.
//  Copyright © 2018年 来国锋. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, LGFPageViewAnimationType) {
    LGFPageViewAnimationNone,// 没有分页动画
    LGFPageViewAnimationTopToBottom,// 从上往下进入的分页动画
    LGFPageViewAnimationSmallToBig,// 从小到大进入的分页动画
};

typedef NS_ENUM(NSUInteger, LGFPageLineAnimationType) {
    LGFPageLineAnimationDefult,// 标底部线平滑改变大小
    // 后续推出下面的 仿爱奇艺底部线动画效果 现暂时不可用 请勿设置
    LGFPageLineAnimationSmallToBig,// 标底部线先右边伸出变宽致标和下一个标的总宽度, 再左边收回恢复到下一个标的宽度
};

typedef NS_ENUM(NSUInteger, LGFTitleScrollFollowType) {
    LGFTitleScrollFollowDefult,// 在可滚动的情况下, 选中标默认滚动到 page_title_view 中间
    // 后续推出下面的 仿腾讯新闻, 天天快报选中标滚动效果 现暂时不可用 请勿设置
    LGFTitleScrollFollowLeftRight,// 向左滚动选中标永远出现在最右边可见位置, 反之向右滚动选中标永远出现在最左边可见位置（此效果不会像上面的效果那样滚到中间）
};

typedef NS_ENUM(NSUInteger, LGFTitleLineWidthType) {
    EqualTitleSTR,// 宽度等于字体宽度
    EqualTitleSTRAndImage,// 宽度等于字体宽度 + 图标宽度
    EqualTitle,// 宽度等于标view宽度
    FixedWith,// 宽度等于固定宽度
};

@interface LGFPageTitleStyle : NSObject

// 初始化
+ (instancetype)na;

//------------------- 数据源设置

// 标数组
@property (strong, nonatomic) NSArray *titles;

//------------------- 主page_title_view

@property (weak, nonatomic) UIScrollView *page_title_view;

//------------------- 主page_title_view在父控件上的frame 默认等于父控件

@property (assign, nonatomic) CGRect page_title_view_frame;

//------------------- 分页控件是否带分页动画

@property (assign, nonatomic) LGFPageViewAnimationType page_view_animation_type;

//------------------- 整体序列设置
// 当所有标总宽度加起来小于 page_title_view 宽度时 是否居中显示 默认 NO - 不居中(从左边开始显示)
@property (assign, nonatomic) BOOL is_title_center;
// 选中标滚动类型 默认 LGFTitleScrollFollowDefult
@property (assign, nonatomic) LGFTitleScrollFollowType title_scroll_follow_type;

//------------------- 标设置
// 标固定宽度 默认等于 0.0 如果此属性大于 0.0 那么标宽度将为固定值
// 如果设置此项（title_fixed_width） LGFTitleLineWidthType 将只支持 FixedWith 固定底部线宽度
@property (assign, nonatomic) CGFloat title_fixed_width;
// 未选中标 字体颜色 默认 lightGrayColor 淡灰色 (对应select_color两个颜色一样则取消渐变效果)
@property (strong, nonatomic) UIColor *un_select_color;
// 选中标 字体颜色 默认 blackColor 黑色 (对应un_select_color两个颜色一样则取消渐变效果)
@property (strong, nonatomic) UIColor *select_color;
// 选中标 放大缩小倍数 默认 1.0(不放大缩小)
@property (assign, nonatomic) CGFloat title_big_scale;
// 标 选中字体 默认 [UIFont systemFontOfSize:14]
@property (strong, nonatomic) UIFont *select_title_font;
// 标 未选中字体 默认 和选中字体一样
@property (strong, nonatomic) UIFont *un_select_title_font;
// 标是否有滑动动画 默认 YES 有动画
@property (assign, nonatomic) BOOL title_have_animation;
// 标左右间距 默认 0.0
@property (assign, nonatomic) CGFloat title_left_right_spacing;
// 标背景色
@property (strong, nonatomic) UIColor *title_backgroundColor;

@property (strong, nonatomic) UIColor *title_borderColor;

@property (assign, nonatomic) CGFloat title_borderWidth;

@property (assign, nonatomic) CGFloat title_cornerRadius;

@property (nonatomic, assign) BOOL title_line_break_by_word_wrapping;

//------------------- 标图片设置

// 图片Bundle 如果图片不在本控件bundel里请设置
@property (strong, nonatomic) NSBundle *title_image_bundel;
// title_images 和 same_title_image 设置一个就行 如果都设置了默认取 same_title_image
// 设置不同图标数组（必须和titles数组count保持一致,如果某一个标不想设置图标名字传空即可）
// 选中图标数组和未选中图标数组如果只传了其中一个,将没有选中效果
@property (strong, nonatomic) NSMutableArray *select_image_names;
@property (strong, nonatomic) NSMutableArray *un_select_image_names;
// 设置所有图标为相同
@property (copy, nonatomic) NSString *same_select_image_name;
@property (copy, nonatomic) NSString *same_un_select_image_name;

// 以下属性只要有值，对应imageview就会显示出来
// 顶部标图片与标的间距 默认 0
@property (assign, nonatomic) CGFloat top_image_spacing;
// 顶部标图片宽度 默认等于设置的高度 最大不超过标 view高度
@property (assign, nonatomic) CGFloat top_image_width;
// 顶部标图片高度 默认等于设置的宽度
@property (assign, nonatomic) CGFloat top_image_height;
// 底部标图片与标的间距 默认 0
@property (assign, nonatomic) CGFloat bottom_image_spacing;
// 底部标图片宽度 默认等于设置的高度 最大不超过标 view高度
@property (assign, nonatomic) CGFloat bottom_image_width;
// 底部标图片高度 默认等于设置的宽度
@property (assign, nonatomic) CGFloat bottom_image_height;
// 左边标图片与标的间距 默认 0
@property (assign, nonatomic) CGFloat left_image_spacing;
// 左边标图片宽度 默认等于设置的高度 最大不超过标 view高度
@property (assign, nonatomic) CGFloat left_image_width;
// 左边标图片高度 默认等于设置的宽度
@property (assign, nonatomic) CGFloat left_image_height;
// 右边标图片与标的间距 默认 0
@property (assign, nonatomic) CGFloat right_image_spacing;
// 右边标图片宽度 默认等于设置的高度 最大不超过标 view高度
@property (assign, nonatomic) CGFloat right_image_width;
// 右边标图片高度 默认等于设置的宽度
@property (assign, nonatomic) CGFloat right_image_height;

//------------------- 标底部线设置
// 标底部线圆角弧度 默认 0 没有弧度
@property (assign, nonatomic) CGFloat line_cornerRadius;
// 标背景图片 默认 无图
@property (strong, nonatomic) UIImage *line_back_image;
// 是否显示标底部滚动线 默认 YES 显示
@property (assign, nonatomic) BOOL is_show_line;
// 标底部滚动线 颜色 默认 blueColor
@property (strong, nonatomic) UIColor *line_color;
// 标底部滚动线 透明度 默认 1.0 - 不透明
@property (assign, nonatomic) CGFloat line_alpha;
// 标底部滚动线 动画宽度设置 默认宽度等于标字体宽度 - EqualTitleSTR
@property (assign, nonatomic) LGFTitleLineWidthType line_width_type;
// 标底部滚动线 宽度 默认 0 - 设置 LGFTitleLineType 固定宽度(FixedWith)时有效
@property (assign, nonatomic) CGFloat line_width;
// 标底部滚动线 高度 默认 1.0 (line_height最大高度为 LGFPageTitleView的高度)
@property (assign, nonatomic) CGFloat line_height;
// 标底部滚动线相对于底部位置 默认 0 - 贴于底部
@property (assign, nonatomic) CGFloat line_bottom;
// 标底部滚动线滑动动画 默认 LGFPageLineAnimationDefult 有跟随动画
@property (assign, nonatomic) LGFPageLineAnimationType line_animation;


@end

