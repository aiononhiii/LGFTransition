//
//  LGFTransition.h
//  LGF
//
//  Created by apple on 2017/6/13.
//  Copyright © 2018年 来国锋. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LGFTransition : NSObject <UIViewControllerAnimatedTransitioning,UINavigationControllerDelegate>
// 自定义动画的时间
@property (nonatomic, assign) NSTimeInterval lgf_TransitionDuration;
+ (instancetype)shardLGFTransition;
@end

