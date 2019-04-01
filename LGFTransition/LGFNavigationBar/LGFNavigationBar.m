//
//  LGFNavigationBar.m
//  OptimalLive
//
//  Created by apple on 2019/1/11.
//  Copyright © 2019年 QT. All rights reserved.
//

#import "LGFNavigationBar.h"

@implementation LGFNavigationBarStyle

+ (instancetype)lgf {
    LGFNavigationBarStyle *style = [[LGFNavigationBarStyle alloc] init];
    style.lgf_TitleText = @"";
    style.lgf_TitleTextFont = [UIFont boldSystemFontOfSize:18];
    style.lgf_TitleColor = [UIColor blackColor];
    style.lgf_LeftBtnTitleColor = [UIColor blackColor];
    style.lgf_RightBtnTitleColor = [UIColor blackColor];
    style.lgf_LeftBtnTitleText = @"返回";
    style.lgf_RightBtnTitleText = @"";
    style.lgf_LeftBtnImageDark = lgf_Image(@"");
    style.lgf_LeftBtnImageLight = lgf_Image(@"");
    style.lgf_RightBtnImageDark = lgf_Image(@"");
    style.lgf_RightBtnImageLight = lgf_Image(@"");
    style.lgf_ShowLeftBtnImage = NO;
    style.lgf_ShowRightBtnImage = NO;
    style.lgf_ShowRightBtn = NO;
    style.lgf_TitleView = [UIView new];
    style.lgf_ShowTitleView = NO;
    return style;
}

@end

@implementation LGFNavigationBar

lgf_XibViewForM(LGFNavigationBar, @"LGFNavigationBar");

- (void)lgf_ShowLGFNavigationBar:(UIView *)SV {
    [self lgf_ShowLGFNavigationBar:SV style:[LGFNavigationBarStyle lgf]];
}

- (void)lgf_ShowLGFNavigationBar:(UIView *)SV style:(LGFNavigationBarStyle *)style {
    self.frame = CGRectMake(0, 0, lgf_ScreenWidth, IPhoneX_NAVIGATION_BAR_HEIGHT);
    [SV addSubview:self];
    self.style = style;
    self.lgf_Title.text = style.lgf_TitleText;
    self.lgf_Title.font = style.lgf_TitleTextFont;
    self.lgf_Title.textColor = style.lgf_TitleColor;
    self.lgf_LeftButton.titleLabel.textColor = style.lgf_LeftBtnTitleColor;
    self.lgf_RightButton.hidden = !style.lgf_ShowRightBtn;
    self.lgf_RightButton.titleLabel.textColor = style.lgf_RightBtnTitleColor;
    if (style.lgf_ShowLeftBtnImage) {
        [self.lgf_LeftButton setImage:style.lgf_LeftBtnImageDark forState:UIControlStateNormal];
    } else {
        [self.lgf_LeftButton setTitle:style.lgf_LeftBtnTitleText forState:UIControlStateNormal];
    }
    if (style.lgf_ShowRightBtnImage) {
        [self.lgf_RightButton setImage:style.lgf_RightBtnImageDark forState:UIControlStateNormal];
    } else {
        [self.lgf_RightButton setTitle:style.lgf_RightBtnTitleText forState:UIControlStateNormal];
    }
    if (style.lgf_ShowTitleView) {
        style.lgf_TitleView.frame = self.lgf_TitleView.bounds;
        [self.lgf_TitleView addSubview:style.lgf_TitleView];
    }
}

- (IBAction)leftBtnClick:(UIButton *)sender {
    if (self.leftButtonClick) {
        lgf_HaveBlock(self.leftButtonClick, sender);
    } else {
        UIViewController *superVC = [self lgf_GetSuperVC:self];
        if (superVC.navigationController) {
            [superVC.navigationController popViewControllerAnimated:YES];
        } else {
            [superVC dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (UIViewController*)lgf_GetSuperVC:(UIView *)view {
    id target = view;
    while (target) {
        target = ((UIResponder*)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}

- (IBAction)rightBtnClick:(UIButton *)sender {
    lgf_HaveBlock(self.rightButtonClick, sender);
}

- (void)lgf_ToLight {
    self.lgf_Title.textColor = [UIColor whiteColor];
    if (self.style.lgf_ShowLeftBtnImage) {
        [self.lgf_LeftButton setImage:self.style.lgf_LeftBtnImageLight forState:UIControlStateNormal];
    } else {
        self.lgf_LeftButton.titleLabel.textColor = [UIColor whiteColor];
    }
    if (self.style.lgf_ShowRightBtnImage) {
        [self.lgf_RightButton setImage:self.style.lgf_LeftBtnImageLight forState:UIControlStateNormal];
    } else {
        self.lgf_RightButton.titleLabel.textColor = [UIColor whiteColor];
    }
}

- (void)lgf_ToDark {
    self.lgf_Title.textColor = self.style.lgf_TitleColor;
    if (self.style.lgf_ShowLeftBtnImage) {
        [self.lgf_LeftButton setImage:self.style.lgf_LeftBtnImageDark forState:UIControlStateNormal];
    } else {
        self.lgf_LeftButton.titleLabel.textColor = self.style.lgf_LeftBtnTitleColor;
    }
    if (self.style.lgf_ShowRightBtnImage) {
        [self.lgf_RightButton setImage:self.style.lgf_RightBtnImageDark forState:UIControlStateNormal];
    } else {
        self.lgf_RightButton.titleLabel.textColor = self.style.lgf_RightBtnTitleColor;
    }
}

@end
