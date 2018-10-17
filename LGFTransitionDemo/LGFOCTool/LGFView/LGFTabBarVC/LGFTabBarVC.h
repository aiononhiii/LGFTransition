//
//  LGFTabBarVC.h
//  LGFAnimatedNavigationDemo
//
//  Created by apple on 2018/6/29.
//  Copyright © 2018年 来国锋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGFOCTool.h"

static NSString *const LGFTabBarDoubleSelect = @"LGFTabBarDoubleSelectNotification";

@interface LGFTabBarVC : UIViewController
@property (nonatomic, copy) NSArray *lgf_BarChildVCs;
@property (nonatomic, copy) NSArray *lgf_BarItemTitles;
@property (nonatomic, copy) NSArray *lgf_SelectBarItemIcons;
@property (nonatomic, copy) NSArray *lgf_UnSelectBarItemIcons;
@property (nonatomic, strong) UIColor *lgf_SelectBarItemColor;
@property (nonatomic, strong) UIColor *lgf_UnSelectBarItemColor;
@property (nonatomic, assign) NSInteger lgf_DefultSelectIndex;
@property (weak, nonatomic) IBOutlet UICollectionView *lgf_ChildVCCV;
@property (weak, nonatomic) IBOutlet UICollectionView *lgf_BarItemCV;
@property (weak, nonatomic) IBOutlet UIView *lgf_TabBarView;
@property (weak, nonatomic) IBOutlet UIView *lgf_TabBarBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lgf_TabBarBackViewHeight;
@property (weak, nonatomic) IBOutlet UIView *lgf_ShadowView;
- (void)lgf_TabBarVCShowInView:(UIViewController *)vc;
- (UIButton *)lgf_TabBarShowCenterBtnWithTop:(CGFloat)top size:(CGSize)size;
- (void)lgf_ShowTabBar;
- (void)lgf_HideTabBar;
lgf_SBViewControllerForH;
@end

@interface lgf_BarCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *lgf_BarIcon;
@property (weak, nonatomic) IBOutlet UILabel *lgf_Bartitle;
@end
