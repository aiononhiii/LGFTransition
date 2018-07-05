//
//  UIView+LGFToast.m
//  LGFOCTool
//
//  Created by apple on 2018/5/17.
//  Copyright © 2018年 来国锋. All rights reserved.
//

#import "UIView+LGFToast.h"
#import <objc/runtime.h>

@implementation LGFToastStyle

- (instancetype)init {
    if (self = [super init]) {
        self.LGFToastImage = [UIImage imageNamed:@"testIcon"];
        self.LGFToastMessage = @"";
        self.LGFToastPosition = LGFToastCenter;
        self.LGFToastImagePosition = LGFToastImageTop;
        self.LGFToastMessageFont = [UIFont systemFontOfSize:15];
        self.LGFToastMessageTextColor = [UIColor whiteColor];
        self.LGFToastBackColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.7];
        self.LGFToastCornerRadius = 5.0;
        self.LGFDismissDuration = 0.3;
        self.LGFDuration = 0.5;
        self.LGFCancelSuperGesture = YES;
        self.LGFMessageImageSpacing = 5.0;
        self.LGFToastSpacing = 10.0;
        self.LGFToastImageSize = CGSizeMake(50.0, 50.0);
        self.LGFMaxWidth = [UIScreen mainScreen].bounds.size.width * 0.3;
        self.LGFMaxHeight = [UIScreen mainScreen].bounds.size.height * 0.8;
    }
    return self;
}

- (void)setLGFToastImage:(UIImage *)LGFToastImage {
    _LGFToastImage = LGFToastImage;
    if (LGFToastImage) {
        self.LGFToastHaveIamge = YES;
    } else {
        self.LGFToastHaveIamge = NO;
    }
}

+ (instancetype)shard {
    LGFToastStyle *style = [[LGFToastStyle alloc] init];
    return style;
}

- (CGFloat)lgf_HeightWithText:(NSString *)text font:(UIFont *)font width:(CGFloat)width {
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:textFont,
                                 NSParagraphStyleAttributeName:paragraph};
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                         options:(NSStringDrawingUsesLineFragmentOrigin |
                                                  NSStringDrawingTruncatesLastVisibleLine)
                                      attributes:attributes
                                         context:nil].size;
    return ceil(textSize.height);
}

- (CGFloat)lgf_WidthWithText:(NSString *)text font:(UIFont *)font height:(CGFloat)height {
    UIFont *textFont = font ? font : [UIFont systemFontOfSize:[UIFont systemFontSize]];
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:textFont,
                                 NSParagraphStyleAttributeName:paragraph};
    CGSize textSize = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, height)
                                         options:(NSStringDrawingUsesLineFragmentOrigin |
                                                  NSStringDrawingTruncatesLastVisibleLine)
                                      attributes:attributes
                                         context:nil].size;
    return ceil(textSize.width);
}

@end

@implementation LGFToastView

lgf_AllocOnlyOnceForM(LGFToastView, ToastView);

- (UIImageView *)image {
    if (!_image) {
        _image = [[UIImageView alloc] init];
        [self addSubview:_image];
    }
    return _image;
}

- (UILabel *)message {
    if (!_message) {
        _message = [[UILabel alloc] init];
        [self addSubview:_message];
    }
    return _message;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}

