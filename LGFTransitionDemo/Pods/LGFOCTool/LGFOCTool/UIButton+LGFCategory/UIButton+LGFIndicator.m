//
//  UIButton+LGFIndicator.m
//  LGFOCTool
//
//  Created by apple on 2018/5/14.
//  Copyright © 2018年 来国锋. All rights reserved.
//

#import "UIButton+LGFIndicator.h"
#import <objc/runtime.h>

static NSString *const lgf_IndicatorViewKey = @"lgf_IndicatorViewKey";
static NSString *const lgf_ButtonTextObjectKey = @"lgf_ButtonTextObjectKey";

@implementation UIButton (LGFIndicator)

#pragma mark - 按钮显示白色菊花

- (void)lgf_ShowWhiteIndicator {
    [self lgf_ShowIndicator:UIActivityIndicatorViewStyleWhite];
}

#pragma mark - 按钮显示灰色菊花

- (void)lgf_ShowGrayIndicator {
    [self lgf_ShowIndicator:UIActivityIndicatorViewStyleGray];
}

#pragma mark - 按钮隐藏菊花

- (void)lgf_HideIndicator {
    NSString *currentButtonText = (NSString *)objc_getAssociatedObject(self, &lgf_ButtonTextObjectKey);
    UIActivityIndicatorView *indicator = (UIActivityIndicatorView *)objc_getAssociatedObject(self, &lgf_IndicatorViewKey);
    [indicator removeFromSuperview];
    [self setTitle:currentButtonText forState:UIControlStateNormal];
    self.enabled = YES;
}

- (void)lgf_ShowIndicator:(UIActivityIndicatorViewStyle)style {
    UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:style];
    indicator.center = CGPointMake(self.bounds.size.width / 2, self.bounds.size.height / 2);
    [indicator startAnimating];
    NSString *currentButtonText = self.titleLabel.text;
    objc_setAssociatedObject(self, &lgf_ButtonTextObjectKey, currentButtonText, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    objc_setAssociatedObject(self, &lgf_IndicatorViewKey, indicator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setTitle:@"" forState:UIControlStateNormal];
    self.enabled = NO;
    [self addSubview:indicator];
}

@end
