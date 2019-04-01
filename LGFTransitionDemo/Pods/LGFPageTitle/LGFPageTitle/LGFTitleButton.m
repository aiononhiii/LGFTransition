//
//  LGFtitle_button.m
//  LGFPageTitleView
//
//  Created by apple on 2018/3/23.
//  Copyright © 2018年 来国锋. All rights reserved.
//

#import "LGFTitleButton.h"

@implementation LGFTitleButton

+ (instancetype)title:(NSString *)title index:(NSInteger)index style:(LGFPageTitleStyle *)style {
    [style.page_title_view setNeedsLayout];
    [style.page_title_view layoutIfNeeded];
    // 初始化标
    LGFTitleButton *button = [LGFBundle loadNibNamed:NSStringFromClass([LGFPageTitleView class]) owner:self options:nil][1];
    button.tag = index;
    button.style = style;
    button.title.text = title;
    // 获取字体宽度
    CGSize title_size = [LGFMethod sizeWithString:button.title.text font:button.title.font maxSize:CGSizeMake(CGFLOAT_MAX, style.page_title_view.height)];
    CGFloat title_x = 0.0;
    if (index > 0) {
        UIView *subview = style.page_title_view.subviews[index - 1];
        title_x = subview.x + subview.width;
    } else {
        title_x = style.title_fixed_width > 0.0 ? 0.0 : button.style.title_left_right_spacing;
    }
    button.title_width.constant = title_size.width + 2;
    button.title_height.constant = title_size.height;
    
    // 设置每一个标宽度
    button.frame = CGRectMake(title_x, 0, style.title_fixed_width > 0.0 ? style.title_fixed_width : (title_size.width + 2 + (style.title_left_right_spacing * 2) + style.left_image_width + style.right_image_width + style.left_image_spacing + style.right_image_spacing), style.page_title_view.height);
    [style.page_title_view addSubview:button];
    return button;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    return self;
}

- (NSMutableArray *)select_image_names {
    if (!_select_image_names) {
        _select_image_names = [NSMutableArray new];
    }
    return _select_image_names;
}

- (NSMutableArray *)un_select_image_names {
    if (!_un_select_image_names) {
        _un_select_image_names = [NSMutableArray new];
    }
    return _un_select_image_names;
}

