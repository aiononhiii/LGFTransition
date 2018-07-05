//
//  NSString+LGFString.m
//  LGFOCTool
//
//  Created by apple on 2017/5/2.
//  Copyright © 2017年 来国锋. All rights reserved.
//

#import "UIViewController+LGFTopBarMessage.h"
#import <objc/runtime.h>

@implementation LGFTopMessageView

lgf_AllocOnlyOnceForM(LGFTopMessageView, shard);

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.messageLabel = [[UILabel alloc] init];
        self.messageLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [self addSubview:self.messageLabel];
        self.messageIcon = [[UIImageView alloc] init];
        [self addSubview:self.messageIcon];
        
        // 添加轻扫手势
        UISwipeGestureRecognizer *swipeUp = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        swipeUp.direction = UISwipeGestureRecognizerDirectionUp;
        [self addGestureRecognizer:swipeUp];
        UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft;
        [self addGestureRecognizer:swipeLeft];
        UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        swipeRight.direction = UISwipeGestureRecognizerDirectionRight;
        [self addGestureRecognizer:swipeRight];
        
        // 添加轻击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapNow)];
        [self addGestureRecognizer:tap];
    }
    return self;
}

- (void)tapNow {
    // 点击了message
    [self dismiss];
    if (self.tapHandler) {
        self.tapHandler();
    }
}

