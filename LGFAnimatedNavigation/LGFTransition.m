//
//  LGFTransition.m
//  LGF
//
//  Created by apple on 2017/6/13.
//  Copyright © 2018年 来国锋. All rights reserved.
//

#import "LGFTransition.h"
#import "UINavigationController+LGFAnimatedTransition.h"
#import <objc/runtime.h>

#undef lgf_ScreenWidth
#define lgf_ScreenWidth [[UIScreen mainScreen] bounds].size.width
#undef lgf_ScreenHeight
#define lgf_ScreenHeight [[UIScreen mainScreen] bounds].size.height

@interface LGFTransition()
// Push 过去的 ViewController
@property(strong,nonatomic) UIViewController *toVC;
// 自定义动画的时间
@property (nonatomic, assign) NSTimeInterval transitionDuration;
@end

@implementation LGFTransition

+ (instancetype)shardLGFTransition {
    static LGFTransition *transition;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        transition = [[LGFTransition alloc] init];
    });
    return transition;
}

- (void)setLgf_TransitionDuration:(NSTimeInterval)lgf_TransitionDuration {
    _lgf_TransitionDuration = lgf_TransitionDuration;
    _transitionDuration = _lgf_TransitionDuration;
}

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return self.transitionDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    //转场过渡的容器view  -- UINavigationTransitionView
    UIView *containerView = [transitionContext containerView];

    // Push 前的 ViewController
    UIViewController *fromVC = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromView = fromVC.view;
    // Push 后的 ViewController
    UIViewController *toVC = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toVC.view;

    // 初始化 半透明黑色遮罩
    UIView *mask = [[UIView alloc] init];
    mask.backgroundColor = [UIColor blackColor];
    mask.frame = [[UIScreen mainScreen] bounds];

    //此处判断是push，还是pop 操作
    BOOL isPush = ([toVC.navigationController.viewControllers indexOfObject:toVC] > [fromVC.navigationController.viewControllers indexOfObject:fromVC]);

    // 判断是 Push 还是 Pop
    if (isPush) {
        mask.alpha = 0.0;
        [containerView addSubview:fromView];
        [containerView addSubview:toView];
        [fromView addSubview:mask];
        toView.frame = CGRectMake(lgf_ScreenWidth,
                                  0.0,
                                  lgf_ScreenWidth,
                                  lgf_ScreenHeight);
    } else {
        mask.alpha = 0.6;
        [containerView addSubview:toView];
        [containerView addSubview:fromView];
        [toView addSubview:mask];
        toView.frame = CGRectMake(-(lgf_ScreenWidth / 2),
                                  0.0,
                                  lgf_ScreenWidth,
                                  lgf_ScreenHeight);
    }

    // 执行转场动画 改变UI
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        if (isPush) {
            mask.alpha = 0.6;
            fromView.frame = CGRectMake(-(lgf_ScreenWidth / 2),
                                        fromView.frame.origin.y,
                                        lgf_ScreenWidth,
                                        fromView.frame.size.height);
            toView.frame = CGRectMake(0.0,
                                      toView.frame.origin.y,
                                      lgf_ScreenWidth,
                                      fromView.frame.size.height);
        } else {
            mask.alpha = 0.0;
            toView.frame = CGRectMake(0.0,
                                      toView.frame.origin.y,
                                      lgf_ScreenWidth,
                                      fromView.frame.size.height);
            fromView.frame = CGRectMake(lgf_ScreenWidth,
                                        fromView.frame.origin.y,
                                        lgf_ScreenWidth,
                                        fromView.frame.size.height);
        }
    } completion:^(BOOL finished) {
        // 设置 transitionContext 通知系统动画执行完毕
        [transitionContext completeTransition:![transitionContext transitionWasCancelled]];
        // 删除黑色遮罩
        [mask removeFromSuperview];
        // 给 toVC 添加手势
        self.toVC = toVC.navigationController.topViewController;
        [self.toVC lgf_AddUIScreenEdgePan];
    }];
}

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC {
    return self;
}

- (id <UIViewControllerInteractiveTransitioning>)navigationController:(UINavigationController *)navigationController
                          interactionControllerForAnimationController:(id <UIViewControllerAnimatedTransitioning>)animationController {
    // 判断是否是手势返回
    if (self.toVC.lgf_InteractivePopTransition) {
        self.transitionDuration = self.lgf_TransitionDuration * 2;
        return self.toVC.lgf_InteractivePopTransition;
    }
    self.transitionDuration = self.lgf_TransitionDuration;
    return nil;
}

-(void)dealloc{
    NSLog(@"tra dealloc");
}



@end
