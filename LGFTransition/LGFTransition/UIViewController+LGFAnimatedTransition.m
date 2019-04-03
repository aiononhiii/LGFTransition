//
//  UIViewController+LGFAnimatedTransition.m
//  LGFAnimatedNavigationDemo
//
//  Created by apple on 2018/6/22.
//  Copyright © 2018年 来国锋. All rights reserved.
//

#import "UIViewController+LGFAnimatedTransition.h"
#import "LGFModalTransition.h"
#import <objc/runtime.h>

NSString *const lgf_InteractiveTransitionKey = @"lgf_InteractiveTransitionKey";
NSString *const lgf_IsUseLGFAnimatedTransitionKey = @"lgf_IsUseLGFAnimatedTransitionKey";
NSString *const lgf_IsShowNaviVCKey = @"lgf_IsShowNaviVCKey";
NSString *const lgf_OtherShowDelegateKey = @"lgf_OtherShowDelegateKey";
NSString *const lgf_OtherModalDelegateKey = @"lgf_OtherModalDelegateKey";

@implementation UIViewController (LGFAnimatedTransition)
@dynamic lgf_InteractiveTransition;
@dynamic lgf_PanType;
@dynamic lgf_IsShowNaviVC;
@dynamic lgf_OtherShowDelegate;
@dynamic lgf_OtherModalDelegate;

- (id<UINavigationControllerDelegate>)lgf_OtherShowDelegate {
    return objc_getAssociatedObject(self,
                                    &lgf_OtherShowDelegateKey);
}

- (void)setLgf_OtherShowDelegate:(id<UINavigationControllerDelegate>)lgf_OtherShowDelegate {
    objc_setAssociatedObject(self,
                             &lgf_OtherShowDelegateKey,
                             lgf_OtherShowDelegate,
                             OBJC_ASSOCIATION_ASSIGN);
}

- (id<UIViewControllerTransitioningDelegate>)lgf_OtherModalDelegate {
    return objc_getAssociatedObject(self,
                                    &lgf_OtherModalDelegateKey);
}

- (void)setLgf_OtherModalDelegate:(id<UIViewControllerTransitioningDelegate>)lgf_OtherModalDelegate {
    objc_setAssociatedObject(self,
                             &lgf_OtherModalDelegateKey,
                             lgf_OtherModalDelegate,
                             OBJC_ASSOCIATION_ASSIGN);
}

- (void)setLgf_InteractiveTransition:(UIPercentDrivenInteractiveTransition *)lgf_InteractiveTransition {
    objc_setAssociatedObject(self,
                             &lgf_InteractiveTransitionKey,
                             lgf_InteractiveTransition,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIPercentDrivenInteractiveTransition *)lgf_InteractiveTransition {
    return objc_getAssociatedObject(self,
                                    &lgf_InteractiveTransitionKey);
}

- (void)setLgf_PanType:(lgf_PanType)lgf_PanType {
    objc_setAssociatedObject(self,
                             &lgf_IsUseLGFAnimatedTransitionKey,
                             [NSNumber numberWithInt:lgf_PanType],
                             OBJC_ASSOCIATION_ASSIGN);
}

- (lgf_PanType)lgf_PanType {
    return [objc_getAssociatedObject(self,
                                     &lgf_IsUseLGFAnimatedTransitionKey) integerValue];
}

- (void)setLgf_IsShowNaviVC:(BOOL)lgf_IsShowNaviVC {
    objc_setAssociatedObject(self, &lgf_IsShowNaviVCKey, @(lgf_IsShowNaviVC), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)lgf_IsShowNaviVC {
    return [objc_getAssociatedObject(self, &lgf_IsShowNaviVCKey) boolValue];
}

+ (void)lgf_AnimatedTransitionModalDuration:(NSTimeInterval)modalDuration {
    if (modalDuration <= 0) {
        // 默认 0.6 / defult 0.6
        [LGFModalTransition sharedLGFModalTransition].lgf_TransitionDuration = 0.6;
    } else {
        [LGFModalTransition sharedLGFModalTransition].lgf_TransitionDuration = modalDuration;
    }
    // 如果使用自定义转场动画，那么隐藏所有navigationBar，全部使用自定义，手动添加的返回按钮直接继承我的 LGFBackButton 就可以自动 pop 了
    // If you use a custom transition animation, then hide all navigationBar, all use the custom, manually add the return button directly inherited my LGFBackButton can automatically pop up
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(viewWillAppear:)), class_getInstanceMethod([self class], @selector(lgf_AnimatedTransitionViewWillAppear:)));
    // 在模态跳转中也同样使用自定义动画时长
    // Same custom animation duration in modal
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(presentViewController:animated:completion:)), class_getInstanceMethod([self class], @selector(lgf_PresentViewController:animated:completion:)));
    method_exchangeImplementations(class_getInstanceMethod([self class], @selector(dismissViewControllerAnimated:completion:)), class_getInstanceMethod([self class], @selector(lgf_DismissViewControllerAnimated:completion:)));
}

