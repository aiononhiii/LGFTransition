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

@implementation UIViewController (LGFAnimatedTransition)
@dynamic lgf_InteractiveTransition;
@dynamic lgf_PanType;

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
    if (viewControllerToPresent.modalPresentationStyle == UIModalPresentationFullScreen) {
        viewControllerToPresent.transitioningDelegate = [LGFModalTransition sharedLGFModalTransition];
    }
    [self lgf_PresentViewController:viewControllerToPresent animated:YES completion:completion];
}

- (void)lgf_DismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion {
    // 确保是 UIModalPresentationFullScreen 才使用这个自定义动画，使其不影响系统其他的 Dismiss 比如 UIAlertViewController
    // Make sure modalPresentationStyle is UIModalPresentationFullScreen to use LGFModalTransition custom animation so that it does not affect other Dismiss of the system, such as UIAlertViewController
    if (self.modalPresentationStyle == UIModalPresentationFullScreen) {
        self.transitioningDelegate = [LGFModalTransition sharedLGFModalTransition];
    }
    [self lgf_DismissViewControllerAnimated:YES completion:completion];
}

- (void)lgf_AnimatedTransitionViewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)lgf_AddPopPan:(lgf_PanType)panType {
    // 添加左侧边缘拖动手势
    // Add the left UIScreenEdgePanGestureRecognizer
    UIPanGestureRecognizer *recognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(lgf_GestureRecognizer:)];
    [self.view addGestureRecognizer:recognizer];
    self.lgf_PanType = panType;
}

- (void)lgf_GestureRecognizer:(UIPanGestureRecognizer *)recognizer {
    // 计算拖过视图的距离
    // Calculate the distance dragged over the view
    CGFloat progress = self.lgf_PanType == lgf_PopPan ? [recognizer translationInView:self.view].x / self.view.bounds.size.width : [recognizer translationInView:self.view].y / self.view.bounds.size.height;
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
        // 如果滑动范围大于 40％(Pop) / 20%(Dismiss)，则交互完成，否则交互取消
        // If the sliding range is greater than 40％(Pop) / 20%(Dismiss), the interaction finish, else, the interaction cancel
        if (progress > (self.lgf_PanType == lgf_PopPan ? 0.4 : 0.2)) {
            [self.lgf_InteractiveTransition finishInteractiveTransition];
        } else {
            [self.lgf_InteractiveTransition cancelInteractiveTransition];
        }
        self.lgf_InteractiveTransition = nil;
    }
}

@end
