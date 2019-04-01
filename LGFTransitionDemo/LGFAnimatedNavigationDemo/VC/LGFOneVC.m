//
//  LGFOneVC.m
//  LGFAnimatedNavigationDemo
//
//  Created by apple on 2019/4/1.
//  Copyright © 2019年 来国锋. All rights reserved.
//

#import "LGFOneVC.h"
#import "LGFPushVC.h"

@interface LGFOneVC ()

@end

@implementation LGFOneVC

lgf_SBViewControllerForM(LGFOneVC, @"Main", @"LGFOneVC");

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)goLGFPushVC:(UIButton *)sender {
    LGFPushVC *vc = [LGFPushVC lgf];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
