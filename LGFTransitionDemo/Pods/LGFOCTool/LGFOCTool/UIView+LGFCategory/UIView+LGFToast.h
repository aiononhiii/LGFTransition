//
//  UIView+LGFToast.h
//  LGFOCTool
//
//  Created by apple on 2018/5/17.
//  Copyright © 2018年 来国锋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGFOCTool.h"

typedef NS_ENUM(NSUInteger, LGFToastPosition) {
    LGFToastCenter,
    LGFToastTop,
    LGFToastBottom,
};

typedef NS_ENUM(NSUInteger, LGFToastImagePosition) {
    LGFToastImageTop,
    LGFToastImageBottom,
    LGFToastImageLeft,
    LGFToastImageRight,
};

@interface LGFToastStyle : NSObject
// Toast文字
@property (copy, nonatomic) NSString *LGFToastMessage;
// Toast文字字体
@property (nonatomic, strong) UIFont *LGFToastMessageFont;
// Toast文字颜色
@property (nonatomic, strong) UIColor *LGFToastMessageTextColor;
// Toast图片
@property (nonatomic, strong) UIImage *LGFToastImage;
// Toast位置
@property (assign, nonatomic) LGFToastPosition LGFToastPosition;
// 图片相对于文字位置
@property (assign, nonatomic) LGFToastImagePosition LGFToastImagePosition;
// Toast背景色
@property (nonatomic, strong) UIColor *LGFToastBackColor;
// Toast圆角
@property (assign, nonatomic) CGFloat LGFToastCornerRadius;
// Toast消失动画时间
@property (assign, nonatomic) NSTimeInterval LGFDismissDuration;
// Toast停留时间
@property (assign, nonatomic) NSTimeInterval LGFDuration;
// 图片文字间隔
@property (assign, nonatomic) CGFloat LGFMessageImageSpacing;
// 四边距离
@property (assign, nonatomic) CGFloat LGFToastSpacing;
// Toast最大宽度
@property (assign, nonatomic) CGFloat LGFMaxWidth;
// Toast最大高度
@property (assign, nonatomic) CGFloat LGFMaxHeight;
// 是否阻挡父View手势
@property (assign, nonatomic) BOOL LGFCancelSuperGesture;
// 是否有图片
@property (assign, nonatomic) BOOL LGFToastHaveIamge;
// 图片限定大小
@property (assign, nonatomic) CGSize LGFToastImageSize;
+ (instancetype)shard;
- (CGFloat)lgf_HeightWithText:(NSString *)text font:(UIFont *)font width:(CGFloat)width;
- (CGFloat)lgf_WidthWithText:(NSString *)text font:(UIFont *)font height:(CGFloat)height;
@end

@interface LGFToastView : UIView
@property (nonatomic, strong) LGFToastStyle *style;
@property (nonatomic, strong) UIImageView *image;
@property (nonatomic, strong) UILabel *message;
lgf_AllocOnlyOnceForH(ToastView);
@end

@interface UIView (LGFToast)

- (void)lgf_ShowToastStyle:(LGFToastStyle *)style completion:(void (^ __nullable)(void))completion;
- (void)lgf_ShowToastMessage:(NSString *)message completion:(void (^ __nullable)(void))completion;
- (void)lgf_ShowToastMessage:(NSString *)message duration:(NSTimeInterval)duration completion:(void (^ __nullable)(void))completion;
- (void)lgf_ShowToastImage:(UIImage *)image completion:(void (^ __nullable)(void))completion;
- (void)lgf_ShowToastImage:(UIImage *)image duration:(NSTimeInterval)duration completion:(void (^ __nullable)(void))completion;
- (void)lgf_ShowToastImageAndMessage:(NSString *)message image:(UIImage *)image completion:(void (^ __nullable)(void))completion;
- (void)lgf_ShowToastImageAndMessage:(NSString *)message image:(UIImage *)image duration:(NSTimeInterval)duration completion:(void (^ __nullable)(void))completion;

- (void)lgf_ShowToastActivity:(UIEdgeInsets)Insets;
- (void)lgf_HideToastActivity;

@end


