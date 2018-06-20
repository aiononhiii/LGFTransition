//
//  LGFNavigationBackButton.m
//  LGFOCTool
//
//  Created by apple on 2018/6/19.
//  Copyright © 2018年 来国锋. All rights reserved.
//

#import "LGFNavigationBackButton.h"

@implementation LGFNavigationBackButton

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self addTarget:self action:@selector(lgf_Back) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self addTarget:self action:@selector(lgf_Back) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)lgf_Back {
    UIViewController *superVC = [self lgf_GetSuperVC:self];
    if (superVC.navigationController) {
        [superVC.navigationController popViewControllerAnimated:YES];
    } else {
        NSAssert(superVC.navigationController, @"请给视图控制器添加 navigationController 再使用此控件");
    }
}

- (UIViewController*)lgf_GetSuperVC:(UIView *)view{
    id target = view;
    while (target) {
        target = ((UIResponder*)target).nextResponder;
        if ([target isKindOfClass:[UIViewController class]]) {
            break;
        }
    }
    return target;
}

@end
