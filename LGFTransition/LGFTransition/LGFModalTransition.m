//
//  LGFModalTransition.m
//  LGFAnimatedNavigationDemo
//
//  Created by apple on 2018/6/22.
//  Copyright © 2018年 来国锋. All rights reserved.
//

#import "LGFModalTransition.h"

@interface LGFModalTransition()
// Push 过去的 ViewController
// Push ViewController
@property(nonatomic, weak) UIViewController *toVC;
// 是否是 Present
@property (nonatomic, assign) BOOL isPresent;
@end

@implementation LGFModalTransition

lgf_AllocOnlyOnceForM(LGFModalTransition, LGFModalTransition);

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return self.lgf_TransitionDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    // 转场过渡的容器
    // Transition container
    UIView *containerView = [transitionContext containerView];
    
    // Present 前的 ViewController
    // Present from ViewController
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromView = fromVC.view;
    
    // Present 后的 ViewController
    // Present to ViewController
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toVC.view;
    [containerView addSubview:toView];
    
    // 初始化 半透明黑色遮罩
    // Initialization Translucent black mask
    UIView *mask = [[UIView alloc] init];
    mask.backgroundColor = [UIColor blackColor];
    mask.frame = [[UIScreen mainScreen] bounds];
    
    // 判断是 Present 还是 Dismiss 操作
    // Determine if it is a Present or Dismiss operation
    if (self.isPresent) {
        mask.alpha = 0.0;
        [fromView addSubview:mask];
        [containerView bringSubviewToFront:toView];
        toView.transform = CGAffineTransformMakeTranslation(0.0, lgf_ScreenHeight);
    } else  {
        mask.alpha = 0.6;
        [toView addSubview:mask];
        [containerView bringSubviewToFront:fromView];
        toView.transform = CGAffineTransformIdentity;
    }
    
    // 执行自定义转场动画 改变UI
    // Perform custom transition animations Change UI
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (self.isPresent) {
            mask.alpha = 0.6;
            toView.transform = CGAffineTransformIdentity;
        } else {
            mask.alpha = 0.0;
            fromView.transform = CGAffineTransformMakeTranslation(0.0, lgf_ScreenHeight);
        }
    } completion:^(BOOL finished) {
        BOOL cancelled = [transitionContext transitionWasCancelled];
        // 删除遮罩
        // Remove black mask
        [mask removeFromSuperview];
        // 判断转场是否取消
        // Determine whether the transition is canceled
        if (!cancelled) {
            fromView.transform = CGAffineTransformIdentity;
            self.toVC = toVC;
            // 给 self.toVC 添加手势
            // Add gestures to toVC
            [self.toVC lgf_AddPopPan:lgf_DismissPan];
        } else {
            toView.transform = CGAffineTransformIdentity;
            [toView removeFromSuperview];
        }
        // 设置 transitionContext 通知系统动画执行完毕
        // Set transitionContext to notify system animation completion
        [transitionContext completeTransition:!cancelled];
    }];
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self;
}

- (nullable id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self;
}

- (nullable id <UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id <UIViewControllerAnimatedTransitioning>)animator {
    self.isPresent = YES;
    return [self interactionControllerForAll];
}

- (nullable id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    self.isPresent = NO;
    return [self interactionControllerForAll];
}

- (nullable id<UIViewControllerInteractiveTransitioning>)interactionControllerForAll {
    // 判断是否是手势 dismiss
    // Judge whether it is gesture dismiss
    return self.toVC.lgf_InteractiveTransition;
}

@end
