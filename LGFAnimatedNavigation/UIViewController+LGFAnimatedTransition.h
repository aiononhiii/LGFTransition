//
//  UIViewController+LGFAnimatedTransition.h
//  LGFAnimatedNavigationDemo
//
//  Created by apple on 2018/6/22.
//  Copyright © 2018年 来国锋. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, lgf_PanType) {
    lgf_PopPan,
    lgf_DismissPan,
};

UIKIT_EXTERN NSString *const lgf_InteractiveTransitionKey;
UIKIT_EXTERN NSString *const lgf_IsUseLGFAnimatedTransitionKey;

@interface UIViewController (LGFAnimatedTransition) <UIGestureRecognizerDelegate>
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *lgf_InteractiveTransition;
@property (nonatomic, assign) lgf_PanType lgf_PanType;
#pragma mark - 添加拖动手势 / Add the UIPanGestureRecognizer
- (void)lgf_AddPopPan:(lgf_PanType)panType;
#pragma mark - 是否使用了自定义的转场动画 / Whether to use a custom transition animation
/**
 @param isUse 是否使用自定义的转场动画 / Whether to use a custom transition animation
 @param modalDuration Modal转场动画时长 / Animation duration
 */
+ (void)lgf_AnimatedTransitionIsUse:(BOOL)isUse modalDuration:(NSTimeInterval)modalDuration;
@end
