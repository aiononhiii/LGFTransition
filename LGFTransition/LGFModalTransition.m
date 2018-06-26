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
@property(nonatomic, strong) UIViewController *toVC;
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
    [containerView addSubview:fromView];
    
    // Present 后的 ViewController
    // Present to ViewController
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toVC.view;
    [containerView addSubview:toView];
    
    // 判断是 Present 还是 Dismiss 操作
    // Determine if it is a Present or Dismiss operation
    if (self.isPresent) {
        [containerView bringSubviewToFront:toView];
        toView.frame = CGRectMake(0.0,
                                  lgf_ScreenHeight,
                                  lgf_ScreenWidth,
                                  lgf_ScreenHeight);
    } else  {
        [containerView bringSubviewToFront:fromView];
        fromView.layer.shadowColor = [UIColor blackColor].CGColor;
        fromView.layer.shadowRadius = 3.0;
        fromView.layer.shadowOpacity = 0.5;
        toView.frame = CGRectMake(0.0,
                                  0.0,
                                  lgf_ScreenWidth,
                                  lgf_ScreenHeight);
    }
    
    // 执行自定义转场动画 改变UI
    // Perform custom transition animations Change UI
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (self.isPresent) {
            toView.frame = CGRectMake(toView.frame.origin.x,
                                      0.0,
                                      toView.frame.size.width,
                                      toView.frame.size.height);
        } else {
            fromView.frame = CGRectMake(fromView.frame.origin.x,
                                        lgf_ScreenHeight,
                                        fromView.frame.size.width,
                                        fromView.frame.size.height);
        }
    } completion:^(BOOL finished) {
        // 设置 transitionContext 通知系统动画执行完毕
        // Set transitionContext to notify system animation completion
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        // 删除阴影
        // Remove shadow
        fromView.layer.shadowOpacity = 0.0;
        // 判断转场是否取消
        // Determine whether the transition is canceled
        if (![transitionContext transitionWasCancelled]) {
            self.toVC = toVC;
        } else {
            self.toVC = fromVC;
        }
        // 给 self.toVC 添加手势
        // Add gestures to toVC
        [self.toVC lgf_AddPopPan:lgf_DismissPan];
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
