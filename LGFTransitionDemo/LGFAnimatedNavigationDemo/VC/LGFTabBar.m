//
//  LGFTabBar.m
//  LGFAnimatedNavigationDemo
//
//  Created by apple on 2019/4/1.
//  Copyright © 2019年 来国锋. All rights reserved.
//

#import "LGFTabBar.h"
#import "LGFOneVC.h"
#import "LGFTwoVC.h"
#import "LGFThreeVC.h"
#import "LGFPushVC.h"

@interface LGFTabBar ()
@property (strong, nonatomic) UIButton *center;
@end

@implementation LGFTabBar

lgf_SBViewControllerForM(LGFTabBar, @"Main", @"LGFTabBar");

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.tabvc lgf_ShowTabBar];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.tabvc lgf_HideTabBar];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.view.backgroundColor = [UIColor blackColor];
    self.tabvc = [LGFTabBarVC lgf];
    // 配置子控制器
    self.tabvc.lgf_BarChildVCs = @[[LGFOneVC lgf], [UIViewController new], [LGFThreeVC lgf]];
    // 配置标
    self.tabvc.lgf_BarItemTitles = @[@"左边", @"", @"右边"];
    self.tabvc.lgf_SelectBarItemColor = [UIColor redColor];
    self.tabvc.lgf_UnSelectBarItemColor = [UIColor lightGrayColor];
    // 配置标图片
    self.tabvc.lgf_SelectBarItemIcons = [NSMutableArray arrayWithArray:@[@"select",
                                                                         @"",
                                                                         @"select"]];
    self.tabvc.lgf_UnSelectBarItemIcons = [NSMutableArray arrayWithArray:@[@"unselect",
                                                                           @"",
                                                                           @"unselect"]];
    [self.tabvc lgf_TabBarVCShowInView:self];
    // 默认选中
    self.tabvc.lgf_DefultSelectIndex = 0;
    @lgf_Weak(self);
    
    // 将要点击某个 item, BOOL返回值决定点击是否要继续
    self.tabvc.shouldSelectItemAtIndexPath = ^BOOL(NSIndexPath *indexPath) {
        return YES;
    };
    
    // 点击某个 item
    self.tabvc.selectVC = ^(UIViewController *vc) {
        @lgf_Strong(self);
        self.selectVC = vc;
    };
    
    // 配置中间按钮
    self.center = [self.tabvc lgf_TabBarShowCenterBtnWithTop:-8  size:CGSizeMake(50, 50)];
    self.center.clipsToBounds = YES;
    [self.center setImage:lgf_Image(@"centerIcon") forState:UIControlStateNormal];
    
    // 点击中间按钮
    self.tabvc.centerBtnSelect = ^(UIButton *sender) {
        @lgf_Strong(self);
        LGFPushVC *vc = [LGFPushVC lgf];
        [self presentViewController:vc animated:YES completion:nil];
    };
    
    [self.tabvc.lgf_BarItemCV reloadData];
}

@end
