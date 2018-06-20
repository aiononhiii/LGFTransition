//
//  UINavigationController+LGFAnimatedTransition.h
//  LGF
//
//  Created by apple on 2017/6/13.
//  Copyright © 2018年 来国锋. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const lgf_InteractivePopTransitionKey;

@interface UINavigationController (LGFAnimatedTransition)
#pragma mark - 是否使用自定义的转场动画
+ (void)lgf_AnimatedTransitionIsUse:(BOOL)isUse;
/**
 @param isUse 是否使用自定义的转场动画
 @param transitionDuration 动画时间
 */
+ (void)lgf_AnimatedTransitionIsUse:(BOOL)isUse transitionDuration:(NSTimeInterval)transitionDuration;
@end

@interface UIViewController (LGFAnimatedTransition)
@property (strong, nonatomic) UIPercentDrivenInteractiveTransition *lgf_InteractivePopTransition;
#pragma mark - 添加左侧边缘拖动手势
- (void)lgf_AddUIScreenEdgePan;
#pragma mark - 是否使用自定义的转场动画
+ (void)lgf_AnimatedTransitionIsUse:(BOOL)isUse;
@end


