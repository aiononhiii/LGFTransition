//
//  LGFTabBar.h
//  LGFAnimatedNavigationDemo
//
//  Created by apple on 2019/4/1.
//  Copyright © 2019年 来国锋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGFTransition.h"
#import "LGFTabBarVC.h"

NS_ASSUME_NONNULL_BEGIN

@interface LGFTabBar : UIViewController
// 以下两个属性仅仅用于外部取值
@property (strong, nonatomic) UIViewController *selectVC;
@property (nonatomic, strong) LGFTabBarVC *tabvc;
lgf_SBViewControllerForH;
@end

NS_ASSUME_NONNULL_END
