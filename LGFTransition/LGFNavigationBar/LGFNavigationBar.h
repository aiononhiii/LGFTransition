//
//  LGFNavigationBar.h
//  OptimalLive
//
//  Created by apple on 2019/1/11.
//  Copyright © 2019年 QT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGFTransition.h"

NS_ASSUME_NONNULL_BEGIN

@interface LGFNavigationBarStyle : NSObject
@property (copy, nonatomic) NSString *lgf_TitleText;
@property (strong, nonatomic) UIFont *lgf_TitleTextFont;
@property (strong, nonatomic) UIColor *lgf_TitleColor;
@property (strong, nonatomic) UIView *lgf_TitleView;
@property (assign, nonatomic) BOOL lgf_ShowTitleView;
@property (strong, nonatomic) UIColor *lgf_LeftBtnTitleColor;
@property (strong, nonatomic) UIColor *lgf_RightBtnTitleColor;
@property (copy, nonatomic) NSString *lgf_LeftBtnTitleText;
@property (copy, nonatomic) NSString *lgf_RightBtnTitleText;
@property (assign, nonatomic) BOOL lgf_ShowLeftBtnImage;
@property (assign, nonatomic) BOOL lgf_ShowRightBtnImage;
@property (assign, nonatomic) BOOL lgf_ShowRightBtn;
@property (strong, nonatomic) UIImage *lgf_LeftBtnImageDark;
@property (strong, nonatomic) UIImage *lgf_LeftBtnImageLight;
@property (strong, nonatomic) UIImage *lgf_RightBtnImageDark;
@property (strong, nonatomic) UIImage *lgf_RightBtnImageLight;
+ (instancetype)lgf;
@end

@interface LGFNavigationBar : UIView
typedef void(^lgf_LeftButtonClick)(UIButton *sender);
typedef void(^lgf_RightButtonClick)(UIButton *sender);
@property (weak, nonatomic) IBOutlet UILabel *lgf_Title;
@property (weak, nonatomic) IBOutlet UIView *lgf_TitleView;
@property (weak, nonatomic) IBOutlet UIButton *lgf_LeftButton;
@property (weak, nonatomic) IBOutlet UIButton *lgf_RightButton;
@property (copy, nonatomic) lgf_LeftButtonClick leftButtonClick;
@property (copy, nonatomic) lgf_RightButtonClick rightButtonClick;
@property (strong, nonatomic) LGFNavigationBarStyle *style;
lgf_XibViewForH;
- (void)lgf_ToLight;
- (void)lgf_ToDark;
- (void)lgf_ShowLGFNavigationBar:(UIView *)SV;
- (void)lgf_ShowLGFNavigationBar:(UIView *)SV style:(LGFNavigationBarStyle *)style;
@end

NS_ASSUME_NONNULL_END
