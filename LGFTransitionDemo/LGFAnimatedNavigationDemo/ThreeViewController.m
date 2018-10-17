//
//  ThreeViewController.m
//  LGFAnimatedNavigationDemo
//
//  Created by apple on 2018/7/2.
//  Copyright © 2018年 来国锋. All rights reserved.
//

#import "ThreeViewController.h"
#import "LGFTabBarVC.h"

@interface ThreeViewController ()

@end

@implementation ThreeViewController

lgf_SBViewControllerForM(ThreeViewController, @"Main", @"ViewController");

- (void)viewDidLoad {
    [super viewDidLoad];
    [lgf_NCenter addObserver:self selector:@selector(scrollToTop:) name:LGFTabBarDoubleSelect object:nil];
}

- (void)dealloc {
    [lgf_NCenter removeObserver:self];
}

- (void)scrollToTop:(NSNotification *)notif {
    NSDictionary *dict = notif.object;
    if ([dict[@"LGFTabBarSelectIndex"] integerValue] == 2) {
        [self.view lgf_ShowMessage:[NSString stringWithFormat:@"%@ 当前重复点击了, 这里添加滚到顶部代码", dict[@"LGFTabBarSelectIndex"]] animated:YES completion:^{
            
        }];
    }
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
