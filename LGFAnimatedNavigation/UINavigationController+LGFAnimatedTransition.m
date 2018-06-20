//
//  UINavigationController+LGFAnimatedTransition.m
//  LGF
//
//  Created by apple on 2017/6/13.
//  Copyright © 2018年 来国锋. All rights reserved.
//

#import "UINavigationController+LGFAnimatedTransition.h"
#import "LGFTransition.h"
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@implementation UINavigationController (LGFAnimatedTransition)

+ (void)lgf_AnimatedTransitionIsUse:(BOOL)isUse {
    [self lgf_AnimatedTransitionIsUse:isUse transitionDuration:0];
}

+ (void)lgf_AnimatedTransitionIsUse:(BOOL)isUse transitionDuration:(NSTimeInterval)transitionDuration {
    [UIViewController lgf_AnimatedTransitionIsUse:isUse];
    if (isUse) {
        if (!transitionDuration || transitionDuration == 0) {
            [LGFTransition shardLGFTransition].lgf_TransitionDuration = 0.5;
        } else {
            [LGFTransition shardLGFTransition].lgf_TransitionDuration = transitionDuration;
        }
        // 是否使用自定义转场动画
        // Whether to use a custom transition animation
        method_exchangeImplementations(class_getInstanceMethod([self class], @selector(popViewControllerAnimated:)), class_getInstanceMethod([self class], @selector(lgf_PopViewControllerAnimated:)));
        method_exchangeImplementations(class_getInstanceMethod([self class], @selector(pushViewController:animated:)), class_getInstanceMethod([self class], @selector(lgf_PushViewController:animated:)));
    }
}

- (void)lgf_PushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.delegate = [LGFTransition shardLGFTransition];
    [self lgf_PushViewController:viewController animated:YES];
}

- (nullable UIViewController *)lgf_PopViewControllerAnimated:(BOOL)animated {
    self.delegate = [LGFTransition shardLGFTransition];
    return [self lgf_PopViewControllerAnimated:YES];
}

@end

NSString *const lgf_InteractivePopTransitionKey = @"lgf_InteractivePopTransitionKey";

@implementation UIViewController (LGFAnimatedTransition)

+ (void)lgf_AnimatedTransitionIsUse:(BOOL)isUse {
    if (isUse) {
        // 如果使用自定义转场动画，那么隐藏所有navigationBar，全部使用自定义，手动添加的返回按钮直接继承我的 LGFNavigationBackButton 就可以自动 pop 了
        // If you use a custom transition animation, then hide all navigationBar, all use the custom, manually add the return button directly inherited my LGFNavigationBackButton can automatically pop up
        method_exchangeImplementations(class_getInstanceMethod([self class], @selector(viewWillDisappear:)), class_getInstanceMethod([self class], @selector(lgf_AnimatedTransitionViewWillDisappear:)));
        method_exchangeImplementations(class_getInstanceMethod([self class], @selector(viewWillAppear:)), class_getInstanceMethod([self class], @selector(lgf_AnimatedTransitionViewWillAppear:)));
    }
}

- (void)setLgf_InteractivePopTransition:(UIPercentDrivenInteractiveTransition *)lgf_InteractivePopTransition {
    objc_setAssociatedObject(self,
                             &lgf_InteractivePopTransitionKey,
                             lgf_InteractivePopTransition,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIPercentDrivenInteractiveTransition *)lgf_InteractivePopTransition {
    return objc_getAssociatedObject(self,
                                    &lgf_InteractivePopTransitionKey);
}

- (void)lgf_AnimatedTransitionViewWillDisappear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)lgf_AnimatedTransitionViewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)lgf_AddUIScreenEdgePan {
    // 添加左侧边缘拖动手势
    // Add the left UIScreenEdgePanGestureRecognizer
    UIScreenEdgePanGestureRecognizer *popRecognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(lgf_PopGestureRecognizer:)];
    popRecognizer.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:popRecognizer];
}

- (void)lgf_PopGestureRecognizer:(UIScreenEdgePanGestureRecognizer *)recognizer {
    // 计算拖过视图的距离
    // Calculate the distance dragged over the view
    CGFloat progress = [recognizer translationInView:self.view].x / (self.view.bounds.size.width * 1.0);
    progress = MIN(1.0, MAX(0.0, progress));
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        // 创建并开始一个转场交互
        // Create and start a transition interaction
        self.lgf_InteractivePopTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
        [self.navigationController popViewControllerAnimated:YES];
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        // 更新转场交互进度
        // Update transition progress
        [self.lgf_InteractivePopTransition updateInteractiveTransition:progress];
    } else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        // 如果滑动范围大于40％，则交互完成，否则交互取消
        // If the sliding range is greater than 40%, the interaction finish, else, the interaction cancel
        if (progress > 0.4) {
            [self.lgf_InteractivePopTransition finishInteractiveTransition];
        } else {
            [self.lgf_InteractivePopTransition cancelInteractiveTransition];
        }
        self.lgf_InteractivePopTransition = nil;
    }
}

@end

NS_ASSUME_NONNULL_END

