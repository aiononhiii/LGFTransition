//
//  UIViewController+LGFAnimatedTransition.h
//  LGFAnimatedNavigationDemo
//
//  Created by apple on 2018/6/22.
//  Copyright © 2018年 来国锋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGFTransition.h"

typedef NS_ENUM(NSUInteger, lgf_PanType) {
    lgf_PopPan,
    lgf_DismissPan,
};

UIKIT_EXTERN NSString *const lgf_InteractiveTransitionKey;
UIKIT_EXTERN NSString *const lgf_IsUseLGFAnimatedTransitionKey;
UIKIT_EXTERN NSString *const lgf_IsShowNaviVCKey;
UIKIT_EXTERN NSString *const lgf_OtherShowDelegateKey;
UIKIT_EXTERN NSString *const lgf_OtherModalDelegateKey;

@interface UIViewController (LGFAnimatedTransition) <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *lgf_InteractiveTransition;
@property (nonatomic, assign) lgf_PanType lgf_PanType;
// 用来手动指定某个控制器不需要隐藏 navigationBar YES 不需要隐藏 NO 需要隐藏 默认 NO
@property (assign, nonatomic) BOOL lgf_IsShowNaviVC;
#pragma mark - 赋值来决定是否使用其他自定义转场动画
@property(nonatomic, weak) id<UINavigationControllerDelegate> lgf_OtherShowDelegate;
@property (nonatomic, weak) id <UIViewControllerTransitioningDelegate> lgf_OtherModalDelegate;
#pragma mark - 添加拖动手势 / Add the UIPanGestureRecognizer
- (void)lgf_AddPopPan:(lgf_PanType)panType;
#pragma mark - 是否使用了自定义的转场动画 / Whether to use a custom transition animation
/**
 @param modalDuration Modal转场动画时长 / Animation duration
 */
+ (void)lgf_AnimatedTransitionModalDuration:(NSTimeInterval)modalDuration;
@end
