//
//  UINavigationController+LGFAnimatedTransition.h
//  LGF
//
//  Created by apple on 2018/6/13.
//  Copyright © 2018年 来国锋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+LGFAnimatedTransition.h"
#import "LGFTabBarVC.h"
#import "LGFNavigationBar.h"

@interface UINavigationController (LGFAnimatedTransition)
#pragma mark - 是否使用自定义的转场动画 / Whether to use a custom transition animation
+ (void)lgf_AnimatedTransitionIsUse:(BOOL)isUse;
/**
 @param isUse 是否使用自定义的转场动画 / Whether to use a custom transition animation
 @param showDuration Show转场动画时长 / Animation duration
 @param modalDuration Modal转场动画时长 / Animation duration
 */
+ (void)lgf_AnimatedTransitionIsUse:(BOOL)isUse showDuration:(NSTimeInterval)showDuration modalDuration:(NSTimeInterval)modalDuration;
#pragma mark - pop 到指定 vc class
/**
 @param vcClass class
 @param vcTag 用于区分相同class下的多个vc
 @param animated 是否动画
 */
- (void)lgf_PopToClass:(Class)vcClass vcTag:(int)vcTag Animated:(BOOL)animated completion:(void (^)(UIViewController *lgf_Vc))completion;
@end


