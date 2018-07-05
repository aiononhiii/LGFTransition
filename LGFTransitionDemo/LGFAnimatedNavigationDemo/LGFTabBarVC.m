//
//  LGFTabBarVC.m
//  LGFAnimatedNavigationDemo
//
//  Created by apple on 2018/6/29.
//  Copyright © 2018年 来国锋. All rights reserved.
//

#import "LGFTabBarVC.h"
#import "TwoViewController.h"
#import "ViewController.h"

@interface LGFTabBarVC () <UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lgf_TabBarBottom;
@end

@implementation LGFTabBarVC

lgf_SBViewControllerForM(LGFTabBarVC, @"LGFTabBarVC", @"LGFTabBarVC");

- (NSArray *)lgf_BarChildVCs {
    if (!_lgf_BarChildVCs) {
        _lgf_BarChildVCs = [NSArray new];
    }
    return _lgf_BarChildVCs;
}

- (NSArray *)lgf_SelectBarItemIcons {
    if (!_lgf_SelectBarItemIcons) {
        _lgf_SelectBarItemIcons = [NSArray new];
    }
    return _lgf_SelectBarItemIcons;
}

- (NSArray *)lgf_UnSelectBarItemIcons {
    if (!_lgf_UnSelectBarItemIcons) {
        _lgf_UnSelectBarItemIcons = [NSArray new];
    }
    return _lgf_UnSelectBarItemIcons;
}

- (NSArray *)lgf_BarItemTitles {
    if (!_lgf_BarItemTitles) {
        _lgf_BarItemTitles = [NSArray new];
    }
    return _lgf_BarItemTitles;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_lgf_ShowTopShadow) {
        _lgf_TabBarBackView.layer.shadowOpacity = 0.1;
        _lgf_TabBarBackView.layer.shadowColor = [UIColor lightGrayColor].CGColor;
        _lgf_TabBarBackView.layer.shadowRadius = 3.0;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)lgf_TabBarVCShowInView:(UIViewController *)vc {
    for (UIViewController *vc in self.lgf_BarChildVCs) {
        vc.view.frame = self.view.bounds;
        [self addChildViewController:vc];
    }
    [vc addChildViewController:self];
    [vc.view addSubview:self.view];
}

- (UIButton *)lgf_TabBarShowCenterBtnWithTop:(CGFloat)top size:(CGSize)size {
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake((lgf_ScreenWidth / 2) - (size.width / 2), top, size.width, size.height)];
    btn.layer.cornerRadius = size.height / 2;
    [btn addTarget:self action:@selector(lgf_SelectCenterButton:) forControlEvents:UIControlEventTouchUpInside];
    [self.lgf_TabBarBackView addSubview:btn];
    return btn;
}

- (void)lgf_SelectCenterButton:(UIButton *)sender {
    [self collectionView:_lgf_BarItemCV didSelectItemAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]];
}

- (void)lgf_ShowTabBar {
    if (_lgf_TabBarBottom.constant < 0.0) {
        _lgf_TabBarBottom.constant = 0.0;
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
        }];
    }
}

- (void)lgf_HideTabBar {
    if (_lgf_TabBarBottom.constant == 0.0) {
        _lgf_TabBarBottom.constant = -98;
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            [self.view layoutIfNeeded];
        } completion:^(BOOL finished) {
        }];
    }
}

#pragma mark - Collection View DataSource And Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (collectionView == _lgf_ChildVCCV) {
        return self.lgf_BarChildVCs.count;
    }
    if (self.lgf_BarItemTitles.count < self.lgf_BarChildVCs.count || self.lgf_SelectBarItemIcons.count < self.lgf_BarChildVCs.count || self.lgf_UnSelectBarItemIcons.count < self.lgf_BarChildVCs.count) {
        return 0;
    }
    return self.lgf_BarItemTitles.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _lgf_ChildVCCV) {
        return CGSizeMake(_lgf_ChildVCCV.frame.size.width, _lgf_ChildVCCV.frame.size.height);
    }
    return CGSizeMake(_lgf_BarItemCV.frame.size.width / self.lgf_BarItemTitles.count, _lgf_BarItemCV.frame.size.height);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _lgf_ChildVCCV) {
        UICollectionViewCell *cell = lgf_CVGetCell(collectionView, UICollectionViewCell, indexPath);
        [cell.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        UIViewController *vc = self.lgf_BarChildVCs[indexPath.item];
        vc.view.frame = cell.bounds;
        [cell addSubview:vc.view];
        return cell;
    }
    lgf_BarCell *cell = lgf_CVGetCell(collectionView, lgf_BarCell, indexPath);
    if ([self.lgf_SelectBarItemIcons[indexPath.item] isEqualToString:@""]) {
        cell.hidden = YES;
    }
    cell.lgf_Bartitle.text = self.lgf_BarItemTitles[indexPath.item];
    cell.lgf_BarIcon.transform = CGAffineTransformIdentity;
    if (indexPath.item == self.lgf_DefultSelectIndex) {
        cell.lgf_Bartitle.textColor = self.lgf_SelectBarItemColor;
        cell.lgf_BarIcon.image = [UIImage imageNamed:self.lgf_SelectBarItemIcons[indexPath.item]];
        [_lgf_ChildVCCV scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
        [UIView animateWithDuration:0.6 delay:0.0 usingSpringWithDamping:0.2 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            cell.lgf_BarIcon.transform = CGAffineTransformScale(cell.lgf_BarIcon.transform, 1.2, 1.2);
        } completion:nil];
    } else {
        cell.lgf_Bartitle.textColor = self.lgf_UnSelectBarItemColor;
        cell.lgf_BarIcon.image = [UIImage imageNamed:self.lgf_UnSelectBarItemIcons[indexPath.item]];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == _lgf_BarItemCV) {
        lgf_BarCell *cell = (lgf_BarCell *)[collectionView cellForItemAtIndexPath:indexPath];
        if (self.lgf_DefultSelectIndex != indexPath.item) {
            self.lgf_DefultSelectIndex = indexPath.item;
            [collectionView reloadData];
        } else {
            cell.lgf_BarIcon.transform = CGAffineTransformIdentity;
            [UIView animateWithDuration:0.6 delay:0.0 usingSpringWithDamping:0.2 initialSpringVelocity:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                cell.lgf_BarIcon.transform = CGAffineTransformScale(cell.lgf_BarIcon.transform, 1.2, 1.2);
            } completion:^(BOOL finished) {
                [lgf_NCenter postNotificationName:LGFTabBarDoubleSelectNotification object:@{@"LGFTabBarSelectIndex" : [NSString stringWithFormat:@"%ld", (long)indexPath.item]}];
            }];
        }
    }
}

@end

@implementation lgf_BarCell

@end


