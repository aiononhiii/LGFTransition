//
//  TabBarVC.m
//  LGFAnimatedNavigationDemo
//
//  Created by apple on 2018/7/2.
//  Copyright © 2018年 来国锋. All rights reserved.
//

#import "TabBarVC.h"
#import "TwoViewController.h"
#import "ViewController.h"
#import "ThreeViewController.h"

@interface TabBarVC ()
@property (nonatomic, strong) LGFTabBarVC *tabvc;
@end

@implementation TabBarVC

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tabvc = [LGFTabBarVC lgf_SBViewController];
    ViewController *vc = [ViewController lgf_SBViewController];
    TwoViewController *twovc = [TwoViewController lgf_SBViewController];
    ThreeViewController *threevc = [ThreeViewController lgf_SBViewController];
    TwoViewController *fourvc = [TwoViewController lgf_SBViewController];
    TwoViewController *fivevc = [TwoViewController lgf_SBViewController];
    
    _tabvc.lgf_BarChildVCs = @[vc, twovc, threevc, fourvc, fivevc];
    _tabvc.lgf_BarItemTitles = @[@"首页", @"微淘", @"", @"购物车", @"我的淘宝"];
    _tabvc.lgf_SelectBarItemIcons = @[@"select", @"select", @"", @"select", @"select"];
    _tabvc.lgf_UnSelectBarItemIcons = @[@"unselect", @"unselect", @"", @"unselect", @"unselect"];
    _tabvc.lgf_SelectBarItemColor = [UIColor redColor];
    _tabvc.lgf_UnSelectBarItemColor = [UIColor darkGrayColor];
    _tabvc.lgf_DefultSelectIndex = 4;
    [_tabvc lgf_TabBarVCShowInView:self];
    
    UIButton *centerBtn = [_tabvc lgf_TabBarShowCenterBtnWithTop:35 size:CGSizeMake(60, 60)];
    centerBtn.backgroundColor = [UIColor whiteColor];
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [_tabvc lgf_ShowTabBar];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [_tabvc lgf_HideTabBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