- (void)setStyle:(LGFToastStyle *)style {
    _style = style;
    if (style.LGFToastHaveIamge) {
        [self.image setImage:style.LGFToastImage];
    }
    self.message.text = style.LGFToastMessage;
    self.message.font = style.LGFToastMessageFont;
    self.message.textColor = style.LGFToastMessageTextColor;
    self.message.numberOfLines = 0;
    self.layer.cornerRadius = style.LGFToastCornerRadius;
    self.backgroundColor = style.LGFToastBackColor;
    self.alpha = 1.0;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.style.LGFToastHaveIamge) {
        switch (self.style.LGFToastImagePosition) {
            case LGFToastImageTop:
                self.image.frame = CGRectMake((self.frame.size.width / 2) - (self.style.LGFToastImageSize.width / 2),
                                              self.style.LGFToastSpacing,
                                              self.style.LGFToastImageSize.width,
                                              self.style.LGFToastImageSize.height);
                self.message.frame = CGRectMake(self.style.LGFToastSpacing,
                                                self.style.LGFToastSpacing + self.style.LGFToastImageSize.height + self.style.LGFMessageImageSpacing,
                                                self.frame.size.width - (self.style.LGFToastSpacing * 2),
                                                self.frame.size.height - (self.style.LGFToastSpacing * 2) - self.image.frame.size.height - self.style.LGFMessageImageSpacing);
                break;
            case LGFToastImageBottom:
                self.image.frame = CGRectMake((self.frame.size.width / 2) - (self.style.LGFToastImageSize.width / 2),
                                              self.frame.size.height - self.style.LGFToastImageSize.height - self.style.LGFToastSpacing,
                                              self.style.LGFToastImageSize.width,
                                              self.style.LGFToastImageSize.height);
                self.message.frame = CGRectMake(self.style.LGFToastSpacing,
                                                self.style.LGFToastSpacing,
                                                self.frame.size.width - (self.style.LGFToastSpacing * 2),
                                                self.frame.size.height - (self.style.LGFToastSpacing * 2) - self.image.frame.size.height - self.style.LGFMessageImageSpacing);
                break;
            case LGFToastImageLeft:
                self.image.frame = CGRectMake(self.style.LGFToastSpacing,
                                              (self.frame.size.height / 2) - (self.style.LGFToastImageSize.height / 2),
                                              self.style.LGFToastImageSize.width,
                                              self.style.LGFToastImageSize.height);
                self.message.frame = CGRectMake(self.style.LGFToastSpacing + self.image.frame.size.width + self.style.LGFMessageImageSpacing,
                                                self.style.LGFToastSpacing,
                                                self.frame.size.width - (self.style.LGFToastSpacing * 2) - self.image.frame.size.width - self.style.LGFMessageImageSpacing,
                                                self.frame.size.height - (self.style.LGFToastSpacing * 2));
                break;
            case LGFToastImageRight:
                self.image.frame = CGRectMake(self.frame.size.width - self.style.LGFToastImageSize.width - self.style.LGFToastSpacing,
                                              (self.frame.size.height / 2) - (self.style.LGFToastImageSize.height / 2),
                                              self.style.LGFToastImageSize.width,
                                              self.style.LGFToastImageSize.height);
                self.message.frame = CGRectMake(self.style.LGFToastSpacing,
                                                self.style.LGFToastSpacing,
                                                self.frame.size.width - (self.style.LGFToastSpacing * 2) - self.image.frame.size.width - self.style.LGFMessageImageSpacing,
                                                self.frame.size.height - (self.style.LGFToastSpacing * 2));
                break;
            default:
                break;
        }
    } else {
        self.message.frame = CGRectMake(self.style.LGFToastSpacing,  self.style.LGFToastSpacing, self.frame.size.width - (self.style.LGFToastSpacing * 2), self.frame.size.height - (self.style.LGFToastSpacing * 2));
    }
}

- (void)dismiss {
    [UIView animateWithDuration:self.style.LGFDismissDuration animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (self.style.LGFCancelSuperGesture) self.superview.userInteractionEnabled = YES;
        [self removeFromSuperview];
    }];
}

@end

@implementation UIView (LGFToast)

static char LGFToastViewKey;
static char LGFToastActivityKey;

- (void)lgf_ShowToastMessage:(NSString *)message completion:(void (^ __nullable)(void))completion {
    LGFToastStyle *style = [LGFToastStyle shard];
    style.LGFToastMessage = message;
    style.LGFToastImage = nil;
    [self lgf_ShowToastStyle:style completion:completion];
}