- (void)setStyle:(LGFPageTitleStyle *)style {
    _style = style;
    self.title.textColor = style.un_select_color;
    self.title.font = style.un_select_title_font;
    
    if (style.title_borderWidth > 0.0) {
        self.layer.borderWidth = style.title_borderWidth;
        self.layer.borderColor = style.title_borderColor.CGColor;
        self.clipsToBounds = YES;
    }
    
    // 如果设置了都是相同标图片, 那么就强制转成全部相同图片
    if (style.same_select_image_name && style.same_select_image_name.length > 0 && style.same_un_select_image_name && style.same_un_select_image_name.length > 0) {
        [style.titles enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [self.select_image_names addObject:style.same_select_image_name];
            [self.un_select_image_names addObject:style.same_un_select_image_name];
        }];
        style.select_image_names = self.select_image_names;
        style.un_select_image_names = self.un_select_image_names;
    }
    
    // 是否需要显示标图片
    if (!style.select_image_names || (style.select_image_names.count < style.titles.count) || !style.un_select_image_names || (style.un_select_image_names.count < style.titles.count)) {
        self.is_have_image = NO;
        self.top_image_height.constant = 0.0;
        self.bottom_image_height.constant = 0.0;
        self.left_image_width.constant = 0.0;
        self.right_image_width.constant = 0.0;
        self.top_image_spacing.constant = 0.0;
        self.bottom_image_spacing.constant = 0.0;
        self.left_image_spacing.constant = 0.0;
        self.right_image_spacing.constant = 0.0;
        self.top_image = nil;
        self.bottom_image = nil;
        self.left_image = nil;
        self.right_image = nil;
        [self setNeedsLayout];
        [self layoutIfNeeded];
        return;
    }
    
    self.is_have_image = YES;
    
    NSAssert(style.title_image_bundel, @"为了获取正确的图片 - 请设置 (NSBundle *)style.title_image_bundel");
    
    // 只要有宽度，允许左右两边都设置图片
    if (style.left_image_width > 0.0) {
        self.left_image_spacing.constant = style.left_image_spacing;
        self.left_image_width.constant = MIN(style.left_image_width ?: 0.0, style.page_title_view.height);
        self.left_image_height.constant = MIN(style.left_image_height ?: 0.0, style.page_title_view.height);
        [self.left_image setImage:[UIImage imageNamed:style.un_select_image_names[self.tag] inBundle:style.title_image_bundel compatibleWithTraitCollection:nil]];
        self.title_center_x.constant = self.title_center_x.constant + (style.left_image_width / 2);
        if (style.left_image_spacing > 0.0) {
            self.title_center_x.constant = self.title_center_x.constant + (style.left_image_spacing / 2);
        }
    } else {
        LGFLog(@"如果要显示左边图标，请给 left_image_width 赋值");
    }
    
    if (style.right_image_width > 0.0) {
        self.right_image_spacing.constant = style.right_image_spacing;
        self.right_image_width.constant = MIN(style.right_image_width ?: 0.0, style.page_title_view.height);
        self.right_image_height.constant = MIN(style.right_image_height ?: 0.0, style.page_title_view.height);
        [self.right_image setImage:[UIImage imageNamed:style.un_select_image_names[self.tag] inBundle:style.title_image_bundel compatibleWithTraitCollection:nil]];
        self.title_center_x.constant = self.title_center_x.constant - (style.right_image_width / 2);
        if (style.right_image_spacing > 0.0) {
            self.title_center_x.constant = self.title_center_x.constant - (style.right_image_spacing / 2);
        }
    } else {
        LGFLog(@"如果要显示右边图标，请给 right_image_width 赋值");
    }
    
    if (style.top_image_height > 0.0) {
        self.top_image_spacing.constant = style.top_image_spacing;
        self.top_image_width.constant = MIN(style.top_image_width ?: 0.0, style.page_title_view.width);
        self.top_image_height.constant = MIN(style.top_image_height ?: 0.0, style.page_title_view.height);
        [self.top_image setImage:[UIImage imageNamed:style.un_select_image_names[self.tag] inBundle:style.title_image_bundel compatibleWithTraitCollection:nil]];
        self.title_center_y.constant = self.title_center_y.constant + (style.top_image_height / 2);
        if (style.top_image_spacing > 0.0) {
            self.title_center_y.constant = self.title_center_y.constant + (style.top_image_spacing / 2);
        }
    } else {
        LGFLog(@"如果要显示顶部图标，请给 top_image_height 赋值");
    }
    
    if (style.bottom_image_height > 0.0) {
        self.bottom_image_spacing.constant = style.bottom_image_spacing;
        self.bottom_image_width.constant = MIN(style.bottom_image_width ?: 0.0, style.page_title_view.width);
        self.bottom_image_height.constant = MIN(style.bottom_image_height ?: 0.0, style.page_title_view.height);
        [self.bottom_image setImage:[UIImage imageNamed:style.un_select_image_names[self.tag] inBundle:style.title_image_bundel compatibleWithTraitCollection:nil]];
        self.title_center_y.constant = self.title_center_y.constant - (style.bottom_image_height / 2);
        if (style.bottom_image_spacing > 0.0) {
            self.title_center_y.constant = self.title_center_y.constant - (style.bottom_image_spacing / 2);
        }
    } else {
        LGFLog(@"如果要显示底部图标，请给 bottom_image_height 赋值");
    }
    
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setCurrentTransformSx:(CGFloat)currentTransformSx {
    _currentTransformSx = currentTransformSx;
    self.transform = CGAffineTransformMakeScale(currentTransformSx, currentTransformSx);
}

@end