- (void)dismiss {
    // 隐藏 LGFTopMessageView
    [UIView animateWithDuration:self.style.lgf_AnimateDuration animations:^{
        self.superview.transform = CGAffineTransformIdentity;
        if (self.style.lgf_MessageMode == lgf_Overlay) {
            self.lgf_y -= (self.style.lgf_TopBarSpacingHeight + self.messageLabel.lgf_height);
        }
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)setStyle:(LGFTopMessageStyle *)style {
    _style = style;
    [self resetViews];
}

- (void)resetViews {
    // 控件赋值
    self.messageLabel.numberOfLines = self.style.lgf_LabelMaxLine;
    self.messageLabel.text = self.style.lgf_Message;
    self.backgroundColor = self.style.lgf_MessageBackColor;
    self.messageLabel.textColor = self.style.lgf_MessageTextColor;
    self.messageIcon.image = self.style.lgf_MessageIcon;
    self.messageLabel.font = self.style.lgf_MessageLabelFont;
}

- (void)layoutSubviews {
    // 根据文字获取动态高度
    CGFloat labelWidth = self.lgf_width - (self.style.lgf_BetweenIconAndMessage * 3 + self.style.lgf_IconWidth);
    CGFloat labelHeight = MIN([self.style.lgf_Message lgf_HeightWithFont:self.style.lgf_MessageLabelFont constrainedToWidth:labelWidth], [@"" lgf_HeightWithFont:self.style.lgf_MessageLabelFont constrainedToWidth:labelWidth] * self.style.lgf_LabelMaxLine);
    if (!self.style.lgf_MessageIcon) {
        self.style.lgf_IconWidth = 0.0;
    }
    self.messageIcon.frame = CGRectMake(self.style.lgf_BetweenIconAndMessage, MAX(0, (self.lgf_height - self.style.lgf_IconWidth) / 2), self.style.lgf_IconWidth, self.style.lgf_IconWidth);
    self.messageLabel.frame = CGRectMake(self.style.lgf_IconWidth + self.style.lgf_BetweenIconAndMessage * 2, MAX(0, (self.lgf_height - labelHeight) / 2), self.lgf_width - (self.style.lgf_BetweenIconAndMessage * 3 + self.messageIcon.lgf_width), labelHeight);
}

@end

@implementation UIViewController (LGFTopBarMessage)

static char TopMessageKey;

- (void)lgf_ShowTopMessage:(NSString *)message {
    LGFTopMessageStyle *style = [LGFTopMessageStyle na];
    style.lgf_Message = message;
    [self lgf_ShowTopMessageWithStyle:style withTapBlock:nil];
}

- (void)lgf_ShowTopMessageWithStyle:(LGFTopMessageStyle *)style  withTapBlock:(dispatch_block_t)tapHandler {
    // 首先判断 self 是否已经全部加载完毕
    if ([self isViewLoaded] && self.view.window) {
        [self showMessageWithStyle:style withTapBlock:tapHandler];
    } else {
        // 如果是lgf_Overlay 因为不改变父视图位置, 所以无需等待父视图加载完毕
        if (style.lgf_MessageMode == lgf_Overlay) {
            [self showMessageWithStyle:style withTapBlock:tapHandler];
        }
        NSAssert(style.lgf_MessageMode == lgf_Overlay, @"父视图未加载完毕, 无法使用lgf_Resize ,因为lgf_Resize将改变父视图位置, 为确保父视图已经加载完毕, 请在父视图viewDidAppear方法中添加 (lgf_ShowTopMessage...)方法");
    }
}

- (void)showMessageWithStyle:(LGFTopMessageStyle *)style  withTapBlock:(dispatch_block_t)tapHandler {
    // 判断 Y 点
    CGFloat startY = 0.0;
    if (self.navigationController.navigationBar.translucent) {
        startY = 64.0;
    } else {
        startY = 0.0;
    }
    
    // 获取 label 的高度 LGFTopMessageView 的高度等于 label的高度 + lgf_topBarSpacingHeight
    CGFloat labelWidth = self.view.lgf_width - (style.lgf_BetweenIconAndMessage * 3 + style.lgf_IconWidth);
    CGFloat labelHeight = MIN([style.lgf_Message lgf_HeightWithFont:style.lgf_MessageLabelFont constrainedToWidth:labelWidth], [@"" lgf_HeightWithFont:style.lgf_MessageLabelFont constrainedToWidth:labelWidth] * style.lgf_LabelMaxLine);
    
    // 动态加载 LGFTopMessageView 防止其他视图控制器添加无用属性
    LGFTopMessageView *topMessageV = objc_getAssociatedObject(self, &TopMessageKey);
    if (!topMessageV) {
        topMessageV = [LGFTopMessageView sharedshard];
        objc_setAssociatedObject(self, &TopMessageKey, topMessageV, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    topMessageV.frame = CGRectMake(0, startY - (style.lgf_TopBarSpacingHeight + labelHeight), CGRectGetWidth(self.view.bounds), style.lgf_TopBarSpacingHeight + labelHeight);
    topMessageV.tapHandler = tapHandler;
    topMessageV.style = style;
    [self.view addSubview:topMessageV];
    
    // 隐藏之前取消延迟
    [NSObject cancelPreviousPerformRequestsWithTarget:topMessageV];
    
    // 延迟隐藏
    if (style.lgf_DimissDelay > 0) {
        [topMessageV performSelector:@selector(dismiss) withObject:nil afterDelay:style.lgf_DimissDelay + style.lgf_AnimateDuration];
    } else {
        if (style.lgf_MessageMode == lgf_Resize) {
            [topMessageV performSelector:@selector(dismiss) withObject:nil afterDelay:1.0 + style.lgf_AnimateDuration];
        }
    }
    
    // 执行显示动画
    [UIView animateWithDuration:style.lgf_AnimateDuration animations:^{
        if (style.lgf_MessageMode == lgf_Resize) {
            CGAffineTransform transform = CGAffineTransformMakeTranslation(0, style.lgf_TopBarSpacingHeight + labelHeight);
            self.view.transform = transform;
        } else {
            topMessageV.lgf_y = startY;
        }
    }];
}

- (void)lgf_DismissTopMessage {
    NSArray *subViews = self.view.subviews;
    for (UIView *subView in subViews) {
        if ([subView isKindOfClass:[LGFTopMessageView class]]) {
            LGFTopMessageView *view = (LGFTopMessageView *)subView;
            [view dismiss];
        }
    }
}

@end

@implementation LGFTopMessageStyle

- (instancetype)init {
    self = [super init];
    // 默认配置
    self.lgf_MessageBackColor = [UIColor lgf_ColorWithHexString:@"FBF9FA"];
    self.lgf_MessageTextColor = [UIColor blackColor];
    self.lgf_MessageLabelFont = [UIFont systemFontOfSize:15];
    self.lgf_MessageIcon = nil;
    self.lgf_LabelMaxLine = 1;
    self.lgf_MessageMode = lgf_Overlay;
    self.lgf_DimissDelay = 2.0;
    self.lgf_Message = @"";
    self.lgf_IconWidth = 20.0;
    self.lgf_BetweenIconAndMessage = 10.0;
    self.lgf_AnimateDuration = 0.5;
    self.lgf_TopBarSpacingHeight = 20.0;
    return self;
}

+ (instancetype)na {
    LGFTopMessageStyle *style = [[LGFTopMessageStyle alloc] init];
    return style;
}

@end
