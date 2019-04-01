//
//  LGFTabBarVC.m
//  LGFAnimatedNavigationDemo
//
//  Created by apple on 2018/6/29.
//  Copyright © 2018年 来国锋. All rights reserved.
//

#import "LGFTabBarVC.h"
#import "UIImageView+WebCache.h"

@interface LGFTabBarVC () <UINavigationControllerDelegate>

@end

@implementation LGFTabBarVC

lgf_SBViewControllerForM(LGFTabBarVC, @"LGFTabBarVC", @"LGFTransition");

- (void)viewDidLoad {
    [super viewDidLoad];
    if (@available(iOS 11.0, *)) {
        self.lgf_ChildVCCV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.lgf_BarItemCV.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
    self.lgf_TabBarBackView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.lgf_TabBarBackView.layer.shadowRadius = 4.0;
    self.lgf_TabBarBackView.layer.shadowOpacity = 0.03;
}

- (void)lgf_TabBarVCShowInView:(UIViewController *)vc {
    [self.lgf_BarChildVCs enumerateObjectsUsingBlock:^(UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self addChildViewController:obj];
        [obj didMoveToParentViewController:self];
    }];
    [vc addChildViewController:self];
    self.view.frame = lgf_MainScreen;
    [vc.view addSubview:self.view];
    [self didMoveToParentViewController:vc];
}

- (void)setLgf_DefultSelectIndex:(NSInteger)lgf_DefultSelectIndex {
    _lgf_DefultSelectIndex = lgf_DefultSelectIndex;
    [self.lgf_BarItemCV reloadData];
}

