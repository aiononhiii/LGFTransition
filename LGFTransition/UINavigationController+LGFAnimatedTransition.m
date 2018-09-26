//
//  UINavigationController+LGFAnimatedTransition.m
//  LGF
//
//  Created by apple on 2018/6/13.
//  Copyright © 2018年 来国锋. All rights reserved.
//

#import "UINavigationController+LGFAnimatedTransition.h"
#import "UIViewController+LGFAnimatedTransition.h"
#import "LGFShowTransition.h"
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN

@implementation UINavigationController (LGFAnimatedTransition)

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
        // 是否使用自定义转场动画
        // Whether to use a custom transition animation
        method_exchangeImplementations(class_getInstanceMethod([self class], @selector(popViewControllerAnimated:)), class_getInstanceMethod([self class], @selector(lgf_PopViewControllerAnimated:)));
        method_exchangeImplementations(class_getInstanceMethod([self class], @selector(pushViewController:animated:)), class_getInstanceMethod([self class], @selector(lgf_PushViewController:animated:)));
    }
}

- (void)lgf_PushViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.delegate = [LGFShowTransition sharedLGFShowTransition];
    [self lgf_PushViewController:viewController animated:YES];
}

- (nullable UIViewController *)lgf_PopViewControllerAnimated:(BOOL)animated {
    self.delegate = [LGFShowTransition sharedLGFShowTransition];
    return [self lgf_PopViewControllerAnimated:YES];
}

@end

NS_ASSUME_NONNULL_END

