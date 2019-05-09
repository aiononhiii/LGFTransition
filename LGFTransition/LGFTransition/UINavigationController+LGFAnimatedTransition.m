//
//  UINavigationController+LGFAnimatedTransition.m
//  LGF
//
//  Created by apple on 2018/6/13.
//  Copyright © 2018年 来国锋. All rights reserved.
//

#import "UINavigationController+LGFAnimatedTransition.h"
#import "LGFShowTransition.h"
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@implementation UINavigationController (LGFAnimatedTransition)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        method_exchangeImplementations(class_getInstanceMethod(class, @selector(popViewControllerAnimated:)), class_getInstanceMethod(class, @selector(lgf_PopViewControllerAnimated:)));
        method_exchangeImplementations(class_getInstanceMethod(class, @selector(pushViewController:animated:)), class_getInstanceMethod(class, @selector(lgf_PushViewController:animated:)));
    });
}

+ (void)lgf_AnimatedTransitionIsUse:(BOOL)isUse {
    [self lgf_AnimatedTransitionIsUse:isUse showDuration:0.5 modalDuration:0.6];
}

+ (void)lgf_AnimatedTransitionIsUse:(BOOL)isUse showDuration:(NSTimeInterval)showDuration modalDuration:(NSTimeInterval)modalDuration {
    if (isUse) {
        [UIViewController lgf_AnimatedTransitionModalDuration:modalDuration];
        if (showDuration <= 0) {
            // 默认 0.5 / defult 0.5
            [LGFShowTransition sharedLGFShowTransition].lgf_TransitionDuration = 0.5;
        } else {
            [LGFShowTransition sharedLGFShowTransition].lgf_TransitionDuration = showDuration;
        }
    }
}

- (void)lgf_PushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    if (animated && [LGFShowTransition sharedLGFShowTransition].lgf_TransitionDuration > 0.0) {
        // 使用自己定义的跳转动画请将 VC 的  lgf_OtherDelegate 赋值
        // Set the lgf_OtherDelegate for your custom transition animation
        if (viewController.lgf_OtherShowDelegate) {
            self.delegate = viewController.lgf_OtherShowDelegate;
        } else {
            self.delegate = [LGFShowTransition sharedLGFShowTransition];
        }
    }
    [self lgf_PushViewController:viewController animated:animated];
}

- (nullable UIViewController *)lgf_PopViewControllerAnimated:(BOOL)animated {
    if (animated && [LGFShowTransition sharedLGFShowTransition].lgf_TransitionDuration > 0.0) {
        // 使用自己定义的跳转动画请将 VC 的 lgf_OtherDelegate 赋值
        // Set the lgf_OtherDelegate for your custom transition animation
        if (self.visibleViewController.lgf_OtherShowDelegate) {
            self.delegate = self.visibleViewController.lgf_OtherShowDelegate;
        } else {
            self.delegate = [LGFShowTransition sharedLGFShowTransition];
        }
    }
    return [self lgf_PopViewControllerAnimated:animated];
}

- (void)lgf_PopToClass:(Class)vcClass vcTag:(int)vcTag Animated:(BOOL)animated completion:(void (^)(UIViewController *lgf_Vc))completion {
    for (UIViewController *vc in self.viewControllers) {
        if ([vc isKindOfClass:vcClass] && vc.view.tag == vcTag) {
            [self popToViewController:vc animated:animated];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(animated ? [LGFShowTransition sharedLGFShowTransition].lgf_TransitionDuration : 0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                if (completion) {
                    completion(vc);
                }
            });
        }
    }
}

@end

NS_ASSUME_NONNULL_END