- (UIButton *)lgf_TabBarShowCenterBtnWithTop:(CGFloat)top size:(CGSize)size {
    self.lgf_IsHaveCenterButton = YES;
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.adjustsImageWhenHighlighted = NO;
    if (top < 0) {
        self.lgf_TabBarBackViewHeight.constant = 49 + 3 + ABS(top);
    } else {
        self.lgf_TabBarBackViewHeight.constant = 49 + 3;
    }
    btn.frame = CGRectMake((lgf_ScreenWidth / 2) - (size.width / 2), top < 0 ? 0 : top, size.width, size.height);
    [btn addTarget:self action:@selector(lgf_SelectCenterButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.lgf_TabBarBackView addSubview:btn];
    return btn;
}

- (void)lgf_SelectCenterButton:(UIButton *)sender {
    lgf_HaveBlock(self.centerBtnSelect, sender);
}

- (void)lgf_ShowTabBar {
    if (self.lgf_TabBarBackView.transform.ty == self.lgf_TabBarBackViewHeight.constant + 10) {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.lgf_TabBarBackView.transform = CGAffineTransformIdentity;
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)lgf_HideTabBar {
    if (CGAffineTransformEqualToTransform(self.lgf_TabBarBackView.transform, CGAffineTransformIdentity)) {
        [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.lgf_TabBarBackView.transform = CGAffineTransformMakeTranslation(0.0, self.lgf_TabBarBackViewHeight.constant + 10);
        } completion:^(BOOL finished) {
        }];
    }
}

#pragma mark - Collection View DataSource And Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == self.lgf_ChildVCCV) {
        return self.lgf_BarChildVCs.count;
    }
    if (self.lgf_BarItemTitles.count < self.lgf_BarChildVCs.count || self.lgf_SelectBarItemIcons.count < self.lgf_BarChildVCs.count || self.lgf_UnSelectBarItemIcons.count < self.lgf_BarChildVCs.count) {
        return 0;
    }
    return self.lgf_BarItemTitles.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.lgf_ChildVCCV) {
        return CGSizeMake(lgf_ScreenWidth, lgf_ScreenHeight - (lgf_IPhoneXSR ? 34 : 0.0));
    }
    return CGSizeMake(lgf_ScreenWidth / self.lgf_BarItemTitles.count, self.lgf_BarItemCV.frame.size.height);
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.lgf_ChildVCCV) {
        UICollectionViewCell *cell = lgf_CVGetCell(collectionView, UICollectionViewCell, indexPath);
        [cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        UIViewController *vc = self.lgf_BarChildVCs[indexPath.item];
        vc.view.frame = cell.bounds;
        [cell addSubview:vc.view];
        return cell;
    }
    lgf_BarCell *cell = lgf_CVGetCell(collectionView, lgf_BarCell, indexPath);
    cell.hidden = [self.lgf_SelectBarItemIcons[indexPath.item] isEqualToString:@""];
    cell.lgf_Bartitle.text = self.lgf_BarItemTitles[indexPath.item];
    cell.lgf_BarIcon.transform = CGAffineTransformIdentity;
    if (indexPath.item == self.lgf_DefultSelectIndex) {
        cell.lgf_Bartitle.textColor = self.lgf_SelectBarItemColor;
        if (self.lgf_IsNetImage) {
            lgf_SDImage(cell.lgf_BarIcon, self.lgf_SelectBarItemIcons[indexPath.item]);
        } else {
            cell.lgf_BarIcon.image = [UIImage imageNamed:self.lgf_SelectBarItemIcons[indexPath.item]];
        }
        [self.lgf_ChildVCCV scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        cell.lgf_BarIcon.transform = CGAffineTransformMakeScale(0.8, 0.8);
        [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:0.6 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            cell.lgf_BarIcon.transform = CGAffineTransformMakeScale(1.1, 1.1);
        } completion:nil];
    } else {
        cell.lgf_BarIcon.transform = CGAffineTransformIdentity;
        cell.lgf_Bartitle.textColor = self.lgf_UnSelectBarItemColor;
        if (self.lgf_IsNetImage) {
            lgf_SDImage(cell.lgf_BarIcon, self.lgf_UnSelectBarItemIcons[indexPath.item]);
        } else {
            cell.lgf_BarIcon.image = [UIImage imageNamed:self.lgf_UnSelectBarItemIcons[indexPath.item]];
        }
    }
    return cell;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.lgf_BarItemCV) {
        if (!(self.lgf_IsHaveCenterButton && indexPath.item == 2)) {
            lgf_HaveBlock(self.selectVC, self.lgf_BarChildVCs[indexPath.item]);
            if (self.shouldSelectItemAtIndexPath) {
                return self.shouldSelectItemAtIndexPath(indexPath);
            } else {
                return YES;
            }
        }
    }
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == self.lgf_BarItemCV) {
        if (self.lgf_DefultSelectIndex == indexPath.item) {
            [lgf_NCenter postNotificationName:LGFTabBarDoubleSelect object:@{@"LGFTabBarSelectIndex" : [NSString stringWithFormat:@"%ld", (long)indexPath.item]}];
        }
        self.lgf_DefultSelectIndex = indexPath.item;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 懒加载
- (NSMutableArray *)lgf_SelectBarItemIcons {
    if (!_lgf_SelectBarItemIcons) {
        _lgf_SelectBarItemIcons = [NSMutableArray new];
    }
    return _lgf_SelectBarItemIcons;
}

- (NSMutableArray *)lgf_UnSelectBarItemIcons {
    if (!_lgf_UnSelectBarItemIcons) {
        _lgf_UnSelectBarItemIcons = [NSMutableArray new];
    }
    return _lgf_UnSelectBarItemIcons;
}

- (NSArray *)lgf_BarItemTitles {
    if (!_lgf_BarItemTitles) {
        _lgf_BarItemTitles = [NSArray new];
    }
    return _lgf_BarItemTitles;
}

- (NSArray *)lgf_BarChildVCs {
    if (!_lgf_BarChildVCs) {
        _lgf_BarChildVCs = [NSArray new];
    }
    return _lgf_BarChildVCs;
}

@end

@implementation lgf_BarCell

@end


