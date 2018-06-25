//
//  LGFModalTransition.m
//  LGFAnimatedNavigationDemo
//
//  Created by apple on 2018/6/22.
//  Copyright © 2018年 来国锋. All rights reserved.
//

#import "LGFModalTransition.h"
#import "UIViewController+LGFAnimatedTransition.h"

@interface LGFModalTransition()
// Push 过去的 ViewController
// Push ViewController
@property(strong,nonatomic) UIViewController *toVC;
@property (nonatomic, assign) BOOL isPresenting;
// 自定义动画的时长
// Custom animation Duration
@property (nonatomic, assign) NSTimeInterval transitionDuration;
@end

@implementation LGFModalTransition

+ (instancetype)shardLGFModalTransition {
    static LGFModalTransition *transition;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        transition = [[LGFModalTransition alloc] init];
    });
    return transition;
}

- (void)setLgf_TransitionDuration:(NSTimeInterval)lgf_TransitionDuration {
    _lgf_TransitionDuration = lgf_TransitionDuration;
    _transitionDuration = lgf_TransitionDuration;
}


- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return self.transitionDuration;
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
    
    // 初始化 半透明黑色遮罩
    // Initialization Translucent black mask
    UIView *mask = [[UIView alloc] init];
    mask.backgroundColor = [UIColor blackColor];
    mask.frame = [[UIScreen mainScreen] bounds];
    
    // 判断是 Present 还是 Dismiss 操作
    // Determine if it is a Present or Dismiss operation
    if (self.isPresenting) {
        mask.alpha = 0.0;
        [containerView addSubview:fromView];
        [containerView addSubview:toView];
        [fromView addSubview:mask];
        toView.frame = CGRectMake(0.0,
                                  lgf_ScreenHeight,
                                  lgf_ScreenWidth,
                                  lgf_ScreenHeight);
    } else  {
        mask.alpha = 0.6;
        [containerView addSubview:toView];
        [containerView addSubview:fromView];
        [toView addSubview:mask];
        toView.frame = CGRectMake(0.0,
                                  0.0,
                                  lgf_ScreenWidth,
                                  lgf_ScreenHeight);
    }
    
    // 执行自定义转场动画 改变UI
    // Perform custom transition animations Change UI
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        if (self.isPresenting) {
            mask.alpha = 0.6;
            toView.frame = CGRectMake(toView.frame.origin.x,
                                      0.0,
                                      toView.frame.size.width,
                                      toView.frame.size.height);
        } else {
            mask.alpha = 0.0;
            fromView.frame = CGRectMake(fromView.frame.origin.x,
                                        lgf_ScreenHeight,
                                        fromView.frame.size.width,
                                        fromView.frame.size.height);
        }
    } completion:^(BOOL finished) {
        // 设置 transitionContext 通知系统动画执行完毕
        // Set transitionContext to notify system animation completion
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        // Remove black mask
        [mask removeFromSuperview];
        if (![transitionContext transitionWasCancelled]) {
            self.toVC = toVC;
        } else {
            self.toVC = fromVC;
        }
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
    self.isPresenting = YES;
    return [self interactionControllerForAll];
}

- (nullable id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    self.isPresenting = NO;
    return [self interactionControllerForAll];
}

- (nullable id<UIViewControllerInteractiveTransitioning>)interactionControllerForAll {
    // 判断是否是手势 dismiss
    // Judge whether it is gesture dismiss
    if (self.toVC.lgf_InteractiveTransition) {
        self.transitionDuration = self.lgf_TransitionDuration * 2;
        return self.toVC.lgf_InteractiveTransition;
    }
    self.transitionDuration = self.lgf_TransitionDuration;
    return nil;
}

@end
