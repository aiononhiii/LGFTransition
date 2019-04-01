//
//  LGFShowTransition.h
//  LGF
//
//  Created by apple on 2018/6/13.
//  Copyright © 2018年 来国锋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UINavigationController+LGFAnimatedTransition.h"
#import "UIViewController+LGFAnimatedTransition.h"
#import "LGFTransition.h"

@interface LGFShowTransition : NSObject <UIViewControllerAnimatedTransitioning, UINavigationControllerDelegate>
// 自定义动画的时长
// Custom animation Duration
@property (nonatomic, assign) NSTimeInterval lgf_TransitionDuration;
lgf_AllocOnlyOnceForH(LGFShowTransition);
@end

