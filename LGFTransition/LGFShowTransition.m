//
//  LGFShowTransition.m
//  LGF
//
//  Created by apple on 2018/6/13.
//  Copyright © 2018年 来国锋. All rights reserved.
//

#import "LGFShowTransition.h"

@interface LGFShowTransition()
// Push 过去的 ViewController
// Push ViewController
@property(nonatomic, strong) UIViewController *toVC;
// 是否是 Push
@property (nonatomic, assign) BOOL isPush;
@end

@implementation LGFShowTransition

lgf_AllocOnlyOnceForM(LGFShowTransition, LGFShowTransition);

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return self.lgf_TransitionDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    // 转场过渡的容器
    // Transition container
    UIView *containerView = [transitionContext containerView];

    // Push 前的 ViewController
    // Push from ViewController
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromView = fromVC.view;
    [containerView addSubview:fromView];
    
    // Push 后的 ViewController
    // Push to ViewController
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toVC.view;
    [containerView addSubview:toView];
    
    // 初始化 半透明黑色遮罩
    // Initialization Translucent black mask
    UIView *mask = [[UIView alloc] init];
    mask.backgroundColor = [UIColor blackColor];
    mask.frame = [[UIScreen mainScreen] bounds];
    
    // 判断是 push 还是 pop 操作
    // Determine if it is a push or pop operation
    if (self.isPush) {
        mask.alpha = 0.0;
        [fromView addSubview:mask];
        [containerView bringSubviewToFront:toView];
        toView.transform = CGAffineTransformMakeTranslation(lgf_ScreenWidth, 0);
    } else {
        mask.alpha = 0.6;
        [toView addSubview:mask];
        [containerView bringSubviewToFront:fromView];
        toView.transform = CGAffineTransformMakeTranslation(-(lgf_ScreenWidth * 0.3), 0);
    }
    
    // 执行自定义转场动画 改变UI
    // Perform custom transition animations Change UI
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        if (self.isPush) {
            mask.alpha = 0.6;
            fromView.transform = CGAffineTransformMakeTranslation(-(lgf_ScreenWidth * 0.3), 0);
            toView.transform = CGAffineTransformIdentity;
        } else {
            mask.alpha = 0.0;
            fromView.transform = CGAffineTransformMakeTranslation(lgf_ScreenWidth, 0);
            toView.transform = CGAffineTransformIdentity;
        }
    } completion:^(BOOL finished) {
        // 设置 transitionContext 通知系统动画执行完毕
        // Set transitionContext to notify system animation completion
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        // 删除遮罩
        // Remove black mask
        [mask removeFromSuperview];
        // 判断转场是否取消
        // Determine whether the transition is canceled
        if (![transitionContext transitionWasCancelled]) {
            self.toVC = toVC;
            fromView.transform = CGAffineTransformIdentity;
        } else {
            self.toVC = fromVC;
            toView.transform = CGAffineTransformIdentity;
        }
        // 给 self.toVC 添加手势
        // Add gestures to toVC
        [self.toVC lgf_AddPopPan:lgf_PopPan];
    }];
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC {
    if (operation == UINavigationControllerOperationPush) {
        self.isPush = YES;
    } else {
        self.isPush = NO;
    }
    return self;
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>)animationController {
    // 判断是否是手势 pop
    // Judge whether it is gesture pop
    return self.toVC.lgf_InteractiveTransition;
}

@end
