//
//  LGFTabBarVC.h
//  LGFAnimatedNavigationDemo
//
//  Created by apple on 2018/6/29.
//  Copyright © 2018年 来国锋. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGFTransition.h"

static NSString *const LGFTabBarDoubleSelect = @"LGFTabBarDoubleSelectNotification";

@interface LGFTabBarVC : UIViewController
typedef BOOL(^lgf_ShouldSelectItemAtIndexPath)(NSIndexPath *indexPath);
typedef void(^lgf_SelectVC)(UIViewController *vc);
typedef void(^lgf_CenterBtnSelect)(UIButton *sender);
@property (nonatomic, copy) NSArray <UIViewController *> *lgf_BarChildVCs;
@property (nonatomic, copy) NSArray *lgf_BarItemTitles;
@property (assign, nonatomic) BOOL lgf_IsNetImage;
@property (nonatomic, strong) NSMutableArray *lgf_SelectBarItemIcons;
@property (nonatomic, strong) NSMutableArray *lgf_UnSelectBarItemIcons;
@property (nonatomic, strong) UIColor *lgf_SelectBarItemColor;
@property (nonatomic, strong) UIColor *lgf_UnSelectBarItemColor;
@property (nonatomic, assign) NSInteger lgf_DefultSelectIndex;
@property (weak, nonatomic) IBOutlet UICollectionView *lgf_ChildVCCV;
@property (weak, nonatomic) IBOutlet UICollectionView *lgf_BarItemCV;
@property (weak, nonatomic) IBOutlet UIView *lgf_TabBarBackView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lgf_TabBarBackViewHeight;
@property (weak, nonatomic) IBOutlet UIImageView *lgf_TabBarBackImageView;
// 要修改毛玻璃的显示效果改变这个 view 的背景色透明度就行
@property (weak, nonatomic) IBOutlet UIView *lgf_VisualView;
@property (assign, nonatomic) BOOL lgf_IsHaveCenterButton;
@property (copy, nonatomic) lgf_ShouldSelectItemAtIndexPath shouldSelectItemAtIndexPath;
@property (copy, nonatomic) lgf_SelectVC selectVC;
@property (copy, nonatomic) lgf_CenterBtnSelect centerBtnSelect;
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
