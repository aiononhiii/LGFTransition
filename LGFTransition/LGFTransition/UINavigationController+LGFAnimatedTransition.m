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
        lgf_NavMethod_swizzle(class, @selector(popViewControllerAnimated:), @selector(lgf_PopViewControllerAnimated:));
        lgf_NavMethod_swizzle(class, @selector(pushViewController:animated:), @selector(lgf_PushViewController:animated:));
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
    if (animated) {
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
    if (animated) {
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

BOOL lgf_NavMethod_swizzle(Class klass, SEL origSel, SEL altSel) {
    if (!klass) return NO;
    Method __block origMethod, __block altMethod;
    void (^find_methods)(void) = ^{
        unsigned methodCount = 0;
        Method *methodList = class_copyMethodList(klass, &methodCount);
        origMethod = altMethod = NULL;
        if (methodList)
            for (unsigned i = 0; i < methodCount; ++i) {
                if (method_getName(methodList[i]) == origSel)
                    origMethod = methodList[i];
                if (method_getName(methodList[i]) == altSel)
                    altMethod = methodList[i];
            }
        free(methodList);
    };
    find_methods();
    if (!origMethod) {
        origMethod = class_getInstanceMethod(klass, origSel);
        if (!origMethod) return NO;
        if (!class_addMethod(klass, method_getName(origMethod), method_getImplementation(origMethod), method_getTypeEncoding(origMethod))) return NO;
    }
    if (!altMethod) {
        altMethod = class_getInstanceMethod(klass, altSel);
        if (!altMethod) return NO;
        if (!class_addMethod(klass, method_getName(altMethod), method_getImplementation(altMethod), method_getTypeEncoding(altMethod))) return NO;
    }
    find_methods();
    if (!origMethod || !altMethod) return NO;
    method_exchangeImplementations(origMethod, altMethod);
    return YES;
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

