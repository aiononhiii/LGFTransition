//
//  LGFTitleLine.m
//  LGFPageTitleView
//
//  Created by apple on 2018/3/23.
//  Copyright © 2018年 来国锋. All rights reserved.
//

#import "LGFTitleLine.h"

@interface LGFTitleLine()
@property (strong, nonatomic) UIImageView *line_back_imageview;
@end
@implementation LGFTitleLine

+ (instancetype)style:(LGFPageTitleStyle *)style {
    LGFTitleLine *line = [LGFBundle loadNibNamed:NSStringFromClass([LGFPageTitleView class]) owner:self options:nil][2];
    line.clipsToBounds = YES;
    line.style = style;
    return line;
}

- (UIImageView *)line_back_imageview {
    if (!_line_back_imageview) {
        _line_back_imageview = [[UIImageView alloc] initWithFrame:self.bounds];
        _line_back_imageview.clipsToBounds = YES;
        _line_back_imageview.contentMode = UIViewContentModeScaleToFill;
    }
    return _line_back_imageview;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    return self;
}

- (void)setStyle:(LGFPageTitleStyle *)style {
    _style = style;
    self.backgroundColor = style.line_color;
    CGFloat Y = style.page_title_view.height - ((style.line_height + style.line_bottom) > style.page_title_view.height ? style.page_title_view.height : (style.line_height + style.line_bottom));
    CGFloat H = (style.line_height + style.line_bottom) > style.page_title_view.height ? (style.page_title_view.height - style.line_bottom) : style.line_height;
    if (style.line_width_type == FixedWith) {
        self.width = style.line_width;
    } else if (style.line_width_type == EqualTitle) {
        self.width = style.title_fixed_width;
    }
    self.y = Y;
    self.height = H;
    self.alpha = style.line_alpha;
    self.layer.cornerRadius = style.line_cornerRadius;
    if (style.line_back_image && self.subviews.count == 0) {
        [self setImage:style.line_back_image];
    }
}

@end