- (void)lgf_ShowToastMessage:(NSString *)message duration:(NSTimeInterval)duration completion:(void (^ __nullable)(void))completion {
    LGFToastStyle *style = [LGFToastStyle shard];
    style.LGFToastMessage = message;
    style.LGFToastImage = nil;
    style.LGFDuration = duration;
    [self lgf_ShowToastStyle:style completion:completion];
}

- (void)lgf_ShowToastImage:(UIImage *)image completion:(void (^ __nullable)(void))completion {
    LGFToastStyle *style = [LGFToastStyle shard];
    style.LGFToastImage = image;
    style.LGFToastMessage = nil;
    [self lgf_ShowToastStyle:style completion:completion];
}

- (void)lgf_ShowToastImage:(UIImage *)image duration:(NSTimeInterval)duration completion:(void (^ __nullable)(void))completion {
    LGFToastStyle *style = [LGFToastStyle shard];
    style.LGFToastImage = image;
    style.LGFToastMessage = nil;
    style.LGFDuration = duration;
    [self lgf_ShowToastStyle:style completion:completion];
}

- (void)lgf_ShowToastImageAndMessage:(NSString *)message image:(UIImage *)image completion:(void (^ __nullable)(void))completion {
    LGFToastStyle *style = [LGFToastStyle shard];
    style.LGFToastMessage = message;
    style.LGFToastImage = image;
    [self lgf_ShowToastStyle:style completion:completion];
}

- (void)lgf_ShowToastImageAndMessage:(NSString *)message image:(UIImage *)image duration:(NSTimeInterval)duration completion:(void (^ __nullable)(void))completion {
    LGFToastStyle *style = [LGFToastStyle shard];
    style.LGFToastMessage = message;
    style.LGFToastImage = image;
    style.LGFDuration = duration;
    [self lgf_ShowToastStyle:style completion:completion];
}

