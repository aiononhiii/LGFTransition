//
//  LGFModalTransition.h
//  LGFAnimatedNavigationDemo
//
//  Created by apple on 2018/6/22.
//  Copyright © 2018年 来国锋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIViewController+LGFAnimatedTransition.h"

@interface LGFModalTransition : NSObject <UIViewControllerAnimatedTransitioning, UIViewControllerTransitioningDelegate>
// 自定义动画的时长
// Custom animation Duration
@property (nonatomic, assign) NSTimeInterval lgf_TransitionDuration;
lgf_AllocOnlyOnceForH(LGFModalTransition);
@end
