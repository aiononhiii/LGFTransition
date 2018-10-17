//
//  ViewController.m
//  LGFAnimatedNavigationDemo
//
//  Created by apple on 2018/6/19.
//  Copyright © 2018年 来国锋. All rights reserved.
//

#import "ViewController.h"
#import "LGFTabBarVC.h"

@interface ViewController ()

@end

@implementation ViewController

lgf_SBViewControllerForM(ViewController, @"Main", @"ViewController");

- (void)viewDidLoad {
    [super viewDidLoad];
    [lgf_NCenter addObserver:self selector:@selector(scrollToTop:) name:LGFTabBarDoubleSelect object:nil];
}

- (void)dealloc {
    [lgf_NCenter removeObserver:self];
    NSLog(@"ViewController 已释放");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollToTop:(NSNotification *)notif {
    NSDictionary *dict = notif.object;
    if ([dict[@"LGFTabBarSelectIndex"] integerValue] == 0) {
        [self.view lgf_ShowMessage:[NSString stringWithFormat:@"%@ 当前重复点击了, 这里添加滚到顶部代码", dict[@"LGFTabBarSelectIndex"]] animated:YES completion:^{
            
        }];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
