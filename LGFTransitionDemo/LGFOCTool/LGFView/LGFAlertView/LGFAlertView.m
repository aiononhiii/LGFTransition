//
//  QTAlertView.m
//  OptimalLive
//
//  Created by apple on 2018/7/9.
//  Copyright © 2018年 QT. All rights reserved.
//

#import "LGFAlertView.h"

//当前视图
#define LGFLastView LGFApplication.windows.firstObject
#define LGFApplication [UIApplication sharedApplication]

@implementation LGFAlertViewStyle
lgf_ViewForM(LGFAlertViewStyle);
- (instancetype)init {
    self = [super init];
    self.lgf_CancelTitle = @"取消";
    self.lgf_CancelTitleColor = [UIColor lgf_ColorWithHexString:@"333333"];
    self.lgf_CancelTitleFont = [UIFont boldSystemFontOfSize:16];
    self.lgf_CancelBackColor = [UIColor whiteColor];
    self.lgf_ConfirmTitle = @"确定";
    self.lgf_ConfirmTitleColor = [UIColor lgf_ColorWithHexString:@"333333"];
    self.lgf_ConfirmTitleFont = [UIFont boldSystemFontOfSize:16];
    self.lgf_ConfirmBackColor = [UIColor whiteColor];
    self.lgf_SureTitle = @"我知道了";
    self.lgf_SureTitleColor = [UIColor lgf_ColorWithHexString:@"333333"];
    self.lgf_SureTitleBackColor = [UIColor whiteColor];
    self.lgf_SureTitleFont = [UIFont boldSystemFontOfSize:16];
    self.lgf_HighColorTitle = @"";
    self.lgf_AlertCornerRadius = 13.0;
    self.lgf_MessageFont = [UIFont boldSystemFontOfSize:16];;
    return self;
}
@end

@implementation LGFAlertView

lgf_XibViewForM(LGFAlertView, @"LGFAlertView");

- (void)lgf_ShowAlertWithStyle:(LGFAlertViewStyle *)style message:(NSString *)message sure:(QTSureBlock)sure {
    self.sureButton.hidden = NO;
    self.cancelButton.hidden = YES;
    self.confirmButton.hidden = YES;
    self.centerLine.hidden = YES;
    [self lgf_ShowAlertWithStyle:style message:message sure:sure cancel:nil confirm:nil];
}

- (void)lgf_ShowAlertWithStyle:(LGFAlertViewStyle *)style message:(NSString *)message cancel:(QTCancelBlock)cancel confirm:(QTConfirmBlock)confirm {
    self.sureButton.hidden = YES;
    self.cancelButton.hidden = NO;
    self.confirmButton.hidden = NO;
    self.centerLine.hidden = NO;
    [self lgf_ShowAlertWithStyle:style message:message sure:nil cancel:cancel confirm:confirm];
}

- (void)lgf_ShowAlertWithStyle:(LGFAlertViewStyle *)style message:(NSString *)message sure:(QTSureBlock)sure cancel:(QTCancelBlock)cancel confirm:(QTConfirmBlock)confirm {
    self.firstResponderView = (UIView *)[LGFAlertView lgf_CurrentFirstResponder];
    [LGFLastView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isKindOfClass:[LGFAlertView class]]) {
            [obj removeFromSuperview];
        }
    }];
    [LGFLastView endEditing:YES];
    self.frame = LGFLastView.bounds;
    [LGFLastView addSubview:self];
    self.alertBackView.layer.cornerRadius = style.lgf_AlertCornerRadius;
    [self.cancelButton setTitle:style.lgf_CancelTitle forState:UIControlStateNormal];
    [self.cancelButton setTitleColor:style.lgf_CancelTitleColor forState:UIControlStateNormal];
    [self.cancelButton setBackgroundColor:style.lgf_CancelBackColor];
    self.cancelButton.titleLabel.font = style.lgf_CancelTitleFont;
    [self.confirmButton setTitle:style.lgf_ConfirmTitle forState:UIControlStateNormal];
    [self.confirmButton setTitleColor:style.lgf_ConfirmTitleColor forState:UIControlStateNormal];
    [self.confirmButton setBackgroundColor:style.lgf_ConfirmBackColor];
    self.confirmButton.titleLabel.font = style.lgf_CancelTitleFont;
    [self.sureButton setTitle:style.lgf_SureTitle forState:UIControlStateNormal];
    [self.sureButton setTitleColor:style.lgf_SureTitleColor forState:UIControlStateNormal];
    [self.sureButton setBackgroundColor:style.lgf_SureTitleBackColor];
    self.sureButton.titleLabel.font = style.lgf_SureTitleFont;
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:message];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    if (style.lgf_HighColorTitle && style.lgf_HighColor) {
        NSRange range = [[attrStr string] rangeOfString:style.lgf_HighColorTitle];
        [attrStr addAttribute:NSForegroundColorAttributeName value:style.lgf_HighColor range:range];
    }
    paragraphStyle.lineSpacing = 5;
    paragraphStyle.alignment = NSTextAlignmentCenter;
    [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attrStr.string.length)];
    self.title.font = style.lgf_MessageFont;
    self.title.attributedText = attrStr;
    self.sureBlock = sure;
    self.cancelBlock = cancel;
    self.confirmBlock = confirm;
    
    // 动画
    self.alertBackView.transform = CGAffineTransformMakeScale(0.85, 0.85);
    [UIView animateWithDuration:0.25 animations:^{
        self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.3];
    }];
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alertBackView.transform = CGAffineTransformIdentity;
    } completion:nil];
}

- (IBAction)cancel:(UIButton *)sender {
    [self selfRemove];
    lgf_HaveBlock(self.cancelBlock);
}

- (IBAction)confirm:(UIButton *)sender {
    [self selfRemove];
    lgf_HaveBlock(self.confirmBlock);
}

- (IBAction)sure:(UIButton *)sender {
    [self selfRemove];
    lgf_HaveBlock(self.sureBlock);
}

- (void)selfRemove {
    self.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0];
    [self removeFromSuperview];
    [self.firstResponderView becomeFirstResponder];
}

static __weak id lgf_CurrentFirstResponder;

+ (id)lgf_CurrentFirstResponder {
    lgf_CurrentFirstResponder = nil;
    [[UIApplication sharedApplication] sendAction:@selector(lgf_FindFirstResponder:)
                                               to:nil
                                             from:nil
                                         forEvent:nil];
    return lgf_CurrentFirstResponder;
}

- (void)lgf_FindFirstResponder:(id)sender {
    lgf_CurrentFirstResponder = self;
}

@end
