//
//  LGFPushVC.m
//  LGFAnimatedNavigationDemo
//
//  Created by apple on 2019/4/1.
//  Copyright © 2019年 来国锋. All rights reserved.
//

#import "LGFPushVC.h"
#import "LGFTool.h"

@interface LGFPushVC ()

@end

@implementation LGFPushVC

lgf_SBViewControllerForM(LGFPushVC, @"Main", @"LGFPushVC");

- (void)viewDidLoad {
    [super viewDidLoad];
    [LGFTool lgf_AddNavigationBar:self.view title:@"push 进来的页面"];
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