- (void)lgf_PresentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion {
    // 确保 modalPresentationStyle 是 UIModalPresentationFullScreen 才使用 LGFModalTransition 自定义动画, 使其不影响系统其他的 Present, 比如 UIAlertViewController
    // Make sure modalPresentationStyle is UIModalPresentationFullScreen to use LGFModalTransition custom animation so that it does not affect other Present of the system, such as UIAlertViewController
    if (viewControllerToPresent.modalPresentationStyle == UIModalPresentationFullScreen && flag) {
        if (viewControllerToPresent.lgf_OtherModalDelegate) {
            viewControllerToPresent.transitioningDelegate = viewControllerToPresent.lgf_OtherModalDelegate;
        } else {
            viewControllerToPresent.transitioningDelegate = [LGFModalTransition sharedLGFModalTransition];
        }
    }
    [self lgf_PresentViewController:viewControllerToPresent animated:flag completion:completion];
}

- (void)lgf_DismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    // 确保是 UIModalPresentationFullScreen 才使用这个自定义动画，使其不影响系统其他的 Dismiss 比如 UIAlertViewController
    // Make sure modalPresentationStyle is UIModalPresentationFullScreen to use LGFModalTransition custom animation so that it does not affect other Dismiss of the system, such as UIAlertViewController
    if (self.modalPresentationStyle == UIModalPresentationFullScreen && flag) {
        if (self.lgf_OtherModalDelegate) {
            self.transitioningDelegate = self.lgf_OtherModalDelegate;
        } else {
            self.transitioningDelegate = [LGFModalTransition sharedLGFModalTransition];
        }
    }
    [self lgf_DismissViewControllerAnimated:flag completion:completion];
}

- (void)lgf_AnimatedTransitionViewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:!self.lgf_IsShowNaviVC];
    [self lgf_AnimatedTransitionViewWillAppear:animated];
}

- (void)lgf_AddPopPan:(lgf_PanType)panType {
    // 添加左侧边缘拖动手势
    // Add the left UIScreenEdgePanGestureRecognizer
    [self.view.gestureRecognizers enumerateObjectsUsingBlock:^(__kindof UIGestureRecognizer * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.view removeGestureRecognizer:obj];
    }];
    __block UIScreenEdgePanGestureRecognizer *recognizer = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(lgf_ScreenEdgePanGestureRecognizer:)];
    recognizer.edges = UIRectEdgeLeft;
    [self.view addGestureRecognizer:recognizer];
    self.lgf_PanType = panType;
    
    [self.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([view isKindOfClass:[UICollectionView class]]) {
            if (view.tag == 333333) {
                UICollectionView *cv = (UICollectionView *)view;
                [cv.panGestureRecognizer requireGestureRecognizerToFail:recognizer];
            }
        }
    }];
    [self requireG:self block:^(UIPanGestureRecognizer *pan) {
        [pan requireGestureRecognizerToFail:recognizer];
    }];
}

- (void)requireG:(UIViewController *)vc block:(void(^)(UIPanGestureRecognizer *pan))block {
    [vc.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull cvc, NSUInteger idx, BOOL * _Nonnull stop) {
        [cvc.view.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull view, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([view isKindOfClass:[UICollectionView class]]) {
                if (view.tag == 333333) {
                    UICollectionView *cv = (UICollectionView *)view;
                    if (block) block(cv.panGestureRecognizer);
                }
            }
        }];
        [self requireG:cvc block:block];
    }];
}

- (void)lgf_ScreenEdgePanGestureRecognizer:(UIScreenEdgePanGestureRecognizer *)recognizer {
    dispatch_async(dispatch_get_main_queue(), ^{
        // 计算拖过视图的距离
        // Calculate the distance dragged over the view
        CGFloat progress = [recognizer translationInView:[UIApplication sharedApplication].keyWindow].x / lgf_ScreenWidth;
        progress = MIN(1.0, MAX(0.0, progress));
        if (recognizer.state == UIGestureRecognizerStateBegan) {
            // 创建并开始一个转场交互
            // Create and start a transition interaction
            self.lgf_InteractiveTransition = [[UIPercentDrivenInteractiveTransition alloc] init];
            // 这句很重要，最好和 [animateTransition:] 方法里的动画 options 保持一致
            // This sentence is very important, preferably in line with the animation options in the [animateTransition:] method
            self.lgf_InteractiveTransition.completionCurve = UIViewAnimationCurveEaseInOut;
            if (self.lgf_PanType == lgf_PopPan) {
                [self.navigationController popViewControllerAnimated:YES];
            } else {
                [self dismissViewControllerAnimated:YES completion:nil];
            }
        } else if (recognizer.state == UIGestureRecognizerStateChanged) {
            // 更新转场交互进度
            // Update transition progress
            [self.lgf_InteractiveTransition updateInteractiveTransition:progress];
        } else {
            // 如果滑动范围大于 40％ 则交互完成，否则交互取消
            // If the sliding range is greater than 40％, the interaction finish, else, the interaction cancel
            if (progress > 0.4) {
                [self.lgf_InteractiveTransition finishInteractiveTransition];
            } else {
                [self.lgf_InteractiveTransition cancelInteractiveTransition];
            }
            self.lgf_InteractiveTransition = nil;
        }
    });
}

@end

