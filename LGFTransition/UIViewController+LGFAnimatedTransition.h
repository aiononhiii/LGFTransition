//
//  UIViewController+LGFAnimatedTransition.h
//  LGFAnimatedNavigationDemo
//
//  Created by apple on 2018/6/22.
//  Copyright © 2018年 来国锋. All rights reserved.
//

#import <UIKit/UIKit.h>

#undef lgf_ScreenWidth
#define lgf_ScreenWidth [[UIScreen mainScreen] bounds].size.width
#undef lgf_ScreenHeight
#define lgf_ScreenHeight [[UIScreen mainScreen] bounds].size.height
#undef lgf_AllocOnlyOnceForH
#define lgf_AllocOnlyOnceForH(methodName) + (instancetype)shared##methodName
#undef lgf_AllocOnlyOnceForM
#define lgf_AllocOnlyOnceForM(name,methodName) static name* _instance;\
+ (instancetype)allocWithZone:(struct _NSZone *)zone\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [super allocWithZone:zone];\
});\
return _instance;\
}\
\
+ (instancetype)shared##methodName{\
\
return [[name alloc] init];\
}\
- (instancetype)init{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [super init];\
});\
return _instance;\
}\
\
- (instancetype)copyWithZone:(NSZone *)zone\
{\
return _instance;\
}\
- (instancetype)mutableCopyWithZone:(NSZone *)zone\
{\
return _instance;\
}

typedef NS_ENUM(NSUInteger, lgf_PanType) {
    lgf_PopPan,
    lgf_DismissPan,
};

UIKIT_EXTERN NSString *const lgf_InteractiveTransitionKey;
UIKIT_EXTERN NSString *const lgf_IsUseLGFAnimatedTransitionKey;

@interface UIViewController (LGFAnimatedTransition) <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIPercentDrivenInteractiveTransition *lgf_InteractiveTransition;
@property (nonatomic, assign) lgf_PanType lgf_PanType;
#pragma mark - 添加拖动手势 / Add the UIPanGestureRecognizer
- (void)lgf_AddPopPan:(lgf_PanType)panType;
#pragma mark - 是否使用了自定义的转场动画 / Whether to use a custom transition animation
/**
 @param modalDuration Modal转场动画时长 / Animation duration
 */
+ (void)lgf_AnimatedTransitionModalDuration:(NSTimeInterval)modalDuration;
@end