- (void)lgf_ShowToastStyle:(LGFToastStyle *)style completion:(void (^ __nullable)(void))completion {
    
    if (style.LGFToastMessage.length == 0 && !style.LGFToastImage) {
        return;
    }
    
    // 动态加载 LGFToastView
    LGFToastView *toastView = objc_getAssociatedObject(self, &LGFToastViewKey);
    if (!toastView) {
        toastView = [LGFToastView sharedToastView];
        objc_setAssociatedObject(self, &LGFToastViewKey, toastView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    CGFloat LGFToastViewHeight = [style lgf_HeightWithText:@"" font:style.LGFToastMessageFont width:style.LGFMaxWidth];
    CGFloat LGFToastViewWidth = [style lgf_WidthWithText:style.LGFToastMessage font:style.LGFToastMessageFont height:LGFToastViewHeight];
    if (LGFToastViewWidth >= style.LGFMaxWidth) {
        CGFloat realHeight = [style lgf_HeightWithText:style.LGFToastMessage font:style.LGFToastMessageFont width:style.LGFMaxWidth];
        if (LGFToastViewHeight < realHeight) {
            LGFToastViewHeight = MIN(realHeight, style.LGFMaxHeight);
        }
    }
    CGFloat LGFToastViewY;
    CGFloat LGFToastViewX;
    
    if (style.LGFToastHaveIamge) {
        switch (style.LGFToastImagePosition) {
            case LGFToastImageTop:
                LGFToastViewHeight += style.LGFToastImageSize.height + style.LGFMessageImageSpacing;
                break;
            case LGFToastImageBottom:
                LGFToastViewHeight += style.LGFToastImageSize.height + style.LGFMessageImageSpacing;
                break;
            case LGFToastImageLeft:
                LGFToastViewWidth += style.LGFToastImageSize.width + style.LGFMessageImageSpacing;
                break;
            case LGFToastImageRight:
                LGFToastViewWidth += style.LGFToastImageSize.width + style.LGFMessageImageSpacing;
                break;
            default:
                break;
        }
    }
    
    switch (style.LGFToastPosition) {
        case LGFToastTop:
            LGFToastViewY = self.frame.size.height * 0.2;
            break;
        case LGFToastBottom:
            LGFToastViewY = self.frame.size.height * 0.8;
            break;
        case LGFToastCenter:
            LGFToastViewY = (self.frame.size.height / 2) - (LGFToastViewHeight / 2);
            break;
        default:
            break;
    }
    
    LGFToastViewWidth = MIN(LGFToastViewWidth, style.LGFMaxWidth) + style.LGFToastSpacing * 2;
    LGFToastViewHeight = LGFToastViewHeight + style.LGFToastSpacing * 2;
    LGFToastViewX = (self.frame.size.width / 2) - (LGFToastViewWidth / 2);
    
    toastView.frame = CGRectMake(LGFToastViewX, LGFToastViewY, LGFToastViewWidth, LGFToastViewHeight);
    toastView.style = style;
    [self addSubview:toastView];
    NSLog(@"%f", LGFToastViewHeight);
    [NSObject cancelPreviousPerformRequestsWithTarget:toastView];
    if (style.LGFCancelSuperGesture) self.userInteractionEnabled = NO;
    [toastView performSelector:@selector(dismiss) withObject:nil afterDelay:style.LGFDuration];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((style.LGFDuration + style.LGFDismissDuration) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (completion) {
            completion();
        }
    });
}

#pragma mark - 菊花

- (void)lgf_ShowToastActivity:(UIEdgeInsets)Insets {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.userInteractionEnabled = NO;
        UIView *activityBackView = (UIView *)objc_getAssociatedObject(self, &LGFToastActivityKey);
        [activityBackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [activityBackView removeFromSuperview];
        if (!activityBackView) {
            activityBackView = [[UIView alloc] init];
            activityBackView.backgroundColor = [UIColor colorWithRed:0.98 green:0.98 blue:0.98 alpha:1.0];
        }
        [self addSubview:activityBackView];
        activityBackView.translatesAutoresizingMaskIntoConstraints = NO;
        objc_setAssociatedObject(self, &LGFToastActivityKey, activityBackView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        NSLayoutConstraint *rightConstraint = [NSLayoutConstraint constraintWithItem:activityBackView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self.superview ?: self attribute:NSLayoutAttributeRight multiplier:1.0 constant:Insets.right];
        [self.superview ?: self addConstraint:rightConstraint];
        NSLayoutConstraint *leftConstraint = [NSLayoutConstraint constraintWithItem:activityBackView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self.superview ?: self attribute:NSLayoutAttributeLeft multiplier:1.0 constant:Insets.left];
        [self.superview ?: self addConstraint:leftConstraint];
        NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:activityBackView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.superview ?: self attribute:NSLayoutAttributeTop multiplier:1.0 constant:Insets.top];
        [self.superview ?: self addConstraint:topConstraint];
        NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:activityBackView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.superview ?: self attribute:NSLayoutAttributeBottom multiplier:1.0 constant:Insets.bottom];
        [self.superview ?: self addConstraint:bottomConstraint];
        [self.superview ?: self setNeedsLayout];
        [self.superview ?: self layoutIfNeeded];
        UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc] init];
        activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        [activityView startAnimating];
        activityView.center = CGPointMake(activityBackView.bounds.size.width / 2, activityBackView.bounds.size.height / 2);
        [activityBackView addSubview:activityView];
    });
}

- (void)lgf_HideToastActivity {
    dispatch_async(dispatch_get_main_queue(), ^{
        self.userInteractionEnabled = YES;
        UIView *activityBackView = (UIView *)objc_getAssociatedObject(self, &LGFToastActivityKey);
        if (activityBackView) {
            [activityBackView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [activityBackView removeFromSuperview];
        }
    });
}

@end



